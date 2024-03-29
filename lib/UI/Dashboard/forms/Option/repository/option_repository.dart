import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

class OptionRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  late final BuildContext _context;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  OptionRepository(this._context);

  addOption(String name, id, start, end) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
      try {
        final response = await _helper.post(
            ApiBaseHelper.addOptions,
            id == null || id == "null"
                ? jsonEncode(<String, String>{
                    'name': name,
                    // 'toppingGroup': id.toString().trim(),
                    'minToppings': end.toString(),
                    'maxToppings': start.toString()
                  })
                : jsonEncode(<String, String>{
                    'name': name,
                    'toppingGroup': id.toString().trim(),
                    'minToppings': end.toString(),
                    'maxToppings': start.toString()
                  }),
            token);

        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        if (model.success!) {
          Navigator.pop(_context);
        } else {
          showMessage(model.message!, _context);
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        // }
      }
    });
  }

  editOption(String _id, String name, id, start, end) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        if (checkString(name)) {
          showMessage("Enter Option Name", _context);
          // name = data.name.text.toString().trim();
          // topping = _toppingGrpData!.id.toString().trim();
        } else {
          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.put(
                ApiBaseHelper.updateoption + "/" + _id,
                id == null || id == "null"
                    ? jsonEncode(<String, String>{
                        'name': name,
                        // 'toppingGroup': id.toString().trim(),
                        'minToppings': end.toString(),
                        'maxToppings': start.toString()
                      })
                    : jsonEncode(<String, String>{
                        'name': name,
                        'toppingGroup': id.toString().trim(),
                        'minToppings': end.toString(),
                        'maxToppings': start.toString()
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
            if (kDebugMode) {
              print(e.toString());
            }
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          }
        }
      });
    });
  }
}
