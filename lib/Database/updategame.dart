import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> updateGame1(Map<String, dynamic> gameData) async {
  final url = Uri.parse('http://localhost:8000/api/games/${gameData['id']}'); // Assuming the API supports updating a game using the game ID

  final response = await http.put(
    url,
    body: {
      'name': gameData['name'], // Get the updated name from the game data
      'rating': gameData['rating'].toString(), // Get the updated rating from the game data
      'released': gameData['released'], // Get the updated release date from the game data
      'description_raw': gameData['description_raw'], // Get the updated description from the game data
      'platforms': gameData['platforms'].map((platform) => platform['platform']['name']).toList().join(','), // Get the updated platforms as a comma-separated string
      'genres': gameData['genres'].map((genre) => genre['name']).toList().join(','), // Get the updated genres as a comma-separated string
      'developers': gameData['developers'].map((developer) => developer['name']).toList().join(','), // Get the updated developers as a comma-separated string
      // Add other properties as needed
    },
  );

  if (response.statusCode == 200) {
    // Game updated successfully
    final responseData = json.decode(response.body);
    // Handle the response data if needed
  } else {
    // Failed to update game
    throw Exception('Failed to update game');
  }
}
