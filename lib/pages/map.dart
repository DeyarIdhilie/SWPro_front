import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}): super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
   final Completer<GoogleMapController> _controller = Completer();
  // final prefs = await SharedPreferences.getInstance();
  //  double? latitude = 
  //  prefs.setDouble("latitude",latitude!);
  //  double? longitude = _currentPosition?.longitude;
  //   prefs.setDouble("longitude",longitude!);
  static const CameraPosition initialPosition = CameraPosition(target: LatLng(32.3039, 35.1267),zoom:14.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(initialCameraPosition: initialPosition,mapType: MapType.normal, onMapCreated: (GoogleMapController controller){
        _controller.complete(controller);
      },)
    );
  }
}