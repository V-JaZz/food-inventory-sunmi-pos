import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/DeliverySettings/repository/models/delivery_data_model.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

import '../../../main.dart';
import '../dailog_delivery_setting.dart';

class EditDeliveryRepository {
  ApiBaseHelper _helper = new ApiBaseHelper();
  late BuildContext _context;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  DialogDeliverySetting widget;

  EditDeliveryRepository(this._context, this.widget);

  updateDelivery(String minDistance, String maxDistance, String deliveryCharge,
      String minOrder, String deliveryTime, DistanceDetail itemList) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        String minimumDistance,
            maximunDistance,
            DelCharge,
            MinimumOrder,
            DelTime;
        if (minDistance.isEmpty) {
          minimumDistance = itemList.minDistance.toString();
        } else {
          minimumDistance = minDistance;
        }

        if (maxDistance.length == 0) {
          maximunDistance = itemList.maxDistance.toString();
        } else {
          maximunDistance = maxDistance;
        }

        if (deliveryCharge.isEmpty) {
          DelCharge = itemList.deliveryCharge.toString();
        } else {
          DelCharge = deliveryCharge;
        }

        if (minOrder.isEmpty) {
          MinimumOrder = itemList.minOrder.toString();
        } else {
          MinimumOrder = minOrder;
        }

        if (deliveryTime.isEmpty) {
          DelTime = itemList.deliveryTime.toString();
        } else {
          DelTime = deliveryTime;
        }

        var body = jsonEncode({
          'minDistance': minimumDistance,
          'maxDistance': maximunDistance,
          'deliveryCharge': DelCharge,
          'minOrder': MinimumOrder,
          'deliveryTime': DelTime,
          'id': itemList.id.toString(),
        });

        if (body.isNotEmpty) {
          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.post(
                ApiBaseHelper.updateDeliveryData, body, token);

            CommonModel model = CommonModel.fromJson(
                _helper.returnResponse(_context, response));
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            if (model.success!) {
              Navigator.pop(_context);
              widget.onDialogClose();
            } else {
              showMessage(model.message!, _context);
              Navigator.pop(_context);
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

  deleteDelivery(String id) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        var body = jsonEncode({
          'id': id,
        });

        if (body.isNotEmpty) {
          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.post(
                ApiBaseHelper.deleteDeliveryData, body, token);

            CommonModel model = CommonModel.fromJson(
                _helper.returnResponse(_context, response));
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            if (model.success!) {
              Navigator.pop(_context);
              widget.onDialogClose();
            } else {
              showMessage(model.message!, _context);
              Navigator.pop(_context);
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
