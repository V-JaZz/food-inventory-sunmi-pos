// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:foodinventory/constant/storage_util.dart';
// import 'package:foodinventory/constant/validation_util.dart';
// import 'package:foodinventory/model/common_model.dart';
// import 'package:foodinventory/networking/api_base_helper.dart';
// import 'package:foodinventory/ui/menu/model/add_type_model.dart';
// // import 'package:image_picker/image_picker.dart';

// import '../../../main.dart';
// import '../dialog_type_list_view.dart';

// class CategoryRepository {
//   ApiBaseHelper _helper = new ApiBaseHelper();
//   late BuildContext _context;
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();

//   CategoryRepository(this._context);

//   addCategory(List<AddTypeModel> categoryList, File imageFile) {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//       String name = '';
//       String description = '';
//       String discount = '';
//       String fileName = File(imageFile.path).path.split("/").last;
//       String fileType = File(imageFile.path).path.split(".").last;
//       for (AddTypeModel data in categoryList) {
//         if (data.name.text.toString().trim().isEmpty) {
//           showMessage("Enter Category Name", _context);
//           return;
//         } else {
//           name = data.name.text.toString().trim();
//           description = data.description.text.toString().trim();
//           discount = data.discount.text.toString().trim();
//           Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//           try {
//             final response = await _helper.postMultiPartCategory(
//                 ApiBaseHelper.addCategories,
//                 File(imageFile.path),
//                 fileName,
//                 fileType,
//                 name,
//                 description,
//                 discount.isEmpty ? '0' : discount,
//                 token);
//             // jsonEncode(<String, dynamic>{
//             //   "name": name,
//             //   "description": description,
//             //   "discount": discount
//             // }),
//             // token);

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
//       }
//     });
//   }

//   addCategorywithoutImage(List<AddTypeModel> categoryList) {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//       String name = '';
//       String description = '';
//       String discount = '';

//       for (AddTypeModel data in categoryList) {
//         if (data.name.text.toString().trim().isEmpty) {
//           showMessage("Enter Category Name", _context);
//           return;
//         } else {
//           name = data.name.text.toString().trim();
//           description = data.description.text.toString().trim();
//           discount = data.discount.text.toString().trim();
//           Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//           try {
//             final response = await _helper.postMultiPartCategorywithoutimage(
//                 ApiBaseHelper.addCategories,
//                 name,
//                 description,
//                 discount.isEmpty ? '0' : discount,
//                 token);
//             // jsonEncode(<String, dynamic>{
//             //   "name": name,
//             //   "description": description,
//             //   "discount": discount
//             // }),
//             // token);
//             print(response);
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
//       }
//     });
//   }

//   editCategory(TypeListDataModel dataModel, String name, String description,
//       String discount, File imageFile) async {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//       StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
//           .then((restaurantId) async {
//         print("name: " + name);
//         print("name: " + discount);
//         print("name: " + description);
//         print("name: " + imageFile.path);
//         String fileName = File(imageFile.path).path.split("/").last;
//         String fileType = File(imageFile.path).path.split(".").last;
//         if (checkString(name)) {
//           showMessage("Enter Category Name", _context);
//         } else {
//           Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//           try {
//             final response = await _helper.putMultiPartCategory(
//               ApiBaseHelper.updatecategory + "/" + dataModel.id,
//               File(imageFile.path),
//               fileName,
//               fileType,
//               name,
//               description,
//               discount.isEmpty ? '0' : discount,
//               token,
//             );

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

//   editCategorywithoutImage(TypeListDataModel dataModel, String name,
//       String description, String discount) async {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//       StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
//           .then((restaurantId) async {
//         print("name: " + name);
//         print("name: " + discount);
//         print("name: " + description);
//         if (checkString(name)) {
//           showMessage("Enter Category Name", _context);
//         } else {
//           Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//           try {
//             final response = await _helper.putMultiPartCategorywithoutImage(
//               ApiBaseHelper.updatecategory + "/" + dataModel.id,
//               name,
//               description,
//               discount.isEmpty ? '0' : discount,
//               token,
//             );

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
