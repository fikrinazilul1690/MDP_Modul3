import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final List<Map<String, dynamic>> data = [
    {"Name": "Achmad Nazilul Fikri", "NIM": "21120119130079"},
    {"Name": "Daniel Parningotan Alexander S.", "NIM": "21120119130086"},
    {"Name": "Syahrul Ramadhan", "NIM": "21120119120011"},
    {"Name": "Kaffa Emirudin Setiadji", "NIM": "21120119140128"},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Kelompok 22')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.person_pin_rounded,
                      size: 250, color: Colors.blue),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: data
                      .map((data) => Card(
                              child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("${data['Name']}",
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("${data['NIM']}",
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                      )),
                                ),
                              ],
                            ),
                          )))
                      .toList(),
                ),
              ),
            ],
          ),
        ));
  }
}
