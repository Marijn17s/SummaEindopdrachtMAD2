import 'package:http/http.dart' as http;
import 'package:eindopdracht5/token_manager.dart';
import 'dart:convert';

Future<List<Map<String, dynamic>>> getGames() async {
  print(TokenManager.bearerToken);
  final response = await http.post(
      Uri.parse('${TokenManager.baseApi}/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${TokenManager.bearerToken}'
      },
  );
  print(response);

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
