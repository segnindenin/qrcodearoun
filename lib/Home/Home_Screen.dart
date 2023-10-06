import 'package:flutter/material.dart';
 

import 'Home_Screen_body.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return HomeScreenBody(token: widget.token,);
  }
}
