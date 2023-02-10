import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryData;
  String? _userId;
  Timer? _authTimer;

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
      _autoLogout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token' : _token,
        'userId' : _userId,
        'expiryDate' : _expiryData!.toIso8601String()
      });
      pref.setString('userData', userData);
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
      _autoLogout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token' : _token,
        'userId' : _userId,
        'expiryDate' : _expiryData!.toIso8601String()
      });
      pref.setString('userData', userData);
    }catch(error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    _expiryData = null;
    if(_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if(!pref.containsKey('userData')) {
      return false;
    }
    var extractedUserData = json.decode(pref.getString('userData')!) ;//as Map<String, dynamic>;
    if(extractedUserData == null) {
      return false;
    }
    extractedUserData = extractedUserData as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _expiryData = expiryDate;
    _userId = extractedUserData['userId'];
    notifyListeners();
    _autoLogout();
    return true;
   }

  void _autoLogout() {
    if(_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryData?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry!), logout);
  }
}

// web api key : AIzaSyDJKURUXEO19IYZ3M8x31G2V3sis2dUC1M

// sign up rest api http request : https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]

// login rest api http request : https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]