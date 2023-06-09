import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/models/api.dart';
import 'package:wave/services/aad.dart';
import 'package:wave/services/geolocator.dart';

enum SortType { asc, desc }

enum SortCryteria { startTimestamp, endTimeStamp, name }

class ApiService {
  late Dio dioClient;
  static final ApiService apiService = ApiService._();
  ApiService._() {
    dioClient = Dio(baseOptions);
    dioClient.interceptors.add(CustomInterceptors(dioClient));
  }

  static ApiService getInstance() {
    return apiService;
  }

  final Map<String, String> sortingParams = {
    'startTimestamp': 'availabilityDeclaration.startTimestamp',
    'endTimestamp': 'availabilityDeclaration.endTimestamp',
    'name': 'name'
  };

  final Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();

  BaseOptions baseOptions = BaseOptions(
    baseUrl: dotenv.env['SERVER_API_BASE_URL']!,
    connectTimeout: const Duration(milliseconds: 5000),
    receiveTimeout: const Duration(milliseconds: 5000),
    sendTimeout: const Duration(milliseconds: 5000),
  );

  Future<bool> saveValue(String key, String? patrolId) async {
    if (patrolId != null) {
      final SharedPreferences sharedPrefs = await sharedPreferences;
      return await sharedPrefs.setString(key, patrolId);
    }
    return false;
  }

  Future<String?> getValue(String key) async {
    final SharedPreferences sharedPrefs = await sharedPreferences;
    String? patrolId = sharedPrefs.getString(key);
    return patrolId;
  }

  Future<bool> deleteValue(String key) async {
    final SharedPreferences sharedPrefs = await sharedPreferences;
    return sharedPrefs.remove(key);
  }

  Future<Either<Exception, Patrol?>> createPatrol(DateTime endTimestamp) async {
    Declaration declaration = Declaration.patrol(endTimestamp);
    Patrol patrol = Patrol(null, declaration);
    Response response = await dioClient.post('patrols', data: patrol.toJson());
    if (response.statusCode == 201) {
      Patrol patrol = Patrol.fromJson(response);
      await saveValue('patrolId', patrol.id.toString());
      return Right(patrol);
    } else if (response.statusCode == 400) {
      return Left(
        Exception(response.data['message'] ?? 'Something went wrong'),
      );
    }
    return const Right(null);
  }

  Future<Either<Exception, Duty?>> createDuty(
      DateTime? startTimestamp,
      DateTime endTimestamp,
      int mobilisationTime,
      MobilisationPlace mobilisationPlace) async {
    Declaration declaration = Declaration.duty(startTimestamp, endTimestamp);
    Duty duty = Duty(declaration, mobilisationPlace, mobilisationTime);
    Response response = await dioClient.post('duties', data: duty.toJson());
    if (response.statusCode == 201) {
      Duty duty = Duty.fromJson(response);
      await saveValue('dutyId', duty.id);
      return Right(duty);
    } else if (response.statusCode == 400) {
      return Left(
        Exception(response.data['message'] ?? 'Something went wrong'),
      );
    }
    return const Right(null);
  }

  Future<Patrol?> getActivePatrol() async {
    Response response = await dioClient.get('users/patrols/active');
    if (response.statusCode == 200) {
      Patrol activePatrol = Patrol.fromJson(response);
      await deleteValue('patrolId');
      await saveValue('patrolId', activePatrol.id);
      return activePatrol;
    }
    return null;
  }

  Future<Duty?> getCurrentDuty() async {
    Response response = await dioClient.get('users/duties/current');
    if (response.statusCode == 200) {
      Duty activeDuty = Duty.fromJson(response);
      await deleteValue('dutyId');
      await saveValue('dutyId', activeDuty.id);
      return activeDuty;
    }
    return null;
  }

  Future<Either<Exception, bool?>> confirmDuty(bool confirmation) async {
    String? dutyId = await getValue('dutyId');
    Duty duty = Duty.confirmation(dutyId, confirmation);
    Response response = await dioClient.post('duties-confirmations',
        queryParameters: duty.toConfirmJson());
    if (response.statusCode == 200) {
      return const Right(true);
    } else if (response.statusCode == 400) {
      return Left(
        Exception(response.data['message'] ?? 'Something went wrong'),
      );
    }
    return const Right(false);
  }

  Future<dynamic> getActiveStatus() async {
    GeolocatorService geolocatorService = GeolocatorService.getInstance();
    Patrol? activePatrol = await getActivePatrol();
    Duty? activeDuty = await getCurrentDuty();
    if (activeDuty != null) {
      await geolocatorService.cancelPositionSubscription();
      return activeDuty;
    } else if (activePatrol != null) {
      return activePatrol;
    } else {
      await geolocatorService.cancelPositionSubscription();
      return null;
    }
  }

  Future<List<dynamic>?> getMobilisationPlaces(String? filter) async {
    Response response = await dioClient
        .get('/places-locations?type=MOBILISATION_POINT&name=$filter');
    if (response.statusCode == 200) {
      return response.data;
    }
    return null;
  }

  Future<void> finishDuty() async {
    String? dutyId = await getValue('dutyId');
    Response response = await dioClient.delete('/duties/$dutyId');
    if (response.statusCode == 200) {
      await deleteValue('dutyId');
    }
  }

