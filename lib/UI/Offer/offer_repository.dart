import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:food_inventory/UI/Offer/offer_success_model.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

import '../../main.dart';

class OfferRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  late BuildContext context;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  OfferRepository(this.context);

  addOffer(TextEditingController controller,TextEditingController controllerOffer) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!.then((restaurantId) async {
      Dialogs.showLoadingDialog(context, _keyLoader);
      try {
        final response = await _helper.put(
            ApiBaseHelper.updateDiscount,
            jsonEncode(<String, String>{
              'deliveryDiscount':controller.text.toString().trim(),
              'collectionDiscount':controllerOffer.text.toString().trim()
            }),
            value,restaurantId);
        OfferSuccessModel model = OfferSuccessModel.fromJson(
            _helper.returnResponse(context, response));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        showMessage(model.data!, context);

      } catch (e) {
        print(e.toString());
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    });
    });
  }
  
}
