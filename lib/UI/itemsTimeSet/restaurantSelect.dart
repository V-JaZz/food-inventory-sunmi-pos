import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_inventory/constant/switch.dart' as SW;
import 'package:food_inventory/UI/Dashboard/forms/Items/model/menu_items.dart';
import 'package:food_inventory/UI/dashboard/forms/Category/model/category_list_response_model.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

typedef SelectDataFunc = void Function(List<SelectionModel>);

// ignore: must_be_immutable
class DialogRestaurantDataSelection extends StatefulWidget {
  late String type;
  late String typefor;
  List<TypeList>? selectedData;
  SelectDataFunc onSelectData;

  DialogRestaurantDataSelection({
    required this.type,
    required this.typefor,
    this.selectedData,
    required this.onSelectData,
  });

  @override
  _DialogRestaurantDataSelectionState createState() =>
      _DialogRestaurantDataSelectionState();
}

class _DialogRestaurantDataSelectionState
    extends State<DialogRestaurantDataSelection> {
  bool isDataLoad = false;
  List<SelectionMenu> dataList = [];
  List<TypeList> type = [];
  List<String> modelId = [];
  @override
  void initState() {
    super.initState();
    dataList = [];
    if (widget.type == TYPE_MENU_ITEM) {
      getMenuItems();
    } else {
      getCategories();
    }
  }

  getMenuItems() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getItems, token);
        MenuItems model = MenuItems.fromJson(
            ApiBaseHelper().returnResponse(context, response));
        print(ApiBaseHelper.getItems);
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            for (Data data in model.data!) {
              for (Items subData in data.items!) {
                bool isSelected = false;
                if (widget.typefor == "ReEdit") {
                  print("object");
                  for (TypeList ty in widget.selectedData!) {
                    for (String selectedId in ty.selected) {
                      if (subData.sId == selectedId) {
                        isSelected = true;
                        print("IS SELECTED: " + isSelected.toString());
                        break;
                      }
                    }
                  }
                }
                print("object 1");
                type.add(TypeList("", subData.sId.toString(), subData.name!,
                    subData.category!.sId!, [], isSelected));
              }
            }
          }
        }
      } catch (e) {
        print(e.toString());
        setState(() {
          isDataLoad = false;
        });
      }
    });
  }

  getCategories() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getCategories, token);
        CategoryListResponseModel model = CategoryListResponseModel.fromJson(
            ApiBaseHelper().returnResponse(context, response));
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            for (CategoryListData data in model.data!) {
              bool isSelected = false;
              if (widget.typefor == "ReEdit") {
                for (TypeList ty in widget.selectedData!) {
                  for (String selectedId in ty.selected) {
                    if (data.sId == selectedId) {
                      isSelected = true;
                      break;
                    }
                  }
                }
              }
              type.add(TypeList("", data.sId.toString(), data.name!, data.sId!,
                  [], isSelected));
            }
          }
        }
      } catch (e) {
        print(e.toString());
        setState(() {
          isDataLoad = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(11, 4, 58, 0.7)),
      child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          insetPadding: const EdgeInsets.all(15.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: colorTextWhite, borderRadius: BorderRadius.circular(13)),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  widget.type,
                  style: TextStyle(
                      color: colorTextBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                isDataLoad
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                          color: colorGreen,
                        ),
                      )
                    : ListView.builder(
                        itemCount: type.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (listContext, index) {
                          return Container(
                            color: index % 2 == 0
                                ? const Color.fromRGBO(228, 225, 246, 1)
                                : colorTextWhite,
                            padding: EdgeInsets.only(
                              left: 5,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  type[index].name,
                                  style: TextStyle(
                                      color: colorTextBlack,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    child: SW.Switch(
                                        value: type[index].isSelected,
                                        onChanged: (value) {
                                          setState(() {
                                            type[index].isSelected = value;
                                          });
                                        },
                                        // activeColor: colorGreen,
                                        inactiveTrackColor: colorButtonYellow,
                                        activeTrackColor: colorGreen,
                                        thumbColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white))),
                              ],
                            ),
                          );
                        },
                      ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 30, right: 10),
                            decoration: BoxDecoration(
                                color: colorGreen,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            List<SelectionModel> toppings = [];
                            for (TypeList toppingData in type) {
                              if (toppingData.isSelected) {
                                toppings.add(SelectionModel(toppingData.id,
                                    toppingData.name, toppingData.catId));
                              }
                            }
                            for (int i = 0; toppings.length > i; i++) {
                              print("DATA SELECTED: " + toppings[i].name);
                            }
                            widget.onSelectData(toppings);

                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 8, right: 30),
                            decoration: BoxDecoration(
                                color: colorGrey,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Back",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          behavior: HitTestBehavior.opaque,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class SelectionMenu {
  late String id, name, price, selectedToppingName, selectedToppingId;
  late bool isSelected;
  late double minTopping, maxTopping;
  late String nameL, idl;
  SelectionMenu(
      this.id,
      this.name,
      this.price,
      this.minTopping,
      this.maxTopping,
      this.selectedToppingName,
      this.selectedToppingId,
      this.isSelected,
      this.nameL,
      this.idl);
}

class TypeList {
  late String type, id, name, catId;
  late List<String> selected;
  late bool isSelected;

  TypeList(
    this.type,
    this.id,
    this.name,
    this.catId,
    this.selected,
    this.isSelected,
  );
}

class SelectionModel {
  late String id, name, catId;

  SelectionModel(this.id, this.name, this.catId);
}
