import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

class CategoryRepository {
  ApiBaseHelper _helper = new ApiBaseHelper();
  late BuildContext _context;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  CategoryRepository(this._context);

  addCategory(
      String name, String discription, String discount, File imageFile) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      String fileName = File(imageFile.path).path.split("/").last;
      String fileType = File(imageFile.path).path.split(".").last;

      Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
      try {
        final response = await _helper.postMultiPartCategory(
            ApiBaseHelper.addCategories,
            File(imageFile.path),
            fileName,
            fileType,
            name,
            discription,
            discount.isEmpty ? '0' : discount,
            token);
        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context, response));
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
    });
  }

  addCategorywithoutImage(
    String name,
    String discription,
    String discount,
  ) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
      try {
        final response = await _helper.postMultiPartCategorywithoutimage(
            ApiBaseHelper.addCategories,
            name,
            discription,
            discount.isEmpty ? '0' : discount,
            token);
        print(response);
        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context, response));
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
    });
  }

  editCategory(String id, String name, String description, String discount,
      File imageFile) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        String fileName = File(imageFile.path).path.split("/").last;
        String fileType = File(imageFile.path).path.split(".").last;
        if (checkString(name)) {
          showMessage("Enter Category Name", _context);
        } else {
          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.putMultiPartCategory(
              ApiBaseHelper.updatecategory + "/" + id,
              File(imageFile.path),
              fileName,
              fileType,
              name,
              description,
              discount.isEmpty ? '0' : discount,
              token,
            );

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

  editCategorywithoutImage(
      String id, String name, String description, String discount) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        if (checkString(name)) {
          showMessage("Enter Category Name", _context);
        } else {
          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.putMultiPartCategorywithoutImage(
              ApiBaseHelper.updatecategory + "/" + id,
              name,
              description,
              discount.isEmpty ? '0' : discount,
              token,
            );

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
