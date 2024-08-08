import 'package:dio/dio.dart';
import 'dart:async';
//import 'dart:convert';
import '../classes/google_signin.dart';
import '../classes/google_signup.dart';
import '../classes/generate_token.dart';
import '../classes/token_check.dart';
import '../classes/plaid_setup.dart';

import '../classes/plaid_transactions.dart';
import '../classes/set_transaction.dart';

//remember to update this

//REMEMBER FOR TMRW lol
//finish testing reigstering
//connecting plaid
//etc192.168.0.161
class HttpClient {
  final String serverAddress = "http://192.168.0.161:3000";

  final dio = Dio();

  String createURL(route) {
    return serverAddress + route;
  }

  Future<Token> getToken(userToken) async {
    final response =
        await dio.post(createURL("/api/fin/create_link_token"), data: {
      "token": userToken,
    });

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
    final response =
        await dio.post(createURL("/api/register_user_google"), data: {
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

  Future<GoogleSignIn> signUserGoogle(email, id, displayName) async {
    final response =
        await dio.post(createURL("/api/signin_user_google"), data: {
      "email": email,
      "google_id": id,
      "displayName": displayName,
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return GoogleSignIn.fromJson(response.data);
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

  Future<PlaidSetup> plaidSetup(token, jwt) async {
    final response = await dio.post(
      createURL("/api/fin/setup_plaid"),
      data: {
        "public_token": token,
        "user_jwt": jwt,
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return PlaidSetup.fromJson(response.data);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<PlaidTransactions> plaidTransactions(jwt) async {
    final response = await dio.post(
      createURL("/api/fin/get_transactions"),
      data: {
        "user_jwt": jwt,
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return PlaidTransactions.fromJson(response.data);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<SetTransaction> plaidUpdateTransaction(jwt, plaidCursor, type) async {
    final response = await dio.post(
      createURL("/api/fin/set_transaction"),
      data: {
        "user_jwt": jwt,
        "category": type,
        "plaid_cursor": plaidCursor,
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return SetTransaction.fromJson(response.data);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
