import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/http_exception.dart';
import '../model/config.dart';

class ProfileUser with ChangeNotifier {
  String? _phoneNumber;

  String? get phoneNumber {
    return _phoneNumber;
  }

  Future<void> fetchPhoneNumberUser() async {
    final url = Uri.parse('${Config().urlDevLive}profile/getUserPhoneNumber');
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(prefs.getString('userData') as String);
      print("ini token di profile provider ${userData["token"]}");
      final response = await http.post(
        url,
        headers: Config().header(userData["token"]),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode >= 400) {
        print('ini d error get PhoneNumber ${responseData}');
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == true) {
        _phoneNumber = responseData["data"].toString();
      } else {
        _phoneNumber = "";
      }
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> editPhoneNumberUser(String phoneNumber) async {
    final url = Uri.parse('${Config().urlDevLive}profile/editUserProfile');
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.decode(prefs.getString('userData') as String);
      print("ini token di profile provider ${userData["token"]}");
      final response = await http.post(
        url,
        headers: Config().header(userData["token"]),
        body: jsonEncode({"phoneNumber": phoneNumber}),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        print('ini d error post phoneNumberUser ${responseData}');
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == true) {
        await fetchPhoneNumberUser();
      }

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
