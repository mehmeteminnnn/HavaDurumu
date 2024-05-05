import 'package:flutter/material.dart';

class DailyWeatherCard extends StatelessWidget {
  const DailyWeatherCard(
      {super.key,
      required this.temperature,
      required this.icon,
      required this.day});
  final String? icon;
  final double? temperature;
  final String? day;
  @override
  Widget build(BuildContext context) {
    List<String> weekdays = [
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar"
    ];
    String weekday;
    weekday = weekdays[DateTime.parse(day!).weekday - 1];
    return Card(
      color: Colors.transparent,
      child: SizedBox(
          child: Column(
        children: [
          Image.network(
            "https://openweathermap.org/img/wn/$icon@2x.png",
            width: 90,
            height: 90,
          ),
          Text(
            "$temperature°C",
            style:
                TextStyle(fontSize: 19, fontWeight: FontWeight.bold, shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(2, 2),
                blurRadius: 3,
              ),
            ]),
          ),
          Text(
            weekday,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      )),
    );
  }
}
