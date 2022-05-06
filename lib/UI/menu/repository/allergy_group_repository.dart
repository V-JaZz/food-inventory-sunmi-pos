// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:foodinventory/constant/storage_util.dart';
// import 'package:foodinventory/constant/validation_util.dart';
// import 'package:foodinventory/model/common_model.dart';
// import 'package:foodinventory/networking/api_base_helper.dart';
// import 'package:foodinventory/ui/menu/dialog_type_list_view.dart';
// import 'package:foodinventory/ui/menu/model/add_type_model.dart';

// import '../../../main.dart';
// import '../dialog_allergy_group_selection.dart';

// class AllergyGroupsRepository {
//   ApiBaseHelper _helper = new ApiBaseHelper();
//   late BuildContext _context;
//   late DialogAllergySelection widget;
//   final GlobalKey<State> _keyLoader = new GlobalKey<State>();

//   AllergyGroupsRepository(this._context, this.widget);
//   addAllergyGroup(
//       AddTypeModel groupData, List<SelectionAllergyListData> selectionList) {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//       StorageUtil.getData(StorageUtil.keyRestaurantId, "")!.then((restaurantId) async {
//         var body;
//         List<String> toppings = [];
//         for (SelectionAllergyListData toppingData in selectionList) {
//           if (toppingData.isSelected) {
//             toppings.add(toppingData.id);
//           }
//         }

//         if (groupData.name.text.toString().trim().isEmpty) {
//           showMessage("Enter Allergy Group Name", _context);
//           return;
//         } else if (toppings.isEmpty) {
//           showMessage("Select at least one Allergy", _context);
//         } else {
//           body = jsonEncode({
//             'name': groupData.name.text.toString().trim(),
//             'allergies': toppings
//           });

//           Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//           try {
//             final response =
//             await _helper.postwithid(ApiBaseHelper.addAllergiesGroup, body, token,restaurantId);
//             CommonModel model =
//             CommonModel.fromJson(_helper.returnResponse(_context, response));
//             Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
//             if (model.success!) {
//               Navigator.pop(_context);
//               widget.onDialogClose();
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

//   editAllergyGroup(TypeListDataModel editData,
//       List<SelectionAllergyListData> selectionList) {
//     StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
//       StorageUtil.getData(StorageUtil.keyRestaurantId, "")!.then((restaurantId) async {
//         var body;
//         List<String> toppings = [];
//         for (SelectionAllergyListData toppingData in selectionList) {
//           if (toppingData.isSelected) {
//             toppings.add(toppingData.id);
//           }
//         }

//         if (editData.name.isEmpty) {
//           showMessage("Enter Allergy Group Name", _context);
//           return;
//         } else if (toppings.isEmpty) {
//           showMessage("Select at least one Allergy", _context);
//         } else {
//           body = jsonEncode({
//             'name': editData.name.toString().trim(),
//             'allergies': toppings
//           });

//           Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
//           try {
//             final response = await _helper.post(
//                 ApiBaseHelper.updateAllergiesGroup + "/" + editData.id,
//                 body,
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
