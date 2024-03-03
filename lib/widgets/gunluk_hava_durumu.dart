import 'package:flutter/material.dart';

class DailyWeatherCard extends StatelessWidget {
  const DailyWeatherCard({super.key});
  final String? icon = "01d";
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: SizedBox(
          child: Column(
        children: [
          Image.network(
            "https://openweathermap.org/img/wn/10d@2x.png",
          ),
        ],
      )),
    );
  }
}
