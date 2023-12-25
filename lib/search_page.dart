import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String secilenSehir = '';
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
                    onPressed: () {
                      Navigator.pop(context, secilenSehir);
                    },
                    child: Text("Seçilen Şehir"))
              ],
            ),
          )),
    );
  }
}
