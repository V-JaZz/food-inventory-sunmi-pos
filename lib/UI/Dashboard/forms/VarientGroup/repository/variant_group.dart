import 'dart:convert';
import '../varientList.dart';

import 'package:flutter/cupertino.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

class VariantGroupsRepository {
  ApiBaseHelper _helper = new ApiBaseHelper();
  late BuildContext _context;
  late VarientListPage widget;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  VariantGroupsRepository(this._context, this.widget);

  addVariantGroup(String name, List<SelectionVariantListData> selectionList) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        var body;
        List<String> toppings = [];
        for (SelectionVariantListData toppingData in selectionList) {
          if (toppingData.isSelected) {
            toppings.add(toppingData.id);
          }
        }

        if (name.toString().trim().isEmpty) {
          showMessage("Enter Variant Group Name", _context);
          return;
        } else if (toppings.isEmpty) {
          showMessage("Select at least one Variant", _context);
        } else {
          body = jsonEncode(
              {'name': name.toString().trim(), 'variants': toppings});

          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.postwithid(
                ApiBaseHelper.addVariantGroups, body, token, restaurantId);

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

  editVariantGroup(
      String name, String id, List<SelectionVariantListData> selectionList) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        var body;
        List<String> toppings = [];
        for (SelectionVariantListData toppingData in selectionList) {
          if (toppingData.isSelected) {
            toppings.add(toppingData.id);
          }
        }

        if (name.isEmpty) {
          showMessage("Enter Variants Group Name", _context);
          return;
        } else if (toppings.isEmpty) {
          showMessage("Select at least one Variants", _context);
        } else {
          body = jsonEncode(
              {'name': name.toString().trim(), 'variants': toppings});

          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.put(
                ApiBaseHelper.updateVariantGroup + "/" + id,
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
