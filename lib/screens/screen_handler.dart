import 'dart:async';
import 'package:empresas_cliente/screens/home.dart';
import 'package:empresas_cliente/screens/history.dart';
import 'package:empresas_cliente/screens/category.dart';
import 'package:empresas_cliente/screens/account.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:empresas_cliente/services/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:permission_handler/permission_handler.dart';

// Insertar en la base de datos los datos del usuario
// Datos necesarios son: nombre, email, foto

class Screenhandler extends StatefulWidget {
  const Screenhandler({super.key});

  @override
  State<Screenhandler> createState() => _ScreenhandlerState();
}

class _ScreenhandlerState extends State<Screenhandler> { 
  //String? user = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.displayName;
  
  final databaseReference = FirebaseDatabase.instance.ref();
  
  final userName = FirebaseAuth.instance.currentUser!.displayName;
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  final userPhoto = FirebaseAuth.instance.currentUser!.photoURL;
  final userUid = FirebaseAuth.instance.currentUser!.uid;
  late String adress; 

  //late Map<String,dynamic> longitudeAndLatitude = {};
  
  final List<Widget> _screens = [  
      const HomePage(),
      const History(),
      const Category(),
      const Account(),
  ];

  // Future<Map<String,dynamic>> saveCurrentPosition() async{
  //   final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   final latitude = position.latitude;
  //   final longitude = position.longitude;
  //   final Map<String, dynamic> currentLocation = {
  //     'latitude': latitude,
  //     'longitude': longitude,
  //   };
  //   longitudeAndLatitude = currentLocation;
  //   databaseReference.child('clients').child(userUid).update(currentLocation);
  //   _screens = [  
  //     HomePage(longitudeAndLatitude: longitudeAndLatitude.toString()),
  //     const History(),
  //     const Category(),
  //     Account(userName: userName.toString(), userEmail: userEmail.toString(), userImageUrl: userPhoto.toString()),
  //   ];
  //   return currentLocation;
  // }

  // Future<void> saveCurrentPosition() async{
  //   final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   final latitude = position.latitude;
  //   final longitude = position.longitude;
  //   final Map<String, dynamic> currentLocation = {
  //     'latitude': latitude,
  //     'longitude': longitude,
  //   };
  //   databaseReference.child('clients').child(userUid).update(currentLocation);
  //   //longitudeAndLatitude = currentLocation;
    
  //   //return currentLocation;
  // }

  Future<void> saveUserDataToFirebase() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      Permission.location.request();
    }
    databaseReference.child("users").child(userUid).once().then((event) async {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        return true;
      } else {
        Map<String,String> user = {
          'name': userName.toString(),
          'email': userEmail.toString(),
          'photoUrl': userPhoto.toString(),
        };
        databaseReference.child('clients').child(userUid).set(user);
        return false;
      }
    }); 
  }

  // void startTimer() {
  //   Timer.periodic(const Duration(seconds: 15), (timer) {
  //     saveCurrentPosition();
  //     // setState(() {});
  //   });
  // }

  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    saveUserDataToFirebase();
    //saveCurrentPosition();
    //startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens[selectedIndex]
      ), 
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Historial'),
        BottomNavigationBarItem(icon: Icon(Icons.label), label: 'Categorias'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      currentIndex: selectedIndex,
      onTap: _onItemTapped,
      ),
    );
  }
}