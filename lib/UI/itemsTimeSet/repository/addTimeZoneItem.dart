import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/itemsTimeSet/model/time_zone_response_list.dart';
import 'package:food_inventory/UI/itemsTimeSet/restaurantSelect.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import '../../../main.dart';
import '../edit_scheduleZone.dart';

class AddItemsRepository {
  ApiBaseHelper _helper = new ApiBaseHelper();
  late BuildContext _context;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  DialogEditScheduleProduct widget;

  AddItemsRepository(this._context, this.widget);

/*  addOption(String timeRest, String timeRest2, List<String> days,List<ItemIds> items,  String name, String category) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
      List<dynamic> dataJson = [];
      String categorries;
      for (ItemIds data in items) {

          dataJson
              .add({'name': data.name.toString(),'id': data.sId.toString(),'categoryId': data.categoryID.toString()});

      }

      if(category == "Product")
        {
          categorries="items";
        }
      else{
        categorries="categories";
      }

      if(days.length ==0)
      {
        showMessage("Add Days", _context);
      }
      else if(items.length == 0)
        {
          showMessage("Add Items", _context);
        }
      else if(timeRest.isEmpty)
      {
        showMessage("Choose Start Time", _context);
      }
      else if(timeRest2.isEmpty)
      {
        showMessage("Choose End Time", _context);
      }
      else{
        var body = jsonEncode({
          'startTime': timeRest,
          'endTime': timeRest2,
          'restaurantId':restaurantId,
          'zoneGroup':categorries ,
          'items':dataJson ,
          'days': days,
          'name': name,
        });



      if (body.isNotEmpty) {
        Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
        try {
          final response =
          await _helper.post(ApiBaseHelper.addItemsTimeZone, body, token);

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
      }
    });

  });
        }*/
  addEditOption(String nameEdit, String timeRest, String timeRest2,
      List<String> days, List<SelectionModel> items, TimeZoneItemData listitem) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        List<dynamic> dataJson = [];
        String name;
        if (nameEdit.isNotEmpty) {
          name = nameEdit;
        } else {
          name = listitem.name.toString();
        }
        if (items.length != 0) {
          for (SelectionModel data in items) {
            dataJson.add({
              'name': data.name.toString(),
              'id': data.id.toString(),
              'categoryId': data.catId.toString()
            });
          }
        } else {
          for(int j=0;j< listitem.options!.length;j++)
            {
              // ignore: unused_local_variable
              dataJson.add({
                'name':listitem.options![j].name,
                'id': listitem.options![j].sId,
                'categoryId': listitem.options![j].categoryId,
              });
            }
        }

        if (timeRest.isEmpty) {
          timeRest = listitem.startTime.toString();
        }
        if (timeRest2.isEmpty) {
          timeRest2 = listitem.endTime.toString();
        }

        if (days.length == 0) {
          showMessage("Add Days", _context);
        } else if(items.length == 0) {
          showMessage("Add Items", _context);
        }  else {
          var body = jsonEncode({
            'id': listitem.sId,
            'startTime': timeRest,
            'endTime': timeRest2,
            'restaurantId': restaurantId,
            'zoneGroup': listitem.zoneGroup,
            'items': dataJson,
            'days': days,
            'name': name,
          });

          if (body.isNotEmpty) {
            Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
            try {
              final response =
                  await _helper.post(ApiBaseHelper.updateTimeZone, body, token);

              CommonModel model = CommonModel.fromJson(
                  _helper.returnResponse(_context, response));
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              if (model.success!) {
                Navigator.pop(_context);
                widget.onDialogClose();
              } else {
                widget.onDialogClose();
                showMessage(model.message!, _context);
              }
            } catch (e) {
              print(e.toString());
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
            }
          }
        }
      });
    });
  }
}
