// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:foodinventory/constant/storage_util.dart';
// import 'package:foodinventory/model/common_model.dart';
// import 'package:foodinventory/networking/api_base_helper.dart';

// import '../../main.dart';

// class OnlineOrderRepository {
//   ApiBaseHelper _helper = ApiBaseHelper();
//   BuildContext? _context;
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();

//   OnlineOrderRepository(this._context);

//   onlineOrder(String isOnline, String type) async {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
//       StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
//           .then((restaurantId) async {
//         Dialogs.showLoadingDialog(_context!, _keyLoader); //invoking login
//         try {
//           // type == "Del" ? "allowOnlineDelivery" : "allowOnlineDelivery";
//           final response = await _helper.put(
//               ApiBaseHelper.updateOnlineOrdering,
//               jsonEncode(<String, String>{
//                 type == "Del" ? "allowOnlineDelivery" : "allowOnlinePickup":
//                     isOnline
//               }),
//               value,
//               restaurantId);
//           CommonModel model =
//               CommonModel.fromJson(_helper.returnResponse(_context!, response));
//           Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//         } catch (e) {
//           print(e.toString());
//           Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//         }
//       });
//     });
//   }
// }
