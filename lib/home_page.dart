import 'package:flutter/material.dart';
import 'package:hava_durumu/search_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String sehirAdi = 'Ankara';
  double sicaklik = 43.0;
  String key = "b341c37285f7a448e34f199b78d963bc";

  void getSehir() {
    Future<http.Response> fetchAlbum() {
      return http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$sehirAdi&appid=$sicaklik'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/home.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$sicaklik°C",
                    style:
                        TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sehirAdi,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage()));
                        },
                        icon: Icon(
                          size: 45,
                          Icons.search,
                          color: Colors.white70,
                        ))
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
