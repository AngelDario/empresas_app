// inicial snippet code for login.dart
import 'package:flutter/material.dart';
import 'package:empresas_cliente/services/auth_service.dart';

class MyCustomIcons {
  MyCustomIcons._();

  static const _kFontFam = 'MyCustomIcons';
  static const String? _kFontPkg = null;

  static const IconData myCustomIcon = IconData(
    0xe000,
    fontFamily: _kFontFam,
    fontPackage: _kFontPkg,
  );
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/imagen_login.png'),
          fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding( 
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child:SizedBox(
                    width: 500.0,
                    child: ElevatedButton(
                      onPressed: () {AuthService().singInWithGoogle();},
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0))
                        ),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.login, color: Colors.black,),
                          SizedBox(width: 10.0,),
                          Text('Ingresar con Google',
                            style: TextStyle(
                            color: Colors.black
                          ),)
                        ],
                      ),
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}