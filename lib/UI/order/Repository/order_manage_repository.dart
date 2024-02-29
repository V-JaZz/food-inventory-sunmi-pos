// ignore_for_file: unused_shown_name

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:food_inventory/UI/order/dialog_order_details.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

import 'package:flutter/material.dart';

class OrderManageRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  late BuildContext context;
  late OrderDetailsDialog widget;

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  OrderManageRepository(this.context, this.widget);

  changeOrderStatus(String status) {
    print("Change Order Status init manually");
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
        try {
          final response = await _helper.put(
              ApiBaseHelper.updateorderstatus +
                  "/" +
                  widget.orderDataModel.sId!,
              jsonEncode(<String, String>{'orderStatus': status}),
              value,
              restaurantId);
          CommonModel model =
              CommonModel.fromJson(_helper.returnResponse(context, response));
         // Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          if (model.success!) {
           /* ApiBaseHelper.pending = ApiBaseHelper.pending - 1;
            if (ApiBaseHelper.pending < 1) {
              playSound();
              ApiBaseHelper.orderbool = true;
            }*/

            Navigator.pop(context);
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            widget.onOrderUpdate();
          } else {
            showMessage(model.message!, context);
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        }
      });
    });
  }
}
