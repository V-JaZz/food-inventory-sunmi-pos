import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/restaurentTimeSet/dialog_delete_time.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import '../../../main.dart';

class DeleteTimeZoneRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  BuildContext? _context;
  late String delID;
  DialogDeleteTimeZone widget;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  DeleteTimeZoneRepository(this._context, this.widget);

  deleteMenuItemData(String delID) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
      try {
        var body = jsonEncode({
          'id': delID,
        });
        final response =
        await _helper.post(ApiBaseHelper.deleteRestaurantTimeSlot, body, token);
        CommonModel model =
        CommonModel.fromJson(_helper.returnResponse(_context!, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

        if (model.success!) {
          Navigator.pop(_context!);
          widget.onDialogClose();
        } else {
          showMessage(model.message!, _context!);
          widget.onDialogClose();
        }
      } catch (e) {
        print(e.toString());
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        widget.onDialogClose();
      }
    });
  }
}
