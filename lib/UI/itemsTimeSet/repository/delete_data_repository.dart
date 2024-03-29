import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/itemsTimeSet/dialog_delete_type.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import '../../../main.dart';

class DeleteDataRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final BuildContext? _context;
  late String delID;
  DialogDeleteType widget;

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  DeleteDataRepository(this._context, this.widget);

  deleteMenuItemData(String delID) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
      try {
        var body = jsonEncode({
          'id': delID,
        });
        final response =
        await _helper.post(ApiBaseHelper.deleteTimeZone, body, token);
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
