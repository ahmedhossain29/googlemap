import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Location Updates'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 15.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  // Fetch the user's location every 10 seconds
  void _getLocation() {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      Position position = await Geolocator.getCurrentPosition();

      _updateMarker(position);
    });
  }

  // Update the marker's position on the map
  void _updateMarker(Position position) {
    LatLng latLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId("user_location"),
          position: latLng,
          infoWindow: InfoWindow(title: "User Location"),
        ),
      );
    });

    _moveCamera(latLng);
  }

  // Move the camera to the updated marker position
  void _moveCamera(LatLng latLng) async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(latLng));
  }
}
