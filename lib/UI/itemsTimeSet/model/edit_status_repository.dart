import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/itemsTimeSet/model/time_zone_response_list.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import '../../../main.dart';
import '../dialog_editStatus.dart';

class StatusTimeZoneRepository {
  ApiBaseHelper _helper = new ApiBaseHelper();
  late BuildContext _context;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  DialogEditStatus widget;

  StatusTimeZoneRepository(this._context,this.widget);

  statusTimeZone(bool status,TimeZoneItemData listitem) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {



          var body = jsonEncode({
            'isActive': status,
            'id': listitem.sId,
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
              print(e.toString());
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
              widget.onDialogClose();
            }
          }

      });

    });
  }

}
