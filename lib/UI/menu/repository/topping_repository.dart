// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:foodinventory/constant/storage_util.dart';
// import 'package:foodinventory/constant/validation_util.dart';
// import 'package:foodinventory/model/common_model.dart';
// import 'package:foodinventory/networking/api_base_helper.dart';
// import 'package:foodinventory/ui/menu/model/add_type_model.dart';

// import '../../../main.dart';
// import '../dialog_type_list_view.dart';

// class ToppingsRepository {
//   ApiBaseHelper _helper = ApiBaseHelper();
//   late BuildContext _context;
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();

//   ToppingsRepository(this._context);

//   addToppingData(List<AddTypeModel> toppingList) async {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//       List<dynamic> dataJson = [];
//       for (AddTypeModel data in toppingList) {
//         if (data.name.text.toString().trim().isEmpty) {
//           showMessage("Enter Topping Name", _context);
//           return;
//         } else if (data.price.text.toString().trim().isEmpty) {
//           showMessage("Enter Topping Price", _context);
//           return;
//         } else {
//           dataJson.add({
//             'name': data.name.text.toString().trim(),
//             'price': data.price.text.isEmpty?'0':data.price.text.toString().trim().replaceAll(',', '.')
//           });
//         }
//       }

//       if (dataJson.isNotEmpty) {
//         Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//         try {
//           final response = await _helper.post(ApiBaseHelper.addToppings,
//               jsonEncode(<String, dynamic>{'toppingDetails': dataJson}), token);

//           CommonModel model =
//               CommonModel.fromJson(_helper.returnResponse(_context, response));
//           Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//           if (model.success!) {
//             Navigator.pop(_context);
//           } else {
//             showMessage(model.message!, _context);
//           }
//         } catch (e) {
//           print(e.toString());
//           Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//         }
//       }
//     });
//   }

//   editTopping(TypeListDataModel dataModel, String name, String price) async {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//       StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
//           .then((restaurantId) async {
//         if (checkString(name)) {
//           showMessage("Enter Topping Name", _context);
//         } else if (checkString(price)) {
//           showMessage("Enter Topping Price", _context);
//         } else {
//           Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//           try {
//             final response = await _helper.put(
//                 ApiBaseHelper.updateTopping + "/" + dataModel.id,
//                 jsonEncode(<String, String>{
//                   'name': name.toString().trim(),
//                   'price':  price.isEmpty?'0':price.toString().trim().replaceAll(',', '.')
//                 }),
//                 token,
//                 restaurantId);

//             CommonModel model = CommonModel.fromJson(
//                 _helper.returnResponse(_context, response));
//             Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//             if (model.success!) {
//               Navigator.pop(_context);
//             } else {
//               showMessage(model.message!, _context);
//             }
//           } catch (e) {
//             print(e.toString());
//             Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//           }
//         }
//       });
//     });
//   }
// }
