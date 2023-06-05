import 'package:http/http.dart' as http;
import 'package:eindopdracht5/token_manager.dart';
import 'dart:convert';

Future<List<Map<String, dynamic>>> getGames() async {
  final response = await http.get(
      Uri.parse('${TokenManager.baseApi}/games'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${TokenManager.bearerToken}'
      },
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    TokenManager.bearerToken = result['access_token'];

    final List<dynamic> responseData = json.decode(response.body)['data'];
    final List<Map<String, dynamic>> games = [];
    
    for (var gameData in responseData) {
      games.add(gameData as Map<String, dynamic>);
    }

    return games;
  } else {
    throw Exception('Failed to fetch games');
  }
}
