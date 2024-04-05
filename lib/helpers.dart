import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl =
    'https://radiox-api.wonderfulsea-1d4ac329.southeastasia.azurecontainerapps.io';

Future<Map<String, dynamic>> apiFetch(
    String url, String token, Map<String, String>? body) async {
  final response = await http.post(Uri.parse(baseUrl + url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      },
      body: body != null ? jsonEncode(body) : null);

  if (response.statusCode == 200 || response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    final message = jsonDecode(response.body)['msg'] ??=
        jsonDecode(response.body)['message'];
    return {'status': 'error', 'message': message};
  }
}

Future<void> addToSharedPrefs(String accessToken, String refreshToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('accessToken', accessToken);
  prefs.setString('refreshToken', refreshToken);
  prefs.setInt(
      'accessTokenCreationTime', DateTime.now().millisecondsSinceEpoch);
  prefs.setInt(
      'refreshTokenCreationTime', DateTime.now().millisecondsSinceEpoch);
}
