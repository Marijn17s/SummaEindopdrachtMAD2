import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'game_screen.dart';

class RandomScreen extends StatefulWidget {
  @override
  _RandomScreenState createState() => _RandomScreenState();
}

class _RandomScreenState extends State<RandomScreen> {
  dynamic _gameData;

  Future<void> _fetchRandomGame() async {
    final response = await http.get(
        Uri.parse(
            'http://api.rawg.io/api/games?key=89fc9780e97142e8bad7c4aa62f392d0&ordering=-rating&page_size=1&page=${Random().nextInt(100) + 1}'),
        headers: {'User-Agent': 'Mozilla/5.0'});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final game = data['results'][0];
      final gameDetailsResponse = await http.get(
          Uri.parse('https://api.rawg.io/api/games/${game['id']}?key=89fc9780e97142e8bad7c4aa62f392d0'),
          headers: {'User-Agent': 'Mozilla/5.0'});
      if (gameDetailsResponse.statusCode == 200) {
        final gameDetails = json.decode(gameDetailsResponse.body);
        setState(() {
          _gameData = {
            'id': game['id'],
            'name': game['name'],
            'description': gameDetails['description'],
            'background_image': game['background_image']
          };
        });
      } else {
        throw Exception('Failed to load game details');
      }
    } else {
      throw Exception('Failed to load game');
    }
  }


  @override
  void initState() {
    super.initState();
    _fetchRandomGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Random Game'),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey.shade800, Colors.black],
            ),
          ),
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  if (_gameData != null) ...[
          Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(_gameData['background_image']),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          _gameData['name'],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            await _fetchRandomGame();
          },
          child: Text(
            'Random Game',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 32,
            ),
            primary: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
        onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
            gameData: {
              'id': _gameData['id'],
              'name': _gameData['name'],
            },
          ),
        ),
      );
    },
    child: Text(
    'View Game',
    style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(
    vertical: 16,
    horizontal :32,
    ),
      primary: Colors.orange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
        ),
                  ],
                    if (_gameData == null)
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                  ],
              ),
          ),
        ),
    );
  }
}
