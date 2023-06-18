import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empresas_cliente/providers/address_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:empresas_cliente/screens/profilePage.dart';
// ignore: depend_on_referenced_packages
import 'package:geocoding/geocoding.dart';
import 'package:empresas_cliente/screens/maps.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, dynamic> currentLocation;
  
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
  
  Future<Map<dynamic, dynamic>> getRecommendedFireStore() async{
    Map<dynamic, dynamic> recomended = {};

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('workers').get();

    for (var doc in querySnapshot.docs){
      String id = doc.id;
      String name = doc['name'];
      String email = doc['email'];
      String photo = doc['photoUrl'];

      Map<String, dynamic> datos = {
        'id': id,
        'name': name,
        'email': email,
        'photoUrl': photo,
      };

      recomended[id] = datos;
    }
    //logger.d(recomended);

    return recomended;
  }
  

  // Future<Map<dynamic, dynamic>> getRecomended() async{
  //   final databaseReference = FirebaseDatabase.instance.ref("clients");
  //   DatabaseEvent data = await databaseReference.once();
  //   Map<dynamic, dynamic> values = data.snapshot.value as Map<dynamic, dynamic>;

  //   Map<dynamic, dynamic> recomended = {};

  //   values.forEach((key, value) {
  //     String id = key;
  //     String name = value['name'];
  //     String email = value['email'];
  //     String photo = value['photoUrl'];

  //     Map<String, dynamic> datos = {
  //       'id': id,
  //       'name': name,
  //       'email': email,
  //       'photoUrl': photo,
  //     };

  //     recomended[key] = datos;
  //   });

  //   //logger.d(recomended);

  //   return recomended;
  // }

  @override
  void initState() {
    //getRecommendedFireStore();
    //getRecomended();
    super.initState();
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
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Center(
                        child: Text(
                          context.watch<AddressProvider>().addressData['address'] ?? 'Cargando...',
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
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const MapScreen(),
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          withNavBar: false,
                        );
                      },
                      icon: Icon(
                        Icons.location_on,
                        size: textScale * 30.0,
                      ),
                    ),
                  ),
                ]
              ), 
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
            FutureBuilder(
              future: getRecommendedFireStore(),
              builder: (BuildContext context, AsyncSnapshot<Map<dynamic,dynamic>> snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  //print(snapshot.data!.snapshot.value);
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () => PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: ProfilePage(id: snapshot.data!.values.elementAt(index)['id']),
                            //settings: const RouteSettings(name: 'profile_page'),
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
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
