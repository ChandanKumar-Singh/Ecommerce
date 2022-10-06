import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_ecommerce_app/Models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  late Users user;
  late SharedPreferences prefs;

  Future<bool> checkLogin() async {
    prefs = await SharedPreferences.getInstance();
    var userPrefs = prefs.getString('user');

    if (userPrefs == null) {
      await login(username: "+63 791 675 8914", password: 'password');
      print(user.phone);
      return true;
    } else {
      user = Users.fromJson(jsonDecode(userPrefs));
      print(user.phone);

      return true;
    }
  }

  Future<void> login(
      {required String username, required String password}) async {
    prefs = await SharedPreferences.getInstance();
    var userJson = {
      "id": 1,
      "firstName": "Terry",
      "lastName": "Medhurst",
      "maidenName": "Smitham",
      "age": 50,
      "gender": "male",
      "email": "atuny0@sohu.com",
      "phone": username,
      "username": "atuny0",
      "password": "9uQFF1Lh",
      "birthDate": "2000-12-25",
      "image": "https://robohash.org/hicveldicta.png",
      "bloodGroup": "A−",
      "height": 189,
      "weight": 75.4,
      "eyeColor": "Green",
      "hair": {"color": "Black", "type": "Strands"},
      "domain": "slashdot.org",
      "ip": "117.29.86.254",
      "address": {
        "address": "1745 T Street Southeast",
        "city": "Washington",
        "coordinates": {"lat": 38.867033, "lng": -76.979235},
        "postalCode": "20020",
        "state": "DC"
      },
      "macAddress": "13:69:BA:56:A3:74",
      "university": "Capitol University",
      "bank": {
        "cardExpire": "06/22",
        "cardNumber": "50380955204220685",
        "cardType": "maestro",
        "currency": "Peso",
        "iban": "NO17 0695 2754 967"
      },
      "company": {
        "address": {
          "address": "629 Debbie Drive",
          "city": "Nashville",
          "coordinates": {"lat": 36.208114, "lng": -86.58621199999999},
          "postalCode": "37076",
          "state": "TN"
        },
        "department": "Marketing",
        "name": "Blanda-O'Keefe",
        "title": "Help Desk Operator"
      },
      "ein": "20-9487066",
      "ssn": "661-64-2976",
      "userAgent":
          "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/12.0.702.0 Safari/534.24"
    };
    user = Users.fromJson(userJson);
    await prefs.setString('user', jsonEncode(userJson));
    // print('User initiated');
    Fluttertoast.showToast(msg: 'Logging In Successfully');
  }

  Future<void> userData() async {
    CollectionReference reference = FirebaseFirestore.instance
        .collection('ecommerce')
        .doc('admin')
        .collection('users');
    try {
      var data = await reference.doc(user.phone!).get();
      user = Users.fromJson(data.data() as Map<String, dynamic>);
      await prefs.setString('user', jsonEncode(data.data()));
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e.message);
      print(e.code);
    }
  }
}
