import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Database/getgames.dart';
import 'Database/updategame.dart';
import 'Database/deletegames.dart';

Future<List<Map<String, dynamic>>> getGames() async {
  final url = Uri.parse('http://localhost:8000/games');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);
    final List<Map<String, dynamic>> games = [];

    for (var gameData in responseData) {
      games.add(gameData as Map<String, dynamic>);
    }

    return games;
  } else {
    throw Exception('Failed to fetch games');
  }
}

Future<void> deleteGame(int gameId) async {
  final response = await http.delete(deleteGame1(gameId) as Uri);

  if (response.statusCode == 200) {
    // Game deleted successfully
    // Handle the response data if needed
  } else {
    throw Exception('Failed to delete game');
  }
}

class GamesListScreen extends StatefulWidget {
  final void Function() navigateToCrudIndex;

  GamesListScreen({required this.navigateToCrudIndex});

  @override
  _GamesListScreenState createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  List<Map<String, dynamic>> games = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  Future<void> fetchGames() async {
    try {
      final List<Map<String, dynamic>> fetchedGames = await getGames();
      setState(() {
        games = fetchedGames;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch games.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games List'),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: games.length,
        itemBuilder: (BuildContext context, int index) {
          final game = games[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              title: Text(
                game['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                game['released'],
                style: TextStyle(color: Colors.grey[600]),
              ),
              leading: CircleAvatar(
                child: Text(
                  game['rating'].toString(),
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateGameScreen(game: game),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Deletion'),
                            content: Text(
                                'Are you sure you want to delete this game?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  try {
                                    await deleteGame(game['id']);
                                    fetchGames(); // Refresh the list after deletion
                                  } catch (error) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Error'),
                                          content: Text(
                                              'Failed to delete the game.'),
                                          actions: [
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.navigateToCrudIndex,
        child: Icon(Icons.add),
      ),
    );
  }
}

class UpdateGameScreen extends StatelessWidget {
  final Map<String, dynamic> game;

  UpdateGameScreen({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Game'),
      ),
      body: Center(
        child: Text(
          'Update Game - ${game['name']}',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.setSignedIn}) : super(key: key);

  final void Function(bool signedIn) setSignedIn;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> games = [];

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  Future<void> fetchGames() async {
    final response = await http.get(
        Uri.parse(
            'https://api.rawg.io/api/games?key=89fc9780e97142e8bad7c4aa62f392d0&ordering=-rating&page_size=10'),
        headers: {'User-Agent': 'Mozilla/5.0'});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        games = data['results'];
      });
    } else {
      throw Exception('Failed to load games');
    }
  }

  Future<void> _signOut() async {
    widget.setSignedIn(false);
  }

  void navigateToCrudIndex() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamesListScreen(
        navigateToCrudIndex: navigateToCrudIndex,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GameBot'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _signOut();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (BuildContext context, int index) {
          final game = games[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(game['background_image']),
            ),
            title: Text(game['name']),
            subtitle: Text('Rating: ${game['rating']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToCrudIndex,
        child: Icon(Icons.list),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Games App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blue,
      ),
      home: HomeScreen(
        setSignedIn: (bool signedIn) {},
      ),
    );
  }
}
