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

  Future<String> fetchOuvrageDetails() async {
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
      var data = response.body;
      print(data);
      return data;
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
        body: FutureBuilder<List<dynamic>>(
          future: null, //fetchOuvrageDetails(),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else {
              List<dynamic> data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Item $index'),
                    // Ajoutez ici les widgets pour afficher les données spécifiques de votre API
                  );
                },
              );
            }
          },
        ));
  }
}
