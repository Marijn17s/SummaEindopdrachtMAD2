import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> createGame(Map<String, dynamic> gameData) async {
  final url = Uri.parse('http://localhost:8000/games');

  final response = await http.post(
    url,
    body: {
      'name': gameData['name'], // Get the name from the game data
      'rating': gameData['rating'].toString(), // Get the rating from the game data
      'released': gameData['released'], // Get the release date from the game data
      'description_raw': gameData['description_raw'], // Get the description from the game data
      'platforms': gameData['platforms'].map((platform) => platform['platform']['name']).toList().join(','), // Get the platforms as a comma-separated string
      'genres': gameData['genres'].map((genre) => genre['name']).toList().join(','), // Get the genres as a comma-separated string
      'developers': gameData['developers'].map((developer) => developer['name']).toList().join(','), // Get the developers as a comma-separated string
      // Add other properties as needed
    },
  );

  if (response.statusCode == 200) {
    // Game created successfully
    final responseData = json.decode(response.body);
    // Handle the response data if needed
  } else {
    // Failed to create game
    throw Exception('Failed to create game');
  }
}