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
Future<List<Repos>> fetchGitHubUserRepos() async {
  final response = await http.get('https://api.github.com/users/purrox/repos');
  if (response.statusCode == 200) {
    return parseRepos(response.body);
  } else {
    throw Exception('Failed to load User');
  }
}
