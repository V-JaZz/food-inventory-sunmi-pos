// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/menu/dialog_delete_type.dart';
import 'package:food_inventory/UI/menu/dialog_type_list_view.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

import '../../../main.dart';

class DeleteDataRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final BuildContext? _context;
  late TypeListDataModel dataModel;
  late DialogDeleteType widget;

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  DeleteDataRepository(this._context, this.widget, this.dataModel);

  deleteToppingData() {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
      try {
        final response = await _helper.delete(
            ApiBaseHelper.deleteTopping + "/" + dataModel.id, value);
        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context!, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

        if (model.success!) {
          Navigator.pop(_context!);
          widget.onDialogClose();
        } else {
          showMessage(model.message!, _context!);
        }
      } catch (e) {
        print(e.toString());
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    });
  }

  deleteCategoryData() {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
      try {
        final response = await _helper.delete(
            ApiBaseHelper.deletecategory + "/" + dataModel.id, value);
        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context!, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

        if (model.success!) {
          Navigator.pop(_context!);
          widget.onDialogClose();
        } else {
          showMessage(model.message!, _context!);
        }
      } catch (e) {
        print(e.toString());
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    });
  }

  deleteOptionData() {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
      try {
        final response = await _helper.delete(
            ApiBaseHelper.deleteOption + "/" + dataModel.id, value);
        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context!, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

        if (model.success!) {
          Navigator.pop(_context!);
          widget.onDialogClose();
        } else {
          showMessage(model.message!, _context!);
        }
      } catch (e) {
        print(e.toString());
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    });
  }

  deleteToppingGroupData() {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
      try {
        final response = await _helper.delete(
            ApiBaseHelper.deleteToppingGroup + "/" + dataModel.id, value);
        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context!, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

        if (model.success!) {
          Navigator.pop(_context!);
          widget.onDialogClose();
        } else {
          showMessage(model.message!, _context!);
        }
      } catch (e) {
        print(e.toString());
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    });
  }

  deleteMenuItemData() {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
      try {
        final response = await _helper.delete(
            ApiBaseHelper.deleteitem + "/" + dataModel.id, value);
        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context!, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

        if (model.success!) {
          Navigator.pop(_context!);
          widget.onDialogClose();
        } else {
          showMessage(model.message!, _context!);
        }
      } catch (e) {
        print(e.toString());
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    });
  }

  deleteAllergyData() {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
      try {
        final response = await _helper.delete(
            ApiBaseHelper.deleteAllergies + "/" + dataModel.id, value);
        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context!, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

        if (model.success!) {
          Navigator.pop(_context!);
          widget.onDialogClose();
        } else {
          showMessage(model.message!, _context!);
        }
      } catch (e) {
        print(e.toString());
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    });
  }

  deleteAllergyGroupData() {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
      try {
        final response = await _helper.delete(
            ApiBaseHelper.deleteAllergiesGroup + "/" + dataModel.id, value);
        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context!, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

        if (model.success!) {
          Navigator.pop(_context!);
          widget.onDialogClose();
        } else {
          showMessage(model.message!, _context!);
        }
      } catch (e) {
        print(e.toString());
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    });
  }

  deleteVariantGroupData() {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
      try {
        final response = await _helper.delete(
            ApiBaseHelper.deleteVariantGroup + "/" + dataModel.id, value);
        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context!, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

        if (model.success!) {
          Navigator.pop(_context!);
          widget.onDialogClose();
        } else {
          showMessage(model.message!, _context!);
        }
      } catch (e) {
        print(e.toString());
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    });
  }

  deleteVariantData() {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
      try {
        final response = await _helper.delete(
            ApiBaseHelper.deleteVariant + "/" + dataModel.id, value);
        CommonModel model =
            CommonModel.fromJson(_helper.returnResponse(_context!, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

        if (model.success!) {
          Navigator.pop(_context!);
          widget.onDialogClose();
        } else {
          showMessage(model.message!, _context!);
        }
      } catch (e) {
        print(e.toString());
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    });
  }
}
