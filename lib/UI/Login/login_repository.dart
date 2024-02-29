// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_inventory/UI/Dashboard/dashboard.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/login_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class LoginRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final BuildContext? _context;

  final GlobalKey<State> _keyLoader =  GlobalKey<State>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String restaurantID;
  late String emailID;

  LoginRepository(this._context);

  login(String email, String pass, String deviceToken) async {
    if (checkString(pass)) {
      showMessage("Enter Password", _context!);
    } else {
      Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
      var deviceType = "";
      if (Platform.isAndroid) {
        deviceType = "Android";
      } else {
        deviceType = "IOS";
      }
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      print(version);
      try {
        final response = await _helper.post(
            ApiBaseHelper.login,
            jsonEncode(<String, String>{
              'email': email,
              'password': pass,
              'deviceToken': deviceToken,
              'appVersion': version,
              'deviceType': deviceType
            }),
            "");
        print("posting params");
        print(jsonEncode.toString());
        LoginModel model =
            LoginModel.fromJson(_helper.returnResponse(_context!, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        if (model.success!) {
          print("model response");
          print(model.success);
          StorageUtil.setData(StorageUtil.keyLoginData, jsonEncode(model.data));
          StorageUtil.setData(StorageUtil.keyLoginToken, model.data!.token);
          StorageUtil.setData(StorageUtil.keyEmail, model.data!.email);
          StorageUtil.setData(
              StorageUtil.keyRestaurantId, model.data!.restaurantId);
          emailID = model.data!.email!;

          final SharedPreferences prefs = await _prefs;
          restaurantID = model.data!.restaurantId!;
          print("login");
          print(restaurantID);
          prefs.setString('restaurant', restaurantID);
          Navigator.pushAndRemoveUntil(
              _context!,
              MaterialPageRoute(
                builder: (context) => const DashBoard(),
              ),
              (e) => false);
        } else {
          showMessage(model.message!, _context!);
        }
      } catch (e) {
        print(e.toString());
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    }
  }
}
