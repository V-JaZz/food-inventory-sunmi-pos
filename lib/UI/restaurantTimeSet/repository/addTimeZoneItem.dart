import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/restaurantTimeSet/model/restaurant_time_slot_response_model.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import '../../../main.dart';
import '../dialog_add_time_zone.dart';

class AddTimeZoneRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  late final BuildContext _context;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  DialogAddTimeSlot widget;

  AddTimeZoneRepository(this._context, this.widget);

  addTimeZone(
      String timeRest, String timeRest2, List<String> days, String name,holidayDates) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        if (name.isEmpty) {
          showMessage("Add Time Zone Name", _context);
        } else if (days.isEmpty) {
          showMessage("Add Days", _context);
        } else if (timeRest.isEmpty) {
          showMessage("Choose Start Time", _context);
        } else if (timeRest2.isEmpty) {
          showMessage("Choose End Time", _context);
        } else {
          var body = jsonEncode({
            'openTime': timeRest,
            'closeTime': timeRest2,
            'restaurantId': restaurantId,
            'days': days,
            'name': name,
            'holidayDates':holidayDates,
          });

          if (body.isNotEmpty) {
            Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
            try {
              final response = await _helper.post(
                  ApiBaseHelper.addRestaurantTimeSlot, body, token);

              CommonModel model = CommonModel.fromJson(
                  _helper.returnResponse(_context, response));
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              if (model.success!) {
                Navigator.pop(_context);
                widget.onDialogClose();
              } else {
                showMessage(model.message!, _context);
                widget.onDialogClose();
              }
            } catch (e) {
              print(e.toString());
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              widget.onDialogClose();
            }
          }
        }
      });
    });
  }

  editTimeZone(String timeRest, String timeRest2, List<String> days, TimeSlotItemData listitem,String name) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {

        if (timeRest.isEmpty) {
          timeRest = listitem.startTime.toString();
        }
        if (timeRest2.isEmpty) {
          timeRest2 = listitem.endTime.toString();
        }

        if(name.isEmpty)
          {
            name=listitem.name.toString();
          }

        if (days.isEmpty) {
          showMessage("Add Days", _context);
        } else {
          var body = jsonEncode({
            'id': listitem.sId,
            'openTime': timeRest,
            'closeTime': timeRest2,
            'restaurantId': restaurantId,
            'days': days,
            'name': name,
          });

          if (body.isNotEmpty) {
            Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
            try {
              final response =
                  await _helper.post(ApiBaseHelper.updateRestaurantTimeSlot, body, token);

              CommonModel model = CommonModel.fromJson(
                  _helper.returnResponse(_context, response));
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              if (model.success!) {
                Navigator.pop(_context);
                widget.onDialogClose();
              } else {
                showMessage(model.message!, _context);
                widget.onDialogClose();
              }
            } catch (e) {
              print(e.toString());
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              widget.onDialogClose();
            }
          }
        }
      });
    });
  }

  updateStatusTimeZone(bool status,TimeSlotItemData listitem) {
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
            await _helper.post(ApiBaseHelper.updateStatusRestaurantTimeSlot, body, token);

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
