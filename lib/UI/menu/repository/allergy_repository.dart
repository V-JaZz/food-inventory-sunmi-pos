// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:foodinventory/constant/storage_util.dart';
// import 'package:foodinventory/constant/validation_util.dart';
// import 'package:foodinventory/model/common_model.dart';
// import 'package:foodinventory/networking/api_base_helper.dart';
// import '../../../main.dart';
// import '../dialog_type_list_view.dart';

// class AllergyRepository {
//   ApiBaseHelper _helper = ApiBaseHelper();
//   late BuildContext _context;
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();

//   AllergyRepository(this._context);

//   addAllergyData(String name, String description) async {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//         if (name.toString().trim().isEmpty) {
//           showMessage("Enter Allergy Name", _context);
//           return;
//         }
//         //  else if (description.toString().trim().isEmpty) {
//         //   showMessage("Enter Allergy Description", _context);
//         //   return;
//         // } 
//          {
//           var body = jsonEncode({
//             'name': name.toString().trim(),
//             'description': description.toString().trim()
//           });

//           if (body.isNotEmpty) {
//             Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//             try {
//               final response = await _helper.post(ApiBaseHelper.addAllergies,
//                   body, token);

//               CommonModel model =
//               CommonModel.fromJson(_helper.returnResponse(_context, response));
//               Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//               if (model.success!) {
//                 Navigator.pop(_context);
//               } else {
//                 showMessage(model.message!, _context);
//               }
//             } catch (e) {
//               print(e.toString());
//               Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//             }
//           }
//         }

//     });
//   }

//   editAllergy(TypeListDataModel dataModel, String name, String description) async {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//       StorageUtil.getData(StorageUtil.keyRestaurantId, "")!.then((restaurantId) async {
//         if (checkString(name)) {
//           showMessage("Enter Allergy Name", _context);
//         } 
//         // else if (checkString(price)) {
//         //   showMessage("Enter Allergy Description", _context);
//         // } 
//         else {
//           Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//           try {
//             final response = await _helper.post(
//                 ApiBaseHelper.updateAllergies + "/" + dataModel.id,
//                 jsonEncode(<String, String>{
//                   'name': name.toString().trim(),
//                   'description': description.toString().trim()
//                 }),
//                 token);

//             CommonModel model =
//             CommonModel.fromJson(_helper.returnResponse(_context, response));
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
