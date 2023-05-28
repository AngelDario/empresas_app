import 'dart:async';
import 'package:empresas_cliente/screens/history.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:empresas_cliente/services/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:empresas_cliente/screens/account.dart';
import 'package:geocoding/geocoding.dart';
import 'package:empresas_cliente/screens/maps.dart';

// Insertar en la base de datos los datos del usuario
// Datos necesarios son: nombre, email, foto

class HomePage extends StatefulWidget {
  // final Function() saveUserDataToFirebase;
  const HomePage({
    super.key,
    // required this.saveUserDataToFirebase
    });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, dynamic> currentLocation;
  bool isInitAddress = true;
  late String address;

  void _recibirVariable(String variable) {
    setState(() {
       address = variable;
    });  
    //print(address);
  }
  
  Future<Map<String, dynamic>> getCurrentLocation() async{
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final latitude = position.latitude;
    final longitude = position.longitude;
    currentLocation = {
      'latitude': latitude,
      'longitude': longitude,
    };
    return currentLocation;
  }
  Future<String> getAddressFromCoordinates(dynamic longitude, dynamic latitude) async {
    
    // final databaseReference = FirebaseDatabase.instance.ref().child('clients').child(FirebaseAuth.instance.currentUser!.uid);
    // DatabaseEvent event = await databaseReference.once();
    // Map<dynamic,dynamic> data = event.snapshot.value as Map<dynamic,dynamic>;
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0]; // Selecciona el primer resultado
    String addr = "${place.street}, ${place.locality}, ${place.country}";
    //print(address);
    return addr; // Imprime la dirección obtenida
  }

  late OverlayEntry overlayEntry;

  void closeMap(){
    overlayEntry.remove();
  }
  
  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: SafeArea( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
              child: FutureBuilder(
                future: getCurrentLocation(),
                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    final latitude = snapshot.data!['latitude'];
                    final longitude = snapshot.data!['longitude'];
                    return FutureBuilder(
                      future: getAddressFromCoordinates(longitude, latitude),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {                
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError && isInitAddress) {
                          return Text("Error: ${snapshot.error}");
                        } else{
                          if(isInitAddress){
                            address = snapshot.data!;
                            isInitAddress = false;
                          }
                          //address = snapshot.data!;
                          return Row(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Center(
                                    child: Text(
                                      address,
                                      style: TextStyle(
                                        fontSize: textScale * 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 9.0),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MapScreen(currentLocation: currentLocation, currentAddress: address, onVariableRetornada: _recibirVariable)),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.location_on,
                                    size: textScale * 26.0,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }
                    ); 
                  }
                }
              ),
            ),
            const Divider(
              thickness: 2.0,
              indent: 16.0,
              endIndent: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}
