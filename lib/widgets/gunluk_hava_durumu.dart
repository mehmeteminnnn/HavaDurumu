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
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          Text(
            day!,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      )),
    );
  }
}
