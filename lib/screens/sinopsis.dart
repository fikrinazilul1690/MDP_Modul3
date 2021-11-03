import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class SinopsisPage extends StatefulWidget {
  final int item;

  final String title;

  const SinopsisPage({Key? key, required this.item, required this.title})
      : super(key: key);

  @override
  _SinopsisPageState createState() => _SinopsisPageState();
}

class _SinopsisPageState extends State<SinopsisPage> {
  late Future<Sinopsis> sinopsis;

  @override
  void initState() {
    super.initState();

    sinopsis = fetchSinopsis(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Center(
            child: FutureBuilder<Sinopsis>(
          future: sinopsis,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(snapshot.data!.imageUrl),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(snapshot.data!.title,
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Score: ' + snapshot.data!.score.toString(),
                            style: const TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.start),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Broadcast: ' + snapshot.data!.broadcast,
                            style: const TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.start),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(snapshot.data!.sinopsis,
                          style: const TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.justify),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong :('));
            }

            return const CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}

class Sinopsis {
  final String imageUrl;

  final String title;

  final String sinopsis;

  final String broadcast;

  final num malId;

  final num score;

  Sinopsis(
      {required this.imageUrl,
      required this.title,
      required this.sinopsis,
      required this.broadcast,
      required this.malId,
      required this.score});

  factory Sinopsis.fromJson(Map<String, dynamic> json) {
    return Sinopsis(
      imageUrl: json['image_url'],
      title: json['title'],
      sinopsis: json['synopsis'],
      broadcast: json['broadcast'],
      malId: json['mal_id'],
      score: json['score'],
    );
  }
}

Future<Sinopsis> fetchSinopsis(id) async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v3/anime/$id'));

  if (response.statusCode == 200) {
    return Sinopsis.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load sinopsis');
  }
}
