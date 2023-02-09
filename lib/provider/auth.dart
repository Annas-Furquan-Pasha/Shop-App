import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryData;
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if(_expiryData != null && _expiryData!.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> signUp(String email, String password) async {
    final url
      = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDJKURUXEO19IYZ3M8x31G2V3sis2dUC1M');
    try {
      final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },),);
      final responseData = json.decode(response.body);
      if(json.decode(response.body)['error'] != null) {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryData = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    }catch(error) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    final url
    = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDJKURUXEO19IYZ3M8x31G2V3sis2dUC1M');
    try {
      final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },),);
      final responseData = json.decode(response.body);
      if(json.decode(response.body)['error'] != null) {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryData = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    }catch(error) {
      rethrow;
    }
  }
}

// web api key : AIzaSyDJKURUXEO19IYZ3M8x31G2V3sis2dUC1M

// sign up rest api http request : https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]

// login rest api http request : https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]