import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Database/creategame.dart';

class GameScreen extends StatefulWidget {
  final Map<String, dynamic> gameData;

  GameScreen({required this.gameData});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Map<String, dynamic> game = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGame(widget.gameData['id']);
  }

  Future<void> fetchGame(int id) async {
    final response = await http.get(Uri.parse(
        'https://api.rawg.io/api/games/$id?key=89fc9780e97142e8bad7c4aa62f392d0'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        game = data;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load game');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameData['name']),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade800, Colors.black],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        game['background_image'],
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        game['name'],
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rating: ${game['rating'].toString()}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Released: ${game['released']}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        game['description_raw'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        maxLines: null,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Platforms:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 8,
                        children:
                            List.generate(game['platforms'].length, (index) {
                          return Chip(
                            label: Text(
                              game['platforms'][index]['platform']['name'],
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.blue.shade600,
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Genres:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 8,
                        children: List.generate(game['genres'].length, (index) {
                          return Chip(
                            label: Text(
                              game['genres'][index]['name'],
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.blue.shade600,
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Developers:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 8,
                        children:
                            List.generate(game['developers'].length, (index) {
                          return Chip(
                            label: Text(
                              game['developers'][index]['name'],
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.blue.shade600,
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        createGame(game)
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Game created succesfully.')),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Background color
                        onPrimary: Colors.white, // Text color
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Button border radius
                        ),
                      ),
                      child: Text(
                        'Create',
                        style: TextStyle(fontSize: 16), // Text style
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
