import 'package:http/http.dart' as http;

Future<void> deleteGame1(int gameId) async {
  final url = Uri.parse('http://localhost:8000/games/$gameId'); // Assuming the API supports deleting a game using the game ID

  final response = await http.delete(url);

  if (response.statusCode == 200) {
    // Game deleted successfully
    // Handle the response data if needed
  } else {
    // Failed to delete game
    throw Exception('Failed to delete game');
  }
}
