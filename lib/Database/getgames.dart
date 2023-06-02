import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> getGames1() async {
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
