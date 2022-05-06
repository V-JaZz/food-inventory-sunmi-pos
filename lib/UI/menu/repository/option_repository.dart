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

// class OptionRepository {
//   ApiBaseHelper _helper = new ApiBaseHelper();
//   late BuildContext _context;
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();

//   OptionRepository(this._context);

//   addOption(List<AddTypeModel> categoryList, id, start, end) {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//       List<dynamic> dataJson = [];
//       var name;
//       var topping;
//       for (AddTypeModel data in categoryList) {
//         if (data.name.text.toString().trim().isEmpty) {
//           showMessage("Enter Option Name", _context);
//           return;
//         } else {
//           name = data.name.text.toString().trim();
//           topping = id.toString().trim();
//         }
//       }

//       // if (dataJson.isNotEmpty) {
//       Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//       try {
//         final response = await _helper.post(
//             ApiBaseHelper.addOptions,
//             id == null || id == "null"
//                 ? jsonEncode(<String, String>{
//                     'name': name,
//                     // 'toppingGroup': id.toString().trim(),
//                     'minToppings': end.toString(),
//                     'maxToppings': start.toString()
//                   })
//                 : jsonEncode(<String, String>{
//                     'name': name,
//                     'toppingGroup': id.toString().trim(),
//                     'minToppings': end.toString(),
//                     'maxToppings': start.toString()
//                   }),
//             token);

//         CommonModel model =
//             CommonModel.fromJson(_helper.returnResponse(_context, response));
//         Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//         if (model.success!) {
//           Navigator.pop(_context);
//         } else {
//           showMessage(model.message!, _context);
//         }
//       } catch (e) {
//         print(e.toString());
//         Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//         // }
//       }
//     });
//   }

//   editOption(TypeListDataModel dataModel, String name, id, start, end) async {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//       StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
//           .then((restaurantId) async {
//         if (checkString(name)) {
//           showMessage("Enter Option Name", _context);
//           // name = data.name.text.toString().trim();
//           // topping = _toppingGrpData!.id.toString().trim();
//         } else {
//           Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//           try {
//             final response = await _helper.put(
//                 ApiBaseHelper.updateoption + "/" + dataModel.id,
//                 id == null || id == "null"
//                     ? jsonEncode(<String, String>{
//                         'name': name,
//                         // 'toppingGroup': id.toString().trim(),
//                         'minToppings': end.toString(),
//                         'maxToppings': start.toString()
//                       })
//                     : jsonEncode(<String, String>{
//                         'name': name,
//                         'toppingGroup': id.toString().trim(),
//                         'minToppings': end.toString(),
//                         'maxToppings': start.toString()
//                       }),
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
