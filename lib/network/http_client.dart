import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:convert';
import '../classes/generate_token.dart';

class HttpClient {
  final String serverAddress = "http://192.168.0.161:3000";

  final dio = Dio();

  String createURL(route) {
    return serverAddress + route;
  }

  Future<Token> getToken() async {
    final response = await dio.post(createURL("/api/create_link_token"));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Token.fromJson(response.data);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
