import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/itemsTimeSet/model/time_zone_response_list.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import '../../../main.dart';
import '../dialog_edit_status.dart';

class StatusTimeZoneRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  late final BuildContext _context;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  DialogEditStatus widget;

  StatusTimeZoneRepository(this._context,this.widget);

  statusTimeZone(bool status,TimeZoneItemData listItem) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {



          var body = jsonEncode({
            'isActive': status,
            'id': listItem.sId,
          });



          if (body.isNotEmpty) {
            Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
            try {
              final response =
              await _helper.post(ApiBaseHelper.statusTimeZone, body, token);

              CommonModel model = CommonModel.fromJson(
                  _helper.returnResponse(_context, response));
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
              if (model.success!) {
                Navigator.pop(_context);
                widget.onDialogClose();
              } else {
                showMessage(model.message!, _context);
                widget.onDialogClose();
              }
            } catch (e) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
              widget.onDialogClose();
            }
          }

      });

    });
  }

}
