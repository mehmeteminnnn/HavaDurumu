import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hava_durumu/search_page.dart';
import 'package:http/http.dart' as http;

import 'loading_simge.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = 'Canakkale';
  double? temperature;
  final String key = 'b341c37285f7a448e34f199b78d963bc';
  var locationData;

  Future<void> getSehir() async {
    locationData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$key&units=metric'));
    print(locationData.body);
    var ayrismis = jsonDecode(locationData.body);

    setState(() {
      temperature = ayrismis['main']['temp'];
      location = ayrismis['name'];
    });
  }

  @override
  void initState() {
    getSehir();
    super.initState();
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
      child: (temperature == null)
          ? Center(child: loader)
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$temperature°C",
                        style: TextStyle(
                            fontSize: 70, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          location,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () async {
                              location = locationData = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchPage()));
                              getSehir();
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
