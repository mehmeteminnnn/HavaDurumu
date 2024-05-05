import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hava_durumu/lokasyon_alma.dart';
import 'package:hava_durumu/search_page.dart';
import 'package:hava_durumu/widgets/gunluk_hava_durumu.dart';
import 'package:http/http.dart' as http;

import 'loading_simge.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? location;
  double? temperature;
  final String key = 'b341c37285f7a448e34f199b78d963bc';
  var locationData;
  String kod = "home";
  Position? position;
  String? icon;
  LokasyonAlma lokasyonAlma = LokasyonAlma();
  List<String> icons = ["01d", "01d", "01d", "01d", "01d"];
  List<double> dereceler = [20, 20, 20, 20, 20];
  List<String> gunler = ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma"];
  List<String> weekdays = [
    "Pazartesi",
    "Salı",
    "Çarşamba",
    "Perşembe",
    "Cuma",
    "Cumartesi",
    "Pazar"
  ];

  void initState() {
    initializeWeather();

    super.initState();
  }

  Future<void> getSehir() async {
    locationData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$key&units=metric'));
    print(locationData.body);
    var ayrismis = jsonDecode(locationData.body);

    if (ayrismis['cod'] == 200) {
      setState(() {
        temperature = ayrismis['main']['temp'];
        location = ayrismis['name'];
        kod = ayrismis["weather"][0]["main"];
        icon = ayrismis["weather"][0]["icon"];
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hata'),
            content: Text('Hava durumu bilgileri alınamadı.'),
            actions: [
              TextButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> getSehirlonvelat(double latitude, double longitude) async {
    locationData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$key&units=metric'));
    print(locationData.body);
    var ayrismis = jsonDecode(locationData.body);

    setState(() {
      temperature = ayrismis['main']['temp'];
      location = ayrismis['name'];
      kod = ayrismis["weather"][0]["main"];
      icon = ayrismis["weather"][0]["icon"];
    });
  }

  Future<void> getDailyForecastByLatlon(
      double latitude, double longitude) async {
    var forecastData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$key&units=metric'));
    var ayrilmisForecast = jsonDecode(forecastData.body);
    dereceler.clear();
    gunler.clear();
    icons.clear();
    setState(() {
      for (int i = 7; i <= 39; i += 8) {
        dereceler.add(ayrilmisForecast["list"][i]["main"]["temp"]);
        icons.add(ayrilmisForecast["list"][i]["weather"][0]["icon"]);
        gunler.add(ayrilmisForecast["list"][i]["dt_txt"]);
      }
    });
  }

  Future<void> getDailyForecastByCity(double latitude, double longitude) async {
    var forecastData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$key&units=metric'));
    var ayrilmisForecast = jsonDecode(forecastData.body);
    dereceler.clear();
    gunler.clear();
    icons.clear();
    setState(() {
      for (int i = 7; i <= 39; i += 8) {
        dereceler.add(ayrilmisForecast["list"][i]["main"]["temp"]);
        icons.add(ayrilmisForecast["list"][i]["weather"][0]["icon"]);
        gunler.add(ayrilmisForecast["list"][i]["dt_txt"]);
      }
    });
  }

  Future<void> initializeWeather() async {
    position = await lokasyonAlma.determinePosition();
    await getSehirlonvelat(position!.latitude, position!.longitude);
    await getDailyForecastByLatlon(position!.latitude, position!.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/$kod.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: (temperature == null || position == null)
          ? Center(child: loader)
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 130,
                        child: Image.network(
                            "https://openweathermap.org/img/wn/$icon@4x.png")),
                    Text("$temperature°C",
                        style: TextStyle(
                            fontSize: 70, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          location!,
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
                            getDailyForecastByCity(
                                position!.latitude, position!.longitude);
                          },
                          icon: Icon(
                            size: 45,
                            Icons.search,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.93,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          DailyWeatherCard(
                              icon: icons[0],
                              day: gunler[0],
                              temperature: dereceler[0]),
                          DailyWeatherCard(
                              icon: icons[1],
                              day: gunler[1],
                              temperature: dereceler[1]),
                          DailyWeatherCard(
                              icon: icons[2],
                              day: gunler[2],
                              temperature: dereceler[2]),
                          DailyWeatherCard(
                              icon: icons[3],
                              day: gunler[3],
                              temperature: dereceler[3]),
                          DailyWeatherCard(
                              icon: icons[4],
                              day: gunler[4],
                              temperature: dereceler[4]),
                        ],
                      ),
                    )
                  ],
                ),
              )),
    );
  }
}
