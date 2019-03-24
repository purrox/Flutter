import 'package:http/http.dart' as http;
import 'package:api_example/entities/user.dart';
import 'package:api_example/entities/repos.dart';
import 'dart:async';
import 'dart:convert';

//Method in charge of load user information.
Future<User> fetchGitHubUser() async {
  final response = await http.get('https://api.github.com/users/defunkt');
  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load User');
  }
}

List<Repos> parseRepos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Repos>((json) => Repos.fromJson(json)).toList();
}

//Method in charge of load user information.
Future<List<Repos>> fetchGitHubUserRepos(String user) async {
  final response = await http.get('https://api.github.com/users/$user/repos?client_id=3b8618525a6b4b91b45b&client_secret=995703f4c18194f1453dc933848625fd25a03962');
  if (response.statusCode == 200) {
    return parseRepos(response.body);
  } else {
    throw Exception('Failed to load Repos');
  }
}
