import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empresas_cliente/screens/serviceForm.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void serviceForm(BuildContext context, String id){
  showDialog(
    context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Agregar servicio'),
        content: ServiceForm(workerId: id,),
      );
    }
  );
}

class ProfilePage extends StatefulWidget {
  final String id;
  
  const ProfilePage({
    required this.id,
    super.key
    });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late String workerName;

  Future<Map<dynamic, dynamic>> getProfileData() async{
    // pedir los datos a firestore y retornarlos
    final databaseReference = FirebaseFirestore.instance.collection('workers').doc(widget.id);
    DocumentSnapshot data = await databaseReference.get();

    Map<dynamic, dynamic> profileData = data.data() as Map<dynamic, dynamic>;
    return profileData;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        //* imagen de fondo en el nivel mas bajo del stack la imagen tiene un blur
        children: [
          Container(
            height: 375,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/profile_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.0),
              ),
            ),
          ),
          SafeArea(
            child: FutureBuilder(
              future: getProfileData(),
              builder: (BuildContext context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                //* retornar un widget en blanco mientras se carga la informacion
                return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
                } else {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data!['photoUrl']),
                              radius: 35, 
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                snapshot.data!['email'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
                          child: Text(
                            //"Lorem ipsum dolor sit amet, cons ectetur adipiscing elit. Nulla vitae elit libero, a pharetra augue. Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit.",
                            snapshot.data!['description'],
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
                              //TODO: crear mas secciones aparte de la de comentarios
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Comentarios",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: 30,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    leading: const CircleAvatar(
                                      backgroundImage: NetworkImage("https://picsum.photos/200"),
                                      radius: 20,
                                    ),
                                    title: Text("Usuario $index"),
                                    subtitle: Text("Comentario $index"),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    ],
                  );
                }
              }
            )
          ),
          //TODO: Funcionamiento para la asignacion de sercicios
            Positioned(
              bottom: 16,
              right: 16,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () {serviceForm(context, widget.id);},
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 16),
                  FloatingActionButton(
                    heroTag: "btn2",
                    onPressed: () {},
                    child: const Icon(Icons.chat),
                  ),
                ],
              ),
            ),
        ],
      )
    );
  }
}