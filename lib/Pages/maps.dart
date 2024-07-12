import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapsPage extends StatelessWidget {
  final LatLng? currentLocation;

  const MapsPage({super.key, this.currentLocation});

  final String apiKey = "DG35lTv6dayKzyO33chnPGKvEQABRtey";

  @override
  Widget build(BuildContext context) {
    // LatLng defaultLocation = const LatLng(19.871246, 75.370967);
    // LatLng displayLocation = currentLocation ?? defaultLocation;
    return currentLocation == null
        ? Center(
            child: ImageIcon(
              const AssetImage('assets/icons/map.png'),
              size: MediaQuery.of(context).size.width * 0.1,
            ),
          )
        : FlutterMap(
            options: MapOptions(
              initialCenter: currentLocation!,
              initialZoom: 16.0,
            ),
            children: [
              TileLayer(
                additionalOptions: {"apiKey": apiKey},
                urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
                    "{z}/{x}/{y}.png?key={apiKey}",
                tileProvider: NetworkTileProvider(),
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 70.0,
                    height: 70.0,
                    point: currentLocation!,
                    child: Icon(
                      Icons.location_on_outlined,
                      size: MediaQuery.of(context).size.width * 0.1,
                      color: const Color.fromARGB(255, 166, 59, 59),
                    ),
                  )
                ],
              ),
            ],
          );
  }
}
