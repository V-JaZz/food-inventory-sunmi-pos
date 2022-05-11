import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

import '../allergyList.dart';

class AllergyGroupsRepository {
  final ApiBaseHelper _helper =  ApiBaseHelper();
  late final BuildContext _context;
  late AllergyListPage widget;
  final GlobalKey<State> _keyLoader =  GlobalKey<State>();

  AllergyGroupsRepository(this._context, this.widget);
  addAllergyGroup(String name, List<SelectionAllergyListData> selectionList) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        var body;
        List<String> toppings = [];
        for (SelectionAllergyListData toppingData in selectionList) {
          if (toppingData.isSelected) {
            toppings.add(toppingData.id);
          }
        }

        if (name.toString().trim().isEmpty) {
          showMessage("Enter Allergy Group Name", _context);
          return;
        } else if (toppings.isEmpty) {
          showMessage("Select at least one Allergy", _context);
        } else {
          body = jsonEncode(
              {'name': name.toString().trim(), 'allergies': toppings});

          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.postwithid(
                ApiBaseHelper.addAllergiesGroup, body, token, restaurantId);
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

  editAllergyGroup(
      String name, String id, List<SelectionAllergyListData> selectionList) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        var body;
        List<String> toppings = [];
        for (SelectionAllergyListData toppingData in selectionList) {
          if (toppingData.isSelected) {
            toppings.add(toppingData.id);
          }
        }

        if (name.isEmpty) {
          showMessage("Enter Allergy Group Name", _context);
          return;
        } else if (toppings.isEmpty) {
          showMessage("Select at least one Allergy", _context);
        } else {
          body = jsonEncode(
              {'name': name.toString().trim(), 'allergies': toppings});

          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.post(
                ApiBaseHelper.updateAllergiesGroup + "/" + id, body, token);

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
