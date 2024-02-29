import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/itemsTimeSet/restaurant_select.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import '../../../main.dart';
import '../dialog_schedule_product.dart';

class AddNewTimeZoneRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  late final BuildContext _context;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  DialogScheduleProduct widget;
  AddNewTimeZoneRepository(this._context, this.widget);

  addOption(String timeRest, String timeRest2, List<String> days,
      List<SelectionModel> items, String name, String category) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        List<dynamic> dataJson = [];
        String categorries;
        for (SelectionModel data in items) {
          dataJson.add({
            'name': data.name.toString(),
            'id': data.id.toString(),
            'categoryId': data.catId.toString()
          });
        }

        if (category == "Product") {
          categorries = "items";
        } else {
          categorries = "categories";
        }

        if (days.isEmpty) {
          showMessage("Add Days", _context);
        } else if (items.isEmpty) {
          showMessage("Add Items", _context);
        } else if (timeRest.isEmpty) {
          showMessage("Choose Start Time", _context);
        } else if (timeRest2.isEmpty) {
          showMessage("Choose End Time", _context);
        } else {
          var body = jsonEncode({
            'startTime': timeRest,
            'endTime': timeRest2,
            'restaurantId': restaurantId,
            'zoneGroup': categorries,
            'items': dataJson,
            'days': days,
            'name': name,
          });

          if (body.isNotEmpty) {
            Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
            try {
              final response = await _helper.post(
                  ApiBaseHelper.addItemsTimeZone, body, token);

              CommonModel model = CommonModel.fromJson(
                  _helper.returnResponse(_context, response));
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              if (model.success!) {
                Navigator.pop(_context);
                Navigator.pop(_context);
                widget.onDialogClose();
              } else {
                widget.onDialogClose();
                showMessage(model.message!, _context);
              }
            } catch (e) {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
            }
          }
        }
      });
    });
  }
}
