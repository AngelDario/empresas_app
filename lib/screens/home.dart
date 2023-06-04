import 'dart:async';
import 'package:empresas_cliente/screens/history.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:empresas_cliente/services/auth_service.dart';
import 'package:empresas_cliente/screens/profilePage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:empresas_cliente/screens/account.dart';
import 'package:geocoding/geocoding.dart';
import 'package:empresas_cliente/screens/maps.dart';

// Insertar en la base de datos los datos del usuario
// Datos necesarios son: nombre, email, foto
bool isInitAddress = true;
late String address;

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

  void _recibirVariable(String variable) {
    setState(() {
       address = variable;
       print(address);
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
  Future<String> getAddressFromLocation() async {

    final Map<String, dynamic> location = await getCurrentLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(location['latitude'], location['longitude']);
    Placemark place = placemarks[0]; // Selecciona el primer resultado
    String addr = "${place.street}, ${place.locality}, ${place.country}";
    return addr; // Imprime la dirección obtenida
  }
  
  Future<Map<dynamic, dynamic>> getRecomended() async{
    final databaseReference = FirebaseDatabase.instance.ref("clients");
    DatabaseEvent data = await databaseReference.once();
    return data.snapshot.value as Map<dynamic, dynamic>;
  }

  @override
  void initState() {
    //getRecomended();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final lista_prueba = ['Elemento 1', 'Elemento 2', 'Elemento 3'];
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
                future: getAddressFromLocation(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    //print(isInitAddress);
                    if (isInitAddress) {
                      address = snapshot.data!;
                      isInitAddress = false;
                    }
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
              )
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0, top: 16.0, right: 13.0),
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(21.0),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Icon(
                        Icons.search,
                        size: textScale * 26.0,
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '¿En que necesitas ayuda?',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
              child: Text(
                'Recomendados',
                style: TextStyle(
                  fontSize: textScale * 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Divider
            const Divider(
              thickness: 2.0,
              indent: 16.0,
              endIndent: 16.0,
            ),
            // lista de recomendados
            FutureBuilder(
              future: getRecomended(),
              builder: (BuildContext context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  //print(snapshot.data!.snapshot.value);
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage(photoUrl: snapshot.data!.values.elementAt(index)['photoUrl'])),
                          ),
                          title: Text(snapshot.data!.values.elementAt(index)['name']),
                          subtitle: Text(snapshot.data!.values.elementAt(index)['email']),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data!.values.elementAt(index)['photoUrl']),
                            radius: 35,
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
