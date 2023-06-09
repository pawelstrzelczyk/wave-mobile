import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave/extensions/context.dart';
import 'package:wave/pages/holder/home/patrol.dart';

///Customised [FlutterMap] used on [PatrolPage] to display user location
class WaveMap extends StatelessWidget {
  final MapController mapController;
  final List<Marker> markers;

  const WaveMap({
    super.key,
    required this.mapController,
    required this.markers,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * .30,
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(
            52.429541,
            16.875312,
          ),
          maxZoom: 19,
          zoom: 19.0,
          enableScrollWheel: true,
          interactiveFlags: InteractiveFlag.all,
        ),
        mapController: mapController,
        nonRotatedChildren: [
          AttributionWidget(
            attributionBuilder: (context) {
              return GestureDetector(
                child: Stack(
                  children: [
                    Text(
                      context.translated.osmContribution,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        background: Paint()..color = Colors.white,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  launchUrl(
                    Uri.parse('https://www.openstreetmap.org/copyright'),
                  );
                },
              );
            },
          )
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'pl.put.wave',
            subdomains: const ['a', 'b', 'c'],
            maxNativeZoom: 19,
            maxZoom: 19,
            backgroundColor: context.theme.scaffoldBackgroundColor,
          ),
          MarkerLayer(
            markers: markers,
          ),
        ],
      ),
    );
  }
}
