import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import '../../../main.dart';
import '../dialog_create_delivery.dart';

class AddDeliveryRepository {
  ApiBaseHelper _helper = new ApiBaseHelper();
  late BuildContext _context;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  DialogDeliveryCreate widget;

  AddDeliveryRepository(
      this._context,
      this.widget
      );

  addDelivery(String minDistance, String maxDistance, String deliveryCharge,
      String minOrder, String deliveryTime) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        if (minDistance.isEmpty) {
          showMessage("Add Min. Distance", _context);
        } else if (maxDistance.length == 0) {
          showMessage("Add Max. Distance", _context);
        }  else if (deliveryTime.isEmpty) {
          showMessage("Add Del. Time", _context);
        } else {
          var body = jsonEncode({
            'minDistance': minDistance,
            'maxDistance': maxDistance,
            'deliveryCharge': deliveryCharge,
            'minOrder': minOrder,
            'deliveryTime': deliveryTime,
          });
          if (body.isNotEmpty) {
            Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
            try {
              final response = await _helper.post(
                  ApiBaseHelper.addDeliveryData, body, token);
              CommonModel model = CommonModel.fromJson(
                  _helper.returnResponse(_context, response));
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
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
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop();
              widget.onDialogClose();
            }
          }
        }
      });
    });
  }
}