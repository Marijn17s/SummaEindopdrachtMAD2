import 'package:http/http.dart' as http;
import 'package:eindopdracht5/token_manager.dart';
import 'dart:convert';

Future<void> updateGame(Map<String, dynamic> gameData) async {
  final url = Uri.parse('http://localhost:8000/api/games/${gameData['id']}'); // Assuming the API supports updating a game using the game ID

  final body = {
    'name': gameData['name'], // Get the updated name from the game data
    'rating': gameData['rating'].toString(), // Get the updated rating from the game data
    'released': gameData['released'], // Get the updated release date from the game data
    'description_raw': gameData['description_raw'], // Get the updated description from the game data
  };

  final response = await http.put(
    url,
    body: jsonEncode(body),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${TokenManager.bearerToken}'
    },
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    TokenManager.bearerToken = result['access_token'];
  } else {
    throw Exception('Failed to update game');
  }
}
