import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:user/utilities/server.dart';

class AccountAPI {
  static Future<bool> post({
    String? phone,
    String? email,
    required String token,
    required String name,
    required String gender,
    required String birth,
  }) async {
    var fromater = DateFormat('y-M-d');
    final fcmToken = await FirebaseMessaging.instance.getToken();
    http.Response response =
        await Server.send(http.post, 'accounts/create', useToken: false, body: {
      'user': {
        "token": token,
        'fcmToken': fcmToken,
        "name": name,
      },
      'phone':
          phone?.replaceAll(' ', '').replaceAll('+', '').replaceAll('-', ''),
      'email': email,
      'gender': gender,
      'birth': birth
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 201) {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      return true;
    }
    return false;
  }

  static Future<bool> checkPhoneExists(String phone) async {
    http.Response response = await Server.send(
        http.get, 'accounts/check-phone', useToken: false, body: {
      'phone': phone.replaceAll(' ', '').replaceAll('+', '').replaceAll('-', '')
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      return data['exists'];
    }

    throw Exception();
  }

  static void SetFCMToken(String token) async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        var response = await Server.send(http.put, 'accounts/set-fcm-token',
            body: {"token": token});
        if (response.statusCode == 200) {
          print('token set');
        }
      }
    } catch (e) {}
  }

  static Future<String> addLocation(
      String name, String address, double lat, double lng) async {
    http.Response response =
        await Server.send(http.post, 'accounts/location', body: {
      'name': name,
      'details': address,
      'lat': lat,
      'lng': lng,
    });
    print(response.body);
    if (response.statusCode == 201) {
      return utf8.decode(response.bodyBytes);
    }

    throw Exception();
  }

  static Future<String> getLocations() async {
    http.Response response = await Server.send(
      http.get,
      'accounts/location',
    );
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }

    throw Exception();
  }

  static Future<String> getProfile() async {
    http.Response response = await Server.send(http.get, 'accounts/profile');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<void> setPhone(String phone) async {
    http.Response response =
        await Server.send(http.put, 'accounts/profile', body: {
      'phone': phone,
    });
    if (response.statusCode == 200) {
      return;
    }
    throw Exception();
  }

  static Future<String> login() async {
    http.Response response = await Server.send(http.get, 'accounts/login');
    print(response.body);
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<String> getShareData() async {
    http.Response response = await Server.send(http.get, 'accounts/share-data');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<void> scanCode(int code) async {
    http.Response response = await Server.send(
      http.put,
      'accounts/scan-code',
      body: {
        "code": code,
      },
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw CodeScanExp(code: response.statusCode);
    }
  }

  static Future<String> getRateData() async {
    http.Response response = await Server.send(http.get, 'accounts/rate');
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    throw Exception();
  }

  static Future<void> setRate(int value) async {
    http.Response response =
        await Server.send(http.put, 'accounts/rate', body: {
      "value": value,
    });
    if (response.statusCode == 200) {
      return;
    }
    throw Exception();
  }
}

class CodeScanExp implements Exception {
  int code;
  CodeScanExp({
    required this.code,
  });
}
