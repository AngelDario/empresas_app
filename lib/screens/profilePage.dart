import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String photoUrl;
  
  const ProfilePage({
    required this.photoUrl,
    super.key
    });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> { 


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CircleAvatar(
          backgroundImage: NetworkImage(widget.photoUrl),
          radius: 35, 
        ),
      ),
    );
  }
}