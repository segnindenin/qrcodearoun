import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_scanner/Constants.dart';
import 'Home/Home_Screen.dart';

class Connexion extends StatefulWidget {
  const Connexion({Key? key}) : super(key: key);
  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> _handleSignIn() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Remplacez l'URL par votre API d'authentification
    final apiUrl = Uri.parse(BaseUrl + 'login');

    try {
      final response = await http.post(apiUrl, body: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String? token = data['data']['token'];

        // Connexion réussie, redirigez vers l'écran SplashScreen
        if (token != null) {
          // Connexion réussie, redirigez vers l'écran SplashScreen
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => HomeScreen(token: token)));
        } else {
          print('Token manquant dans la réponse');
        }
      } else {
        // Gérez les cas d'erreur d'authentification ici
        print('Échec de l\'authentification : ${response.statusCode}');
      }
    } catch (e) {
      // Gérez les erreurs de connexion réseau ici
      print('Erreur de connexion : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.pink,
                prefixIcon: Icon(
                  Icons.email, // Icône d'e-mail
                  color: Colors.white, // Couleur de l'icône
                ),
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                filled: true,
                fillColor: Colors.pink,
                prefixIcon: Icon(
                  Icons.lock, // Icône de mot de passe
                  color: Colors.white, // Couleur de l'icône
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _handleSignIn();
                print('Bouton appuyé');
              },
              child: const Text('Se connecter'),
              style: ElevatedButton.styleFrom(
                primary: Colors.pink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
