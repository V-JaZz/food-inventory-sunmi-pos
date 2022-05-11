import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

class ToppingsRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  late BuildContext _context;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  ToppingsRepository(this._context);

  addToppingData(String name, String price) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      List<dynamic> dataJson = [];
      if (name.toString().trim().isEmpty) {
        showMessage("Enter Topping Name", _context);
        return;
      } else if (price.toString().trim().isEmpty) {
        showMessage("Enter Topping Price", _context);
        return;
      } else {
        dataJson.add({
          'name': name.toString().trim(),
          'price':
              price.isEmpty ? '0' : price.toString().trim().replaceAll(',', '.')
        });
      }

      if (dataJson.isNotEmpty) {
        Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
        try {
          final response = await _helper.post(ApiBaseHelper.addToppings,
              jsonEncode(<String, dynamic>{'toppingDetails': dataJson}), token);

          CommonModel model =
              CommonModel.fromJson(_helper.returnResponse(_context, response));
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          if (model.success!) {
            Navigator.pop(_context);
          } else {
            showMessage(model.message!, _context);
          }
        } catch (e) {
          print(e.toString());
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        }
      }
    });
  }

  editTopping(String id, String name, String price) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        if (checkString(name)) {
          showMessage("Enter Topping Name", _context);
        } else if (checkString(price)) {
          showMessage("Enter Topping Price", _context);
        } else {
          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.put(
                ApiBaseHelper.updateTopping + "/" + id,
                jsonEncode(<String, String>{
                  'name': name.toString().trim(),
                  'price': price.isEmpty
                      ? '0'
                      : price.toString().trim().replaceAll(',', '.')
                }),
                token,
                restaurantId);

            CommonModel model = CommonModel.fromJson(
                _helper.returnResponse(_context, response));
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            if (model.success!) {
              Navigator.pop(_context);
            } else {
              showMessage(model.message!, _context);
            }
          } catch (e) {
            print(e.toString());
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          }
        }
      });
    });
  }
}
