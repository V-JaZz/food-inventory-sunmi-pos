import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:food_inventory/UI/dashboard/forms/toppingGroup/toppingsList.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

class ToppingGroupsRepository {
  ApiBaseHelper _helper = new ApiBaseHelper();
  late BuildContext _context;
  late ToppingListPage widget;
  // late EditToppingListPage widgetedit;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  ToppingGroupsRepository(this._context, this.widget);

  addToppingGroup(String name, List<SelectionToppingListData> selectionList) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        var body;
        List<String> toppings = [];
        for (SelectionToppingListData toppingData in selectionList) {
          if (toppingData.isSelected) {
            toppings.add(toppingData.id);
          }
        }

        if (name.toString().trim().isEmpty) {
          showMessage("Enter Topping Group Name", _context);
          return;
        } else if (toppings.isEmpty) {
          showMessage("Select at least one Topping", _context);
        } else {
          body = jsonEncode({
            'name': name.toString().trim(),
            'price': '0',
            'toppings': toppings
          });

          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.postwithid(
                ApiBaseHelper.addToppingGroups, body, token, restaurantId);

            CommonModel model = CommonModel.fromJson(
                _helper.returnResponse(_context, response));
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            if (model.success!) {
              Navigator.pop(_context);
              widget.onDialogClose();
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

  editToppingGroup(
      String name, String id, List<SelectionToppingListData> selectionList) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        var body;
        List<String> toppings = [];
        for (SelectionToppingListData toppingData in selectionList) {
          if (toppingData.isSelected) {
            toppings.add(toppingData.id);
          }
        }

        if (name.isEmpty) {
          showMessage("Enter Topping Group Name", _context);
          return;
        } else if (toppings.isEmpty) {
          showMessage("Select at least one Topping", _context);
        } else {
          body = jsonEncode({
            'name': name.toString().trim(),
            'price': '0',
            'toppings': toppings
          });

          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.put(
                ApiBaseHelper.updateToppingGroup + "/" + id,
                body,
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
