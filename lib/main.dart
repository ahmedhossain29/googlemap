import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'location_screen.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController googleMapController;
  Location location = Location();

  Future<void> getCurrentLocation() async {
    final LocationData locationData = await location.getLocation();
    // googleMapController.moveCamera(
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(
    //       target: LatLng(locationData.longitude!, locationData.longitude!),
    //     ),
    //   ),
    // );

    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(locationData.longitude!, locationData.longitude!),
            zoom: 17),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
            zoom: 19,
            target: LatLng(23.792265005916146, 90.40561775869223),
            bearing: 0,
            tilt: 5),
        // onTap: (LatLng position) {
        //   print(position);
        // },
        // onLongPress: (LatLng latLng) {
        //   print('On long press at $latLng');
        // },
        // onCameraMove: (cameraPosition) {
        //   print(cameraPosition);
        // },
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
          getCurrentLocation();
        },

        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        compassEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        // markers: {
        //   Marker(
        //       markerId: const MarkerId('initialPosition'),
        //       position: const LatLng(23.792265005916146, 90.40561775869223),
        //       infoWindow: const InfoWindow(
        //           title: 'My current location', snippet: 'LatLng'),
        //       draggable: true,
        //       onDragEnd: (LatLng position) {
        //         print(position);
        //       }),
        //   const Marker(
        //     markerId: MarkerId('initialPosition'),
        //     position: LatLng(23.791865005916146, 90.40561775869223),
        //     infoWindow:
        //         InfoWindow(title: 'My current location', snippet: 'LatLng'),
        //     draggable: true,
        //   ),
        // },
        // polylines: {
        //   const Polyline(polylineId: PolylineId('basic-line'), points: [
        //     LatLng(23.792265005916146, 90.40561775869223),
        //     LatLng(23.791865005916146, 90.40561775869223),
        //   ])
        // },
      ),
    );
  }
}
