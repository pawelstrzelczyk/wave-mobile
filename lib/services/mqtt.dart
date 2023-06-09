import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:latlong2/latlong.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:wave/models/mqtt.dart';
import 'package:wave/services/aad.dart';
import 'package:wave/services/api.dart';
import 'package:wave/services/geolocator.dart';

class MqttService {
  final ApiService apiService;
  MqttServerClient client = MqttServerClient(dotenv.env['MQTT_URL']!, '');

  AADService aadService = AADService();

  String pubTopic = 'location-update/';
  int pongCount = 0;

  MqttService(this.apiService);

  connect(String oid) async {
    String? accessToken = await aadService.oauth.getAccessToken();
    String? oid;
    if (accessToken != null) {
      oid = await JwtDecoder.decode(accessToken)['oid'];
    }
    String? username = oid;
    String? password = accessToken;

    client.port = 8883;
    client.logging(on: false);
    client.setProtocolV311();
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.secure = true;
    client.onSubscribed = onSubscribed;
    client.autoReconnect = true;
    client.onAutoReconnected = onAutoReconnected;

    try {
      log('connecting');
      await client.connect(username, password);
      if (accessToken != null) {
        await subscribe(oid!);
      }
    } on NoConnectionException catch (e) {
      log('client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      log('socket exception - $e');
      client.disconnect();
    } on HandshakeException catch (e) {
      log('handshake exception - $e');
      client.disconnect();
    } on OSError catch (e) {
      log('os exception - $e');
      client.disconnect();
    }
  }

  send(String payload, String oid) async {
    final builder = MqttClientPayloadBuilder();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      log('flutter client is connected');
      builder.addString(payload);
      client.publishMessage(
          pubTopic + oid, MqttQos.exactlyOnce, builder.payload!);
    } else {
      log('flutter client connection failed - reconnecting, status is ${client.connectionStatus}');
      await connect(oid);
    }
  }

  onDisconnected() {
    log('client callback - client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      log('disconnection requested by client');
    } else {
      log('disconnection incorrect (for example, due to connection failure)');
    }
    if (pongCount == 3) {
      log('pong count is correct');
    } else {
      log('pong count is incorrect, expected 3. actual $pongCount');
    }
  }

  onConnected() async {
    log('Flutter client successfully connected');
  }

  onSubscribed(String topic) {
    log('subscribed to $topic');
  }

  preparePayloadAndPublish(DateTime dateTime, LatLng latLng) async {
    JsonEncoder jsonEncoder = const JsonEncoder();
    String? token = await aadService.oauth.getAccessToken();
    String? patrolId = await apiService.getValue('patrolId');

    if (token != null) {
      Payload payload = Payload(
        dateTime.toUtc().toIso8601String(),
        MqttLocation(latLng),
        patrolId!,
      );
      String oid = JwtDecoder.decode(token)['oid'];
      Map<String, dynamic> data = <String, dynamic>{};
      data.addAll(payload.toJson());

      await send(jsonEncoder.convert(payload), oid);
    } else {
      await aadService.oauth.login(refreshIfAvailable: true);
      return null;
    }
  }

  subscribe(String oid) async {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client.subscribe('patrol-cancel/$oid', MqttQos.exactlyOnce);
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) async {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final String pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        log('flutter client received message: $pt from topic: ${c[0].topic}>');
        MqttPatrolExpirationMessage message =
            MqttPatrolExpirationMessage.fromJson(jsonDecode(pt));
        String? currentPatrolId = await apiService.getValue('patrolId');
        if (message.expiredDeclarationId == currentPatrolId) {
          GeolocatorService geolocatorService = GeolocatorService.getInstance();
          log('patrol cancelled');
          await geolocatorService.cancelPositionSubscription();
        }
      });
    } else {
      await subscribe(oid);
    }
  }

  onAutoReconnected() async {
    log('client callback - auto reconnected');
    await apiService.getActiveStatus();
  }
}
