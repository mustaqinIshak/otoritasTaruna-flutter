import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/http_exception.dart';
// import 'dart:convert' as convert;
import 'dart:convert';
import '../model/config.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _phoneNumber;
  bool? _otp = false;
  bool? _loginSuccess;
  int? _timeExpired;
  DateTime? _expiredDate;
  Timer? _authTimer;

  Future<bool> tokenAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.containsKey("userData");
      print(userData);
      if (userData) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  bool? get otp {
    // print(otp);
    return _otp;
  }

  bool? get loginSuccess {
    // print(otp);
    return _loginSuccess;
  }

  String? get token {
    if (_expiredDate != null &&
        _expiredDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    // print('ini di isAuth, token = ${token != null}');
    if (_token != null) {
      return true;
    } else
      return false;
    // return true;
  }

  bool get isOtp {
    return otp != null;
  }

  int? get timerExpired {
    return _timeExpired;
  }

  Future<void> getOtp(String phoneNumber) async {
    try {
      _phoneNumber = phoneNumber;
      // final url = Uri.parse('${Config().urlDev}auth/getOtp');
      final url = Uri.parse('${Config().urlDevLive}auth/getOtp');
      final response = await http.post(
        url,
        headers: Config().header(null),
        body: json.encode({"phoneNumber": phoneNumber}),
      );
      final responseData = await json.decode(response.body);
      print('ini response statusCode di getOtp ${response.statusCode}');
      if (response.statusCode >= 400) {
        _otp = false;
        throw HttpException(responseData['message']);
      }
      _otp = true;
      _timeExpired = responseData['time'];
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> getReloadOtp() async {
    try {
      print("masuk d get reload otp");
      final url = Uri.parse('${Config().urlDevLive}auth/getOtp');
      // final url = Uri.parse('${Config().urlDev}auth/getOtp');
      final response = await http.post(
        url,
        headers: Config().header(null),
        body: jsonEncode({"phoneNumber": _phoneNumber}),
      );
      final responseData = json.decode(response.body);

      _timeExpired = responseData['time'];
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> getToken(String timeOtp, String codeOtp) async {
    try {
      final url = Uri.parse('${Config().urlDevLive}auth/verifyOtp');
      // final url = Uri.parse('${Config().urlDev}auth/verifyOtp');
      final response = await http.post(
        url,
        headers: Config().header(null),
        body: jsonEncode({
          "phoneNumber": _phoneNumber,
          "otp": codeOtp,
          "time": timeOtp,
        }),
      );
      final responseData = json.decode(response.body);
      print('ini response statusCode di getToken ${response.statusCode}');
      if (response.statusCode >= 400) {
        print(responseData['message']);
        throw HttpException(responseData['message']);
      }
      _token = responseData['token'] as String;
      _expiredDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expireIn'])));
      notifyListeners();
      _autoLogout();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "expiryDate": _expiredDate?.toIso8601String(),
      });
      prefs.setString("userData", userData);
      _loginSuccess = true;

      print(prefs.containsKey('userData'));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    print('ini jalan tryoutologin');
    final prefs = await SharedPreferences.getInstance();
    print(prefs.containsKey('userData'));
    if (!prefs.containsKey('userData')) {
      print('gagal masuk ke home screen');
      return false;
    }
    final extracUserData = json.decode(prefs.getString('userData') as String);
    final expireDate = DateTime.parse(extracUserData['expiryDate'] as String);

    if (expireDate.isBefore(DateTime.now())) {
      print('gagal karna waktu sudah habis');
      return false;
    }
    _token = extracUserData['token'] as String;
    _expiredDate = expireDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _expiredDate = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    // _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      print("masuk authTimer");
      _authTimer?.cancel();
    }
    final timeToExpiry =
        _expiredDate?.difference(DateTime.now()).inSeconds as int;
    Timer(Duration(seconds: timeToExpiry), logOut);
    print("timeToExpiry ${timeToExpiry}");
  }
}
