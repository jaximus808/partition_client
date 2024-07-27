import 'package:dio/dio.dart';
import 'dart:async';
//import 'dart:convert';
import '../classes/google_signup.dart';
import '../classes/generate_token.dart';
import '../classes/token_check.dart';

//remember to update this

//REMEMBER FOR TMRW lol
//finish testing reigstering
//connecting plaid
//etc
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

  Future<GoogleSignUp> createUserGoogle(email, id, displayName) async {
    final response = await dio.post(createURL("/api/register_user"), data: {
      "email": email,
      "google_id": id,
      "displayName": displayName,
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return GoogleSignUp.fromJson(response.data);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<TokenCheck> checkToken(token) async {
    final response = await dio.post(createURL("/api/check_token"), data: {
      "token": token,
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return TokenCheck.fromJson(response.data);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
