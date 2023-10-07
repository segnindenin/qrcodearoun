import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_scanner/AddManger.dart';
import 'package:http/http.dart' as http;
import 'package:qr_scanner/Constants.dart';
import 'dart:convert';

import 'package:qr_scanner/model/ouvrage.dart';

class ScanScreen extends StatefulWidget {
  final String token;
  ScanScreen({required this.token});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<Map<String, dynamic>> data = [];
  late Future<Ouvrage> futureOuvrage;
  var transaction;
  var identifiant;

  @override
  void initState() {
    super.initState();
    futureOuvrage = fetchOuvrageDetails();
  }

  Future<Ouvrage> fetchOuvrageDetails() async {
    final apiUrl = Uri.parse(BaseUrl + 'gestion-operations/details-ouvrages');
    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        'ouvrage': 'point-lumineux',
        'ouvrage_id': 1,
      }),
    );

    if (response.statusCode == 200) {
      return Ouvrage.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Échec de la requête : ${response.statusCode}');
    }
  }

  String sdata = "No data found !";

  var height, width;
  bool hasData = false;
  File? file;
  // Color pickerColor = Color(0xff443a49);
  Color currentColor = const Color.fromARGB(255, 88, 125, 117);

  BannerAd? bannerAddd;

  bool isLoaded = false;

  void load() {
    bannerAddd = BannerAd(
        size: AdSize.banner,
        adUnitId: AddManger.BannerScan,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: AdRequest())
      ..load();
  }

  // @override
  // void initState() {
  //   load();
  //   super.initState();
  // }

  @override
  void dispose() {
    if (isLoaded) {
      bannerAddd!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: FutureBuilder<Ouvrage>(
        future: futureOuvrage,
        builder: (context, snapshot) {
          print(snapshot.hasData == true ? 'Oui' : 'non');
          if (snapshot.hasData) {
            String transaction = snapshot.data!.data['transaction'];
            String identifiant = snapshot.data!.data['identifiant'];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: Icon(Icons.arrow_drop_down_circle),
                title: Text(transaction),
                subtitle: Text(
                  identifiant,
                  style: TextStyle(
                      color:
                          Color.fromARGB(255, 250, 250, 250).withOpacity(0.6)),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(
            child: const CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
