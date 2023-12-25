import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(const GoogleMapsApp());
}

class GoogleMapsApp extends StatelessWidget {
  const GoogleMapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyMap(),
    );
  }
}

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Completer<GoogleMapController> _controller = Completer();
  List<LatLng> _polylineCoordinates = [];
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  late LatLng _currentPosition;
  LatLng? _selectedPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    Timer.periodic(Duration(seconds: 10), (Timer timer) async {
      await _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    LocationData locationData = await _getLocation();
    setState(() {
      _currentPosition =
          LatLng(locationData.latitude!, locationData.longitude!);
      _markers = {
        Marker(
          markerId: MarkerId("current_location"),
          position: _currentPosition,
          infoWindow: InfoWindow(
            title: "My Current Location",
            snippet:
                "${_currentPosition.latitude}, ${_currentPosition.longitude}",
          ),
        ),
      };
      _polylineCoordinates.add(_currentPosition);
    });

    _animateToUserLocation();
  }

  Future<LocationData> _getLocation() async {
    Location location = Location();
    return await location.getLocation();
  }

  void _animateToUserLocation() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentPosition,
          zoom: 15.0,
        ),
      ),
    );
  }

  void _updatePolyline(LatLng newPosition) {
    setState(() {
      _polylineCoordinates.add(newPosition);
      _polylines = {
        Polyline(
          polylineId: PolylineId("user_route"),
          color: Colors.blue,
          points: _polylineCoordinates,
          width: 5,
        ),
      };
      _markers.add(
        Marker(
          markerId: MarkerId("previous_location"),
          position: newPosition,
          infoWindow: InfoWindow(title: "Previous Location"),
        ),
      );
    });
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedPosition = position;
      _markers.add(
        Marker(
          markerId: MarkerId("selected_location"),
          position: position,
          infoWindow: InfoWindow(title: "Selected Location"),
        ),
      );
      if (_currentPosition != null) {
        _updatePolyline(position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Location Tracker'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: (position) => _onMapTapped(position),
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 2.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}
