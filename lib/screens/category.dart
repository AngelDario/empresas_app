// inicial snippet code for login.dart
import 'package:flutter/material.dart';
import 'package:empresas_cliente/services/auth_service.dart';

class ListItem {
  final String id;
  final Widget content;

  ListItem(this.id, this.content);
}

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<ListItem> todosLosElementos = [
    ListItem(
      'Jardineria',
      Row(
        children: [
          //* Imagen de categoria
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(21.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/categoria1.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Jarinería",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ),
        ],
      ),
    ),
    ListItem(
      'Cocina',
      Row(
        children: [
          //* Imagen de categoria
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 13, right: 16.0, bottom: 13),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(21.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/categoria2.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Cocina",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ),
        ],
      ),
    ),
    ListItem(
      'Gasfiteria',
      Row(
        children: [
          //* Imagen de categoria
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 13, right: 16.0, bottom: 13),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(21.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/categoria3.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Gasfitería",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ),
        ],
      ),
    ),
    ListItem(
      'Limpieza',
      Row(
        children: [
          //* Imagen de categoria
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 13, right: 16.0, bottom: 13),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(21.0),
                image: const DecorationImage(
                  image: AssetImage('assets/images/categoria4.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Limpieza",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ),
        ],
      ),
    ),
  ];

  String search = '';
  
  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Barra de busqueda de categorias
            Padding(
              padding:
                  const EdgeInsets.only(left: 13.0, top: 16.0, right: 13.0),
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              search = value;
                            });
                          },
                          decoration: const InputDecoration(
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
            const Padding(
              padding:
                  EdgeInsets.only(left: 16.0, top: 13, right: 16.0, bottom: 13),
              child: Text(
                "Categorías",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //* Listview de categorias
            Expanded(
              child: ListView.builder(
                itemCount: todosLosElementos.length,
                itemBuilder: (BuildContext context, int index) {
                  final elemento = todosLosElementos[index];

                  if (search.isEmpty) {
                    return todosLosElementos[index].content;
                  }

                  if (elemento.id
                      .toLowerCase()
                      .contains(search.toLowerCase())) {
                    return todosLosElementos[index].content;
                  }

                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
