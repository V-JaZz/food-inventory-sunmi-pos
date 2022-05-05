import 'dart:convert';
import 'dart:io' show Directory, File, Platform, Process;
import 'dart:ffi' as ffi;
import 'package:food_inventory/UI/order/dialog_order_details.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';

typedef PlaySoundFunc = ffi.Void Function();
typedef PlayWorld = void Function();
var libraryPath =
    path.join(Directory.current.path, 'hello_library', 'Release', 'hello.dll');
final dylib = ffi.DynamicLibrary.open(libraryPath);
final PlayWorld playSound =
    dylib.lookup<ffi.NativeFunction<PlaySoundFunc>>('stop').asFunction();

class OrderManageRepository {
  ApiBaseHelper _helper = new ApiBaseHelper();
  late BuildContext context;
  late OrderDetailsDialog widget;
  
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  OrderManageRepository(this.context, this.widget);

  changeOrderStatus(String status) {
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
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          if (model.success!) {
            ApiBaseHelper.pending = ApiBaseHelper.pending - 1;
            if (ApiBaseHelper.pending < 1) {
              playSound();
              ApiBaseHelper.orderbool = true;
            }
            Navigator.pop(context);
            widget.onOrderUpdate();
          } else {
            showMessage(model.message!, context);
          }
        } catch (e) {
          print(e.toString());
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        }
      });
    });
  }
}
