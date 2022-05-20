import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

class VariantRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  late final BuildContext _context;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  VariantRepository(this._context);

  addVarient(String name, id) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      List<dynamic> dataJson = [];
      if (name.toString().trim().isEmpty) {
        showMessage("Enter Varient Name", _context);
        return;
      } else {
        id == null
            ? dataJson.add({
                'name': name.toString().trim(),
                'price': "0",
              })
            : dataJson.add({
                'name': name.toString().trim(),
                'price': "0",
                'variantGroup': id.toString().trim(),
              });
      }
      if (dataJson.isNotEmpty) {
        Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
        try {
          final response = await _helper.post(ApiBaseHelper.addVariants,
              jsonEncode(<String, dynamic>{'variantDetails': dataJson}), token);

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
      }
    });
  }

  editVarient(
    name,
    id,
    sId,
  ) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
        try {
          final response = await _helper.put(
              ApiBaseHelper.updateVariant + "/" + sId,
              id == null
                  ? jsonEncode(<dynamic, dynamic>{
                      'name': name.toString().trim(),
                      'price': "0",
                    })
                  : jsonEncode(<dynamic, dynamic>{
                      'name': name.toString().trim(),
                      'price': "0",
                      'variantGroup': id,
                    }),
              token,
              restaurantId);

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
        }
        // }
      });
    });
  }
}
