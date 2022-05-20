// ignore_for_file: unnecessary_new, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/model/common_model.dart';


import '../../main.dart';
import '../../networking/api_base_helper.dart';

class InstanceActionRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final BuildContext? _context;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  InstanceActionRepository(this._context);

  changeAction(String isOnline) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!.then((restaurantId) async {
      Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
      try {
        final response = await _helper.put(
            ApiBaseHelper.instanceAction + "/" + isOnline,
            jsonEncode(<String, String>{}),
            value,restaurantId);
        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context!, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      } catch (e) {
        print(e.toString());
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    });
    });
  }
}
