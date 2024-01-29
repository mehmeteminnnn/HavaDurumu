import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'lokasyon_alma.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String secilenSehir = '';
  LokasyonAlma lokasyonAlma = LokasyonAlma();
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/search.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    onChanged: (value) {
                      secilenSehir = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'ŞEHİR SEÇİNİZ',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    //bu sehir için API yanıt veriyor mu
                    Position position = await lokasyonAlma.determinePosition();
                    var response = await http.get(Uri.parse(
                        "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=b341c37285f7a448e34f199b78d963bc&units=metric"));
                    if (response.statusCode == 200) {
                      Navigator.pop(context, secilenSehir);
                    } else {
                      showMyAlertDialog(context);
                    }
                  },
                  child: Text("Seçilen Şehir"))
            ],
          ),
        ),
      ),
    );
  }

  void showMyAlertDialog(BuildContext context) {
    // Ayrı bir fonksiyon olarak AlertDialog'u göster
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lokasyon Bulunamadı', style: TextStyle(fontSize: 20)),
          content: Text('Lütfen geçerli bir şehir seçiniz.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // AlertDialog'u kapat
                Navigator.of(context).pop();
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}
