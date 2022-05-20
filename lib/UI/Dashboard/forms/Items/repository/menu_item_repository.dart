import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:food_inventory/UI/dashboard/dialog_menu_data_selection.dart';
import 'package:food_inventory/UI/dashboard/forms/Items/dialogAddNewItem.dart';
import 'package:food_inventory/UI/dashboard/forms/Items/dialogMenu.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

class MenuItemRepository {
  ApiBaseHelper _helper = new ApiBaseHelper();
  late BuildContext _context;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  late Function widgett;

/*  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  String? restaurantId;
  restaurantId=(prefs.getString('restaurant')?? 0.0) as String?;
  print("restaurantIddev");
  print(restaurantId);*/
  MenuItemRepository(this._context, this.widgett);

  addMenuItem(
      TextEditingController itemName,
      TextEditingController descriptionName,
      TextEditingController discount,
      SelectionMenuDataList? _categoryData,
      List<SelectVariantData>? _variantDataList,
      List<SelectOptionData>? _optionDataList,
      SelectionMenuDataList? _allergyGroupData,
      File imageFile,
      String menuType) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      String fileName = File(imageFile.path).path.split("/").last;
      String fileType = File(imageFile.path).path.split(".").last;
      if (itemName.text.toString().trim().isEmpty) {
        showMessage("Enter Item Name", _context);
      } else if (_categoryData == null) {
        showMessage("Select Category", _context);
      } else if (_allergyGroupData == null) {
        showMessage("Select Allergy Group", _context);
      } else {
        // bool isValidOption = true;
        // for (SelectOptionData data in _optionDataList) {
        //   if (data.selectData == null) {
        //     isValidOption = false;
        //     showMessage("Select Option", _context);
        //     break;
        //   } else if (data.priceController.text.toString().trim().isEmpty) {
        //     isValidOption = false;
        //     showMessage("Enter Option Price", _context);
        //     break;
        //   }
        // }
        // if (isValidOption) {
        //TODO : Call Api
        var optionJsonList = [];
        var veriantJsonList = [];
        var optionJson = "";
        var variantJson = "";
        String price = "";
        for (SelectOptionData data in _optionDataList!) {
          if (data.selectData!.id.isEmpty) {
            price = data.priceController.text.toString().trim();
            print("With image" + price);
          } else {
            // optionJsonList.add({
            //   'toppingGroup': data.selectData!.selectedToppingId,
            //   'minToppings': data.selectData!.minTopping,
            //   'maxToppings': data.selectData!.maxTopping,
            //   '_id': data.selectData!.id,
            //   'name': data.selectData!.name,
            //   'price': data.priceController.text
            //       .toString()
            //       .trim()
            //       .replaceAll(',', '.')
            // }.toString());
            optionJson = jsonEncode({
              'toppingGroup': data.selectData!.selectedToppingId.toString(),
              'minToppings': data.selectData!.minTopping.toString(),
              'maxToppings': data.selectData!.maxTopping.toString(),
              '_id': data.selectData!.id.toString(),
              'name': data.selectData!.name.toString(),
              'price': data.priceController.text.isEmpty
                  ? '0'
                  : data.priceController.text
                      .toString()
                      .trim()
                      .replaceAll(',', '.')
            });
            optionJsonList.add(optionJson);
          }
        }
        for (SelectVariantData data in _variantDataList!) {
          if (data.selectData!.id.isEmpty) {
            // price = data.priceController.text.toString().trim();
          } else {
            // veriantJsonList.add({
            //   '_id': data.selectData!.id,
            //   'variantGroup': data.selectData!.selectedToppingId,
            //   'name': data.selectData!.name,
            //   'price': data.priceController.text
            //       .toString()
            //       .trim()
            //       .replaceAll(',', '.')
            // }.toString());
            variantJson = jsonEncode({
              '_id': data.selectData!.id,
              'variantGroup': data.selectData!.selectedToppingId,
              'name': data.selectData!.name,
              'price': data.priceController.text.isEmpty
                  ? '0'
                  : data.priceController.text
                      .toString()
                      .trim()
                      .replaceAll(',', '.')
            });
            veriantJsonList.add(variantJson.toString());
          }
        }

        // var body = jsonEncode({
        //   'name': itemName.text.toString().trim(),
        //   'category': _categoryData.id,
        //   'description': descriptionName.text.t
        // oString().trim(),
        //   'discount': discount.text.toString().trim(),
        //   'price': price.isEmpty ? '0' : price.replaceAll(',', '.'),
        //   'variants': veriantJson,
        //   'options': optionJson,
        //   'allergyGroup':
        //       _allergyGroupData == null ? null : _allergyGroupData.id,
        // });
        var alergy = _allergyGroupData == null ? null : _allergyGroupData.id;
      
        Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
        try {
          // final response =
          //     await _helper.post(ApiBaseHelper.additems, body, token);

          final response = await _helper.postMultiPartItems(
              ApiBaseHelper.additems,
              File(imageFile.path),
              fileName,
              fileType,
              itemName.text.toString().trim(),
              _categoryData.id,
              descriptionName.text.toString().trim(),
              discount.text.isEmpty ? '0' : discount.text,
              price.isEmpty ? '0' : price.replaceAll(',', '.'),
              veriantJsonList,
              optionJsonList,
              alergy,
              token,
              menuType);

          CommonModel model =
              CommonModel.fromJson(_helper.returnResponse(_context, response));

          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          if (model.success!) {
            Navigator.pop(_context);
            widgett();
          } else {
            showMessage(model.message!, _context);
          }
        } catch (e) {
          print(e.toString());
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        }
        // }
      }
    });
  }

  addMenuItemwithoutimage(
      TextEditingController itemName,
      TextEditingController descriptionName,
      TextEditingController discount,
      SelectionMenuDataList? _categoryData,
      List<SelectVariantData>? _variantDataList,
      List<SelectOptionData>? _optionDataList,
      SelectionMenuDataList? _allergyGroupData,
      String menuType) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      // String fileName = File(imageFile.path).path.split("/").last;
      // String fileType = File(imageFile.path).path.split(".").last;
      if (itemName.text.toString().trim().isEmpty) {
        showMessage("Enter Item Name", _context);
      } else if (_categoryData == null) {
        showMessage("Select Category", _context);
      } else if (_allergyGroupData == null) {
        showMessage("Select Allergy Group", _context);
      } else {
        // bool isValidOption = true;
        // for (SelectOptionData data in _optionDataList) {
        //   if (data.selectData == null) {
        //     isValidOption = false;
        //     showMessage("Select Option", _context);
        //     break;
        //   } else if (data.priceController.text.toString().trim().isEmpty) {
        //     isValidOption = false;
        //     showMessage("Enter Option Price", _context);
        //     break;
        //   }
        // }
        // if (isValidOption) {
        //TODO : Call Api
        var optionJsonList = [];
        var veriantJsonList = [];
        var optionJson = "";
        var variantJson = "";
        String price = "";
        for (SelectOptionData data in _optionDataList!) {
          if (data.selectData!.id.isEmpty) {
            price = data.priceController.text.toString().trim();
            print("Without image" + price);
          } else {
            optionJson = jsonEncode({
              'toppingGroup': data.selectData!.selectedToppingId.toString(),
              'minToppings': data.selectData!.minTopping.toString(),
              'maxToppings': data.selectData!.maxTopping.toString(),
              '_id': data.selectData!.id.toString(),
              'name': data.selectData!.name.toString(),
              'price': data.priceController.text.isEmpty
                  ? '0'
                  : data.priceController.text
                      .toString()
                      .trim()
                      .replaceAll(',', '.')
            });
            optionJsonList.add(optionJson);
          }
        }
        for (SelectVariantData data in _variantDataList!) {
          if (data.selectData!.id.isEmpty) {
            // price = data.priceController.text.toString().trim();
          } else {
            variantJson = jsonEncode({
              '_id': data.selectData!.id,
              'variantGroup': data.selectData!.selectedToppingId,
              'name': data.selectData!.name,
              'price': data.priceController.text.isEmpty
                  ? "0"
                  : data.priceController.text
                      .toString()
                      .trim()
                      .replaceAll(',', '.')
            });
            veriantJsonList.add(variantJson.toString());
          }
        }
        var alergy = _allergyGroupData == null ? null : _allergyGroupData.id;
        // var body = jsonEncode({
        //   'name': itemName.text.toString().trim(),
        //   'category': _categoryData.id,
        //   'description': descriptionName.text.toString().trim(),
        //   'discount': discount.text.toString().trim(),
        //   'price': price.isEmpty ? '0' : price.replaceAll(',', '.'),
        //   'variants': veriantJson,
        //   'options': optionJson,
        //   'allergyGroup':
        //       _allergyGroupData == null ? null : _allergyGroupData.id,
        // });

        Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
        try {
          // final response =
          //     await _helper.post(ApiBaseHelper.additems, body, token);
          final response = await _helper.postMultiPartItemswithoutImage(
              ApiBaseHelper.additems,
              // File(imageFile.path),
              menuType,
              // fileName,
              // fileType,
              itemName.text.toString().trim(),
              _categoryData.id,
              descriptionName.text.toString().trim(),
              discount.text.isEmpty ? '0' : discount.text,
              price.isEmpty ? '0' : price.replaceAll(',', '.'),
              veriantJsonList,
              optionJsonList,
              alergy,
              token);
          CommonModel model =
              CommonModel.fromJson(_helper.returnResponse(_context, response));
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          if (model.success!) {
            Navigator.pop(_context);
            widgett();
          } else {
            showMessage(model.message!, _context);
          }
        } catch (e) {
          print(e.toString());
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        }
      }
      // }
    });
  }

  editMenuItem(
      String editItemId,
      TextEditingController itemName,
      TextEditingController descriptionName,
      SelectionMenuDataList? _categoryData,
      List<SelectVariantData>? _variantDataList,
      List<SelectOptionData>? _optionDataList,
      SelectionMenuDataList? _allergyGroupData,
      TextEditingController discount,
      String menuType) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        print("Menu TYpe:" + menuType);
        if (itemName.text.toString().trim().isEmpty) {
          showMessage("Enter Item Name", _context);
        } else if (_categoryData == null) {
          showMessage("Select Category", _context);
        } else if (_allergyGroupData == null) {
          showMessage("Select Allergy Group", _context);
        } else {
          // bool isValidOption = true;
          // for (SelectOptionData data in _optionDataList) {
          //   if (data.selectData == null) {
          //     isValidOption = false;
          //     showMessage("Select Option", _context);
          //     break;
          //   } else if (data.priceController.text.toString().trim().isEmpty) {
          //     isValidOption = false;
          //     showMessage("Enter Option Price", _context);
          //     break;
          //   }
          // }
          // if (isValidOption) {
          //TODO : Call Api
          var optionJsonList = [];
          var veriantJsonList = [];
          var optionJson = "";
          var variantJson = "";
          String price = "";
          for (SelectOptionData data in _optionDataList!) {
            if (data.selectData!.id.isEmpty) {
              price = data.priceController.text.toString().trim();
            } else {
              optionJson = jsonEncode({
                'toppingGroup': data.selectData!.selectedToppingId.toString(),
                'minToppings': data.selectData!.minTopping.toString(),
                'maxToppings': data.selectData!.maxTopping.toString(),
                '_id': data.selectData!.id.toString(),
                'name': data.selectData!.name.toString(),
                'price': data.priceController.text.isEmpty
                    ? "0"
                    : data.priceController.text
                        .toString()
                        .trim()
                        .replaceAll(',', '.')
              });
              optionJsonList.add(optionJson);
            }
          }
          for (SelectVariantData data in _variantDataList!) {
            if (data.selectData!.id.isEmpty) {
              // price = data.priceController.text.toString().trim();
            } else {
              variantJson = jsonEncode({
                '_id': data.selectData!.id,
                'variantGroup': data.selectData!.selectedToppingId,
                'name': data.selectData!.name,
                'price': data.priceController.text.isEmpty
                    ? '0'
                    : data.priceController.text
                        .toString()
                        .trim()
                        .replaceAll(',', '.')
              });
              veriantJsonList.add(variantJson.toString());
            }
          }
          // var body = jsonEncode({
          //   'name': itemName.text.toString().trim(),
          //   'category': _categoryData.id,
          //   'description': descriptionName.text.toString().trim(),
          //   'price': price.isEmpty ? '0' : price,
          //   'variants': "veriantJson",
          //   'allergyGroup':
          //       _allergyGroupData == null ? null : _allergyGroupData.id,
          //   'options': optionJson,
          //   'discount': discount.text.toString().trim(),
          // });
          var alergy = _allergyGroupData == null ? null : _allergyGroupData.id;
          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.putMultiPartItemwithoutImage(
                ApiBaseHelper.updateitem + "/" + editItemId,
                itemName.text.toString().trim(),
                _categoryData.id,
                descriptionName.text.toString().trim(),
                discount.text.isEmpty ? '0' : discount.text,
                price.isEmpty ? '0' : price.replaceAll(',', '.'),
                veriantJsonList,
                optionJsonList,
                alergy!,
                token,
                restaurantId,
                menuType);

            CommonModel model = CommonModel.fromJson(
                _helper.returnResponse(_context, response));
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            if (model.success!) {
              Navigator.pop(_context);
              widgett();
            } else {
              showMessage(model.message!, _context);
            }
          } catch (e) {
            print(e.toString());
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          }
        }
        // }
      });
    });
  }

  editMenuItemwithImage(
      String editItemId,
      TextEditingController itemName,
      TextEditingController descriptionName,
      SelectionMenuDataList? _categoryData,
      List<SelectVariantData>? _variantDataList,
      List<SelectOptionData>? _optionDataList,
      SelectionMenuDataList? _allergyGroupData,
      TextEditingController discount,
      File imageFile,
      String menuType) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        String fileName = File(imageFile.path).path.split("/").last;
        String fileType = File(imageFile.path).path.split(".").last;
        if (itemName.text.toString().trim().isEmpty) {
          showMessage("Enter Item Name", _context);
        } else if (_categoryData == null) {
          showMessage("Select Category", _context);
        } else if (_allergyGroupData == null) {
          showMessage("Select Allergy Group", _context);
        } else {
          // bool isValidOption = true;
          // for (SelectOptionData data in _optionDataList) {
          //   if (data.selectData == null) {
          //     isValidOption = false;
          //     showMessage("Select Option", _context);
          //     break;
          //   } else if (data.priceController.text.toString().trim().isEmpty) {
          //     isValidOption = false;
          //     showMessage("Enter Option Price", _context);
          //     break;
          //   }
          // }
          // if (isValidOption) {
          //TODO : Call Api
          var optionJsonList = [];
          var veriantJsonList = [];
          var optionJson = "";
          var variantJson = "";
          String price = "";
          for (SelectOptionData data in _optionDataList!) {
            if (data.selectData!.id.isEmpty) {
              price = data.priceController.text.toString().trim();
            } else {
              optionJson = jsonEncode({
                'toppingGroup': data.selectData!.selectedToppingId.toString(),
                'minToppings': data.selectData!.minTopping.toString(),
                'maxToppings': data.selectData!.maxTopping.toString(),
                '_id': data.selectData!.id.toString(),
                'name': data.selectData!.name.toString(),
                'price': data.priceController.text.isEmpty
                    ? '0'
                    : data.priceController.text
                        .toString()
                        .trim()
                        .replaceAll(',', '.')
              });
              optionJsonList.add(optionJson);
            }
          }
          for (SelectVariantData data in _variantDataList!) {
            if (data.selectData!.id.isEmpty) {
              // price = data.priceController.text.toString().trim();
            } else {
              variantJson = jsonEncode({
                '_id': data.selectData!.id,
                'variantGroup': data.selectData!.selectedToppingId,
                'name': data.selectData!.name,
                'price': data.priceController.text.isEmpty
                    ? '0'
                    : data.priceController.text
                        .toString()
                        .trim()
                        .replaceAll(',', '.')
              });
              veriantJsonList.add(variantJson.toString());
            }
          }
          // var body = jsonEncode({
          //   'name': itemName.text.toString().trim(),
          //   'category': _categoryData.id,
          //   'description': descriptionName.text.toString().trim(),
          //   'price': price.isEmpty ? '0' : price,
          //   'variants': "veriantJson",
          //   'allergyGroup':
          //       _allergyGroupData == null ? null : _allergyGroupData.id,
          //   'options': optionJson,
          //   'discount': discount.text.toString().trim(),
          // });
          var alergy = _allergyGroupData == null ? null : _allergyGroupData.id;
          Dialogs.showLoadingDialog(_context, _keyLoader); //invoking login
          try {
            final response = await _helper.putMultiPartItem(
                ApiBaseHelper.updateitem + "/" + editItemId,
                File(imageFile.path),
                fileName,
                fileType,
                itemName.text.toString().trim(),
                _categoryData.id,
                descriptionName.text.toString().trim(),
                discount.text.isEmpty ? '0' : discount.text,
                price.isEmpty ? '0' : price.replaceAll(',', '.'),
                veriantJsonList,
                optionJsonList,
                alergy!,
                token,
                restaurantId,
                menuType);

            CommonModel model = CommonModel.fromJson(
                _helper.returnResponse(_context, response));
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            if (model.success!) {
              Navigator.pop(_context);
              widgett();
            } else {
              showMessage(model.message!, _context);
            }
          } catch (e) {
            print(e.toString());
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          }
        }
        // }
      });
    });
  }
}
