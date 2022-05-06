// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:foodinventory/constant/storage_util.dart';
// import 'package:foodinventory/constant/validation_util.dart';
// import 'package:foodinventory/model/common_model.dart';
// import 'package:foodinventory/networking/api_base_helper.dart';
// import 'package:foodinventory/ui/menu/model/add_type_model.dart';

// import '../../../main.dart';
// import '../dialog_menu_data_selection.dart';
// import '../dialog_type_list_view.dart';

// class VariantRepository {
//   ApiBaseHelper _helper = new ApiBaseHelper();
//   late BuildContext _context;
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();

//   VariantRepository(this._context);

//   addVarient(List<AddTypeModel> Varient, id) {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//       List<dynamic> dataJson = [];
//       for (AddTypeModel data in Varient) {
//         if (data.name.text.toString().trim().isEmpty) {
//           showMessage("Enter Varient Name", _context);
//           return;
//         } else {
//           id == null
//               ? dataJson.add({
//                   'name': data.name.text.toString().trim(),
//                   'price': "0",
//                 })
//               : dataJson.add({
//                   'name': data.name.text.toString().trim(),
//                   'price': "0",
//                   'variantGroup': id.toString().trim(),
//                 });
//         }
//       }
//       if (dataJson.isNotEmpty) {
//         Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//         try {
//           final response = await _helper.post(ApiBaseHelper.addVariants,
//               jsonEncode(<String, dynamic>{'variantDetails': dataJson}), token);

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
//           // }
//         }
//       }
//     });
//   }

//   editVarient(
//     name,
//     id,
//     TypeListDataModel dataModel,
//   ) async {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//       StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
//           .then((restaurantId) async {
//         List<dynamic> dataJson = [];
//         Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//         try {
//           final response = await _helper.put(
//               ApiBaseHelper.updateVariant + "/" + dataModel.id,
//               id == null
//                   ? jsonEncode(<dynamic, dynamic>{
//                       'name': name.toString().trim(),
//                       'price': "0",
//                     })
//                   : jsonEncode(<dynamic, dynamic>{
//                       'name': name.toString().trim(),
//                       'price': "0",
//                       'variantGroup': id,
//                     }),
//               token,
//               restaurantId);

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
//         // }
//       });
//     });
//   }
// }
