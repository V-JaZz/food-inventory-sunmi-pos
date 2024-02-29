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
  final ApiBaseHelper _helper = ApiBaseHelper();
  late final BuildContext _context;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  DialogDeliverySetting widget;

  EditDeliveryRepository(this._context, this.widget);

  updateDelivery(
      String postcode,
      /* String maxDistance,*/
      String deliveryCharge,
      String minOrder,
      String deliveryTime,
      DistanceDetail itemList) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        String postCodeData, delCharges, minimumOrder, delTime;
        if (postcode.isEmpty) {
          postCodeData = itemList.postcode.toString();
        } else {
          postCodeData = postcode;
        }

        /* if (maxDistance.length == 0) {
          maximunDistance = itemList.maxDistance.toString();
        } else {
          maximunDistance = maxDistance;
        }
*/
        if (deliveryCharge.isEmpty) {
          delCharges = itemList.deliveryCharge.toString();
        } else {
          delCharges = deliveryCharge;
        }

        if (minOrder.isEmpty) {
          minimumOrder = itemList.minOrder.toString();
        } else {
          minimumOrder = minOrder;
        }

        if (deliveryTime.isEmpty) {
          delTime = itemList.deliveryTime.toString();
        } else {
          delTime = deliveryTime;
        }

        var body = jsonEncode({
          'postcode': postCodeData,
          'deliveryCharge': delCharges,
          'minOrder': minimumOrder,
          'deliveryTime': delTime,
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
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            widget.onDialogClose();
          }
        }
      });
    });
  }
}
