import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_task/ui/LoginScreen.dart';
import 'package:flutter_demo_task/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {

  final List<Marker> _marker = [
    Marker(markerId: MarkerId("1"),
    position: LatLng(28.64616831892535, 77.36121099500487),
    infoWindow: InfoWindow(title: "My Location"),
    )
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Completer<GoogleMapController> _completer = Completer();
  static const CameraPosition _cameraPosition = CameraPosition(
      target: LatLng(28.64616831892535, 77.36121099500487),
       zoom: 14.4746);

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            logout();
          },
              icon: const Icon(Icons.logout))
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: GoogleMap(
              initialCameraPosition: _cameraPosition,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              markers: Set<Marker>.of(_marker),
              onMapCreated: (GoogleMapController controller){
                _completer.complete(controller);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        getUserCurrentLocation().then((value) async {
          debugPrint("Lat Long : ${value.latitude} ${value.longitude}");

          _marker.add(
            Marker(markerId: const MarkerId("2"),
              position: LatLng(value.latitude, value.longitude),
              infoWindow: const InfoWindow(
                title: "current location"
              )
            )
          );

          CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
          zoom: 14.4746);

          final GoogleMapController controller = await _completer.future;
          
          controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
          setState(() {

          });
        });
      },
        child: Icon(Icons.location_searching),

      ),
    );
  }

  Future<Position> getUserCurrentLocation() async{
    await Geolocator.requestPermission().then((value){

    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  void loadLocation(){
    getUserCurrentLocation().then((value) async {
      debugPrint("Lat Long : ${value.latitude} ${value.longitude}");

      _marker.add(
          Marker(markerId: const MarkerId("3"),
              position: LatLng(value.latitude, value.longitude),
              infoWindow: const InfoWindow(
                  title: "current location"
              )
          )
      );

      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 14.4746);

      final GoogleMapController controller = await _completer.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {

      });
    });
  }

  Future<void> logout() async{
    await _auth.signOut().then((value) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginScreen()));
      Utils().toastMessage("user logout");
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
    });
  }
}
