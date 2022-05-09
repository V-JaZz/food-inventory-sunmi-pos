import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/login_model.dart';
import '../../main.dart';

class RestaurantDetailsRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  late BuildContext context;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  RestaurantDetailsRepository(this.context);

  updateProfile(
    TextEditingController nameController,
    TextEditingController addressController,
    TextEditingController postcodeController,
    TextEditingController phoneController,
    TextEditingController emailController,
    TextEditingController vatController,
    TextEditingController deliveryTimeController,
    TextEditingController collectionTimeController,
  ) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        if (collectionTimeController.text.toString().trim().isEmpty) {
          showMessage("Enter Collection Time", context);
        } else {
          List<dynamic> postcode = [];

          postcode.add(postcodeController.text.toString().trim());
          var body = jsonEncode({
            'restaurantName': nameController.text.toString().trim(),
            'location': addressController.text.toString().trim(),
            'shortDescription': 'shortDescription',
            'image': 'image',
            'phoneNumber': phoneController.text.toString().trim(),
            'restEmail': emailController.text.toString().trim(),
            'vatNumber': vatController.text.toString().trim(),
            'collectionTime': collectionTimeController.text.toString().trim(),
            'passcode': postcode,
          });

          Dialogs.showLoadingDialog(context, _keyLoader);
          try {
            final response = await _helper.put(
                ApiBaseHelper.editProfile, body, value, restaurantId);
            LoginModel model =
                LoginModel.fromJson(_helper.returnResponse(context, response));

            restaurantName = defaultValue(model.data!.restaurantName, "N/A");

            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            if (model.success!) {
              StorageUtil.setData(
                  StorageUtil.keyLoginData, json.encode(model.data));
            } else {
              showMessage(model.message!, context);
            }
          } catch (e) {
            print(e.toString());
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          }
        }
      });
    });
  }

  updateSetting(
    TextEditingController wifiController,
    TextEditingController wifiPortController,
    TextEditingController deliveryController,
    TextEditingController minimumController,
    TextEditingController webSiteUrl,
    String autoAccept,
    String autoPrint,
    String allowOnlineDelivery,
    String allowOnlinePickup,
    String isReservationActive,
  ) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        if (wifiController.text.toString().trim().isEmpty) {
          showMessage("Enter Wifi IP Address", context);
        } else if (wifiPortController.text.toString().trim().isEmpty) {
          showMessage("Enter Port Number", context);
        } else if (deliveryController.text.toString().trim().isEmpty) {
          showMessage("Enter Delivery Radius", context);
        } else if (minimumController.text.toString().trim().isEmpty) {
          showMessage("Enter Minimum Order Value", context);
        } else if (webSiteUrl.text.toString().toString().isEmpty) {
          showMessage("Enter Website Url", context);
        } else {
          var body = jsonEncode({
            'wifiPrinterIP': wifiController.text.toString().trim(),
            'wifiPrinterPort': wifiPortController.text.toString().trim(),
            'deliveryRadius': deliveryController.text.toString().trim(),
            'minimumOrder':
                minimumController.text.toString().trim().replaceAll(',', '.'),
            "websiteURL": webSiteUrl.text.toString().trim(),
            "autoAccept": autoAccept,
            "autoPrint": autoPrint,
            "allowOnlineDelivery": allowOnlineDelivery,
            "allowOnlinePickup": allowOnlinePickup,
            "isReservationActive": isReservationActive,
          });

          Dialogs.showLoadingDialog(context, _keyLoader);
          try {
            final response = await _helper.put(
                ApiBaseHelper.restaurantSetting, body, value, restaurantId);
            LoginModel model =
                LoginModel.fromJson(_helper.returnResponse(context, response));
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            if (model.success!) {
              StorageUtil.setData(
                  StorageUtil.keyLoginData, json.encode(model.data));
            } else {
              showMessage(model.message!, context);
            }
          } catch (e) {
            print(e.toString());
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          }
        }
      });
    });
  }

  updateRestaurantImageType(File imageFile, String type) async {
    String fileName = File(imageFile.path).path.split("/").last;
    String fileType = File(imageFile.path).path.split(".").last;
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      Dialogs.showLoadingDialog(context, _keyLoader);
      try {
        final response = await _helper.putMultiPart(
            ApiBaseHelper.addRestaurantImage,
            File(imageFile.path),
            fileName,
            fileType,
            type,
            value);
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      } catch (e) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    });
  }
}
