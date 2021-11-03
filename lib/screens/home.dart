import 'package:flutter/material.dart';

import 'package:mod3_kel22/screens/detail.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:mod3_kel22/screens/sinopsis.dart';

import 'about.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Show>> shows;
  late Future<List<AiringShow>> airing;

  @override
  void initState() {
    super.initState();
    shows = fetchShows();
    airing = fetchAiring();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyAnimeList')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
                  child: Text(
                    'Top Airing',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 200,
                  child: FutureBuilder(
                    builder:
                        (context, AsyncSnapshot<List<AiringShow>> snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) =>
                                GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SinopsisPage(
                                      item: snapshot.data![index].malId,
                                      title: snapshot.data![index].title,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 0,
                                child: SizedBox(
                                  height: 150,
                                  width: 100,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: 150,
                                          child: Image.network(
                                              snapshot.data![index].imageUrl)),
                                      Text(
                                        snapshot.data![index].title,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong :('));
                      }

                      return const CircularProgressIndicator();
                    },
                    future: airing,
                  ),
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Top Anime',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: FutureBuilder(
                    builder: (context, AsyncSnapshot<List<Show>> snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: Colors.white,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        snapshot.data![index].imageUrl),
                                  ),
                                  title: Text(snapshot.data![index].title),
                                  subtitle: Text(
                                      'Score: ${snapshot.data![index].score}'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                            item: snapshot.data![index].malId,
                                            title: snapshot.data![index].title),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong :('));
                      }

                      return const CircularProgressIndicator();
                    },
                    future: shows,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AboutPage(),
            ),
          );
        },
        child: const Icon(Icons.info_outline),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

class Show {
  final int malId;

  final String title;

  final String imageUrl;

  final num score;

  Show({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['image_url'],
      score: json['score'],
    );
  }
}

Future<List<Show>> fetchShows() async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v3/top/anime/1'));

  if (response.statusCode == 200) {
    var topShowsJson = jsonDecode(response.body)['top'] as List;

    return topShowsJson.map((show) => Show.fromJson(show)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}

class AiringShow {
  final int malId;

  final String title;

  final String imageUrl;

  final num score;

  AiringShow({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
  });

  factory AiringShow.fromJson(Map<String, dynamic> json) {
    return AiringShow(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['image_url'],
      score: json['score'],
    );
  }
}

Future<List<AiringShow>> fetchAiring() async {
  final data =
      await http.get(Uri.parse('https://api.jikan.moe/v3/top/anime/1/airing'));

  if (data.statusCode == 200) {
    var airingJson = jsonDecode(data.body)['top'] as List;

    return airingJson.map((airing) => AiringShow.fromJson(airing)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}
