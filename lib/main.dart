import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

Future<Album> fetchAlbum() async {
  final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users/9'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final String username;
  final String name;
  final int id;
  final String email;

  Album({
    required this.name,
    required this.username,
    required this.id,
    required this.email,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'],
      username: json['username'],
      id: json['id'],
      email: json['email'],
    );
  }
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fatching Data from Internet'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            child: FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {

                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text(snapshot.data!.name),
                        Text(snapshot.data!.username),
                        Text(snapshot.data!.email),
                ]);
                } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
                }
              }
                return
                CircularProgressIndicator
                (
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


