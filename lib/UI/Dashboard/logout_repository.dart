import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_inventory/UI/Login/login.dart';
import 'package:food_inventory/model/common_model.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/validation_util.dart';
import '../../main.dart';
import '../../networking/api_base_helper.dart';

class LogoutRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  BuildContext? _context;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // late String emailid;

  LogoutRepository(this._context);

  logout(String email) async {
    if (checkString(email)) {
      showMessage("Enter Email", _context!);
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
        final response = await _helper.post(ApiBaseHelper.logout,
            jsonEncode(<String, String>{'email': email}), "");
        print("posting pramas");
        print(jsonEncode.toString());
        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context!, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        if (model.success!) {
          print("model response");
          print(model.success);
          // StorageUtil.setData(StorageUtil.keyLoginData, jsonEncode(model.data));
          // StorageUtil.setData(StorageUtil.keyLoginToken, model.data!.token);
          // StorageUtil.setData(StorageUtil.keyEmail, model.data!.email);
          // StorageUtil.setData(
          //     StorageUtil.keyRestaurantId, model.data!.restaurantId);
          // emailid = model.data!.email!;

          // final SharedPreferences prefs = await _prefs;
          // restaurantid=model.data!.restaurantId!;
          // print("login");
          // print(restaurantid);
          // prefs.setString('restaurant', restaurantid);
          Navigator.pushAndRemoveUntil(
              _context!,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
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
