import 'package:http/http.dart' as http;
import 'package:eindopdracht5/token_manager.dart';

Future<void> deleteGame(int gameId) async {
  final response = await http.delete(
    Uri.parse('${TokenManager.baseApi}/games/${gameId}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${TokenManager.bearerToken}'
    },
  );

  if (response.statusCode == 200) {

  } else {
    throw Exception('Failed to delete game');
  }
}