  Future<void> deleteFutureDuty(String dutyId) async {
    Response response = await dioClient.delete('/duties/$dutyId');
    if (response.statusCode == 200) {}
  }

  Future<void> finishPatrol() async {
    String? patrolId = await getValue('patrolId');
    Response response = await dioClient.delete('/patrols/$patrolId');
    if (response.statusCode == 200) {
      await deleteValue('patrolId');
    }
  }

  Future<Either<Exception, Patrol?>> updatePatrol(
      DateTime? endTimestamp) async {
    String? patrolId = await getValue('patrolId');
    Declaration declaration = Declaration.patrol(endTimestamp);
    Patrol patrol = Patrol(null, declaration);
    Response response = await dioClient.patch(
      '/patrols/$patrolId',
      data: patrol.toJson(),
    );
    if (response.statusCode == 200) {
      return Right(Patrol.fromJson(response));
    } else if (response.statusCode == 400) {
      return Left(
        Exception(response.data['message'] ?? 'Something went wrong'),
      );
    }
    return const Right(null);
  }

  Future<Either<Exception, Duty?>> updateDuty(
    String? id,
    DateTime? startTimestamp,
    DateTime? endTimestamp,
    int? mobilisationTime,
    MobilisationPlace? mobilisationPlace,
  ) async {
    String? dutyId = id ?? await getValue('dutyId');
    Declaration? declaration = Declaration.duty(startTimestamp, endTimestamp);
    Duty duty = Duty(declaration, mobilisationPlace, mobilisationTime);
    Response response = await dioClient.patch(
      '/duties/$dutyId',
      data: duty.toJson(),
    );
    if (response.statusCode == 200) {
      return Right(Duty.fromJson(response));
    } else if (response.statusCode == 400) {
      return Left(
        Exception(response.data['message'] ?? 'Something went wrong'),
      );
    }
    return const Right(null);
  }

  Future<List<dynamic>> getPastDuties(
    int page,
    int limit,
    SortCryteria sortCryteria,
    SortType sortType,
  ) async {
    Map<String, dynamic> queryParams = {
      'page': page,
      'size': limit,
      'sort': '${sortingParams[sortCryteria.name]},${sortType.name}'
    };
    baseOptions.queryParameters.addAll(queryParams);
    Response response = await dioClient.get('users/duties/past');
    baseOptions.queryParameters.clear();
    return response.data['content'];
  }

  Future<List<dynamic>> getPastPatrols(
      int page, int limit, SortCryteria sortCryteria, SortType sortType) async {
    Map<String, dynamic> queryParams = {
      'page': page,
      'size': limit,
      'sort': '${sortingParams[sortCryteria.name]},${sortType.name}'
    };
    baseOptions.queryParameters.addAll(queryParams);
    Response response = await dioClient.get('users/patrols/past');
    baseOptions.queryParameters.clear();
    return response.data['content'];
  }

  Future<List<dynamic>?> getScheduledDuties(
      int page, int limit, SortCryteria sortCryteria, SortType sortType) async {
    Map<String, dynamic> queryParams = {
      'page': page,
      'size': limit,
      'sort': '${sortingParams[sortCryteria.name]},${sortType.name}'
    };
    baseOptions.queryParameters.addAll(queryParams);
    Response response = await dioClient.get('users/duties/scheduled');
    baseOptions.queryParameters.clear();
    return response.data['content'];
  }
}

class CustomInterceptors extends InterceptorsWrapper {
  final Dio dioClient;
  AADService aadService = AADService();

  CustomInterceptors(this.dioClient);

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? accessToken = await aadService.oauth.getAccessToken();
    final bearerHeader = <String, String>{
      'Authorization': 'Bearer $accessToken'
    };
    options.headers.addAll(bearerHeader);
    log('HTTP REQUEST [${options.method}] => PATH: ${options.path}, PARAMS: ${options.queryParameters}');
    return super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) {
    log('HTTP RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) async {
    log('HTTP ERROR [${err.response?.statusCode}]  path: ${err.requestOptions.path}');
    switch (err.response?.statusCode) {
      case 400:
        handler.resolve(err.response!);
        break;
      case 401:
        await aadService.oauth.login(refreshIfAvailable: true);
        String? accessToken = await aadService.oauth.getAccessToken();
        final bearerHeader = <String, String>{
          'Authorization': 'Bearer $accessToken'
        };
        final requestOptions =
            Options(method: err.requestOptions.method, headers: bearerHeader);
        final request = await dioClient.request(
          err.requestOptions.path,
          options: requestOptions,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );
        handler.resolve(request);
        break;
      case 403:
        handler.resolve(err.response!);
        break;
      case 404:
        handler.resolve(err.response!);
        break;
      case 500:
        handler.resolve(err.response!);
        break;
      case 503:
        Fluttertoast.showToast(msg: 'Server error');
        handler.resolve(err.response!);
        break;
      default:
        Fluttertoast.showToast(
            msg:
                'Connection error. Please check your internet connection and try again.',
            toastLength: Toast.LENGTH_LONG);
        if (err.response != null) {
          log(err.response.toString());
        }
        handler.resolve(err.response ??
            Response(statusCode: 408, requestOptions: err.requestOptions));
        break;
    }
  }
}
