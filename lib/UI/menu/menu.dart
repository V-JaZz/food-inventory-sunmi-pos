// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/dashboard/forms/Items/dialogMenu.dart';
import 'package:food_inventory/UI/dashboard/forms/Items/model/menu_items.dart';
import 'package:food_inventory/UI/menu/dialog_delete_type.dart';
import 'package:food_inventory/UI/menu/dialog_type_list_view.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

import '../../constant/image.dart';
import '../Dashboard/forms/Allergy/add_new_allergy.dart';
import '../Dashboard/forms/AllergyGroup/add_allergy_group.dart';
import '../Dashboard/forms/Category/add_new_category.dart';
import '../Dashboard/forms/Option/add_option.dart';
import '../Dashboard/forms/Toppings/add_topping.dart';
import '../Dashboard/forms/Varient/add_new_varient.dart';
import '../Dashboard/forms/VarientGroup/add_varientGroup.dart';
import '../Dashboard/forms/toppingGroup/add_toppingGroup.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool isDataLoad = false;
  bool search = false;
  bool filter = false;
  List<Data> data = [];
  List<Items> itemList = [];
  final _controller = ScrollController();
  final _searchFieldController = TextEditingController();
  List<Items> initialList = [];

  @override
  void initState() {
    super.initState();

    initialList = itemList;
    getMenuItems();
    _searchFieldController.addListener(onChange);
  }

  var change = "";

  onChange() {
    setState(() {});
  }

  getMenuItems() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getItems + change, token);
        MenuItems model = MenuItems.fromJson(
            ApiBaseHelper().returnResponse(context, response));
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            setState(() {
              data = model.data!;
              print("DATA: " + data.length.toString());
              for (int i = 0; i < model.data!.length; i++) {
                itemList = model.data![i].items!;
              }
            });
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

  final ApiBaseHelper _helper = ApiBaseHelper();
  final GlobalKey<State> _keyLoader1 = GlobalKey<State>();

  updatePosition(currentPosition, targetPosition, currentItem, targetItem,
      oldIndex, newIndex, items) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      var body = jsonEncode({
        'items': items,
        'currentPosition': currentPosition.toString().trim(),
        'targetPosition': targetPosition.toString().trim(),
        'currentItem': currentItem.toString().trim(),
        'targetItem': targetItem.toString().trim(),
        'startIndex': oldIndex.toString().trim(),
        'endIndex': newIndex.toString().trim()
      });

      if (body.isNotEmpty) {
        Dialogs.showLoadingDialog(context, _keyLoader1);
        try {
          final response =
              await _helper.post(ApiBaseHelper.updateItemPosition, body, token);

          CommonModel model =
              CommonModel.fromJson(_helper.returnResponse(context, response));
          Navigator.of(_keyLoader1.currentContext!, rootNavigator: true).pop();
          if (model.success!) {
            showMessage("Item position updated successfully...", context);
            getMenuItems();
          }
        } catch (e) {
          print(e.toString());
          Navigator.of(_keyLoader1.currentContext!, rootNavigator: true).pop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    filterCars(_searchFieldController.text);

    return ScreenUtilInit(
      builder: (context) => Scaffold(
          floatingActionButton: Container(
            padding: const EdgeInsets.all(20),
              child: FloatingActionButton(
                  elevation: 0.0,
                  child: const Icon(
                    Icons.add,
                    color: colorTextWhite,
                    size: 32,
                  ),
                  backgroundColor: colorYellow,
                  onPressed: () {
                    addMoreDialog();
                  })),
          body: Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            decoration: const BoxDecoration(color: colorBackground),
            child: Column(
              children: [
                Table(
                    columnWidths: const {
                      0: FlexColumnWidth(7.1),
                      1: FlexColumnWidth(5.0),
                      2: FlexColumnWidth(5.0),
                    },
                    border: TableBorder.all(
                        color: colorYellow,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                          decoration: const BoxDecoration(
                              color: colorYellow,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          children: [
                            search
                                ? Card(
                                    margin: const EdgeInsets.all(3),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              search = !search;
                                              _searchFieldController.clear();
                                              filterCars(
                                                  _searchFieldController.text);
                                              print('object');
                                              getMenuItems();
                                            });
                                          },
                                          child: const Icon(Icons.arrow_back,
                                              size: 28, color: colorBlack),
                                        ),
                                        const SizedBox(
                                          width: 05,
                                        ),
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 03.5),
                                            height: 55,
                                            child: TextField(
                                              onChanged: (value) =>
                                                  setState(() {
                                                filterCars(
                                                    _searchFieldController
                                                        .text);
                                                getMenuItems();
                                              }),
                                              controller:
                                                  _searchFieldController,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: colorTextBlack),
                                              decoration: const InputDecoration(
                                                fillColor: Colors.white,
                                                border: InputBorder.none,
                                              ),
                                              cursorColor: colorTextBlack,
                                              keyboardType: TextInputType.text,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 13),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Item Name",
                                          style: TextStyle(
                                              color: colorTextWhite,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              search = !search;
                                              filterCars(
                                                  _searchFieldController.text);
                                              print('object one');
                                            });
                                          },
                                          child: const Icon(Icons.search,
                                              size: 18, color: colorTextWhite),
                                        )
                                      ],
                                    ),
                                  ),
                            filter
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 13),
                                    child: GestureDetector(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Categories",
                                            style: TextStyle(
                                                color: colorTextWhite,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          GestureDetector(
                                            child: const Icon(
                                              Icons.arrow_upward,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            onTap: () {},
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          filter = !filter;
                                          change = "?sortBy=ASC";
                                          getMenuItems();
                                          print('True');
                                        });
                                      },
                                    ))
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 13),
                                    child: GestureDetector(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Categories",
                                            style: TextStyle(
                                                color: colorTextWhite,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          GestureDetector(
                                            child: const Icon(
                                              Icons.arrow_downward,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            onTap: () {},
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          filter = !filter;
                                          change = "?sortBy=DESC";
                                          getMenuItems();
                                          print('True');
                                        });
                                      },
                                    )),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              alignment: Alignment.center,
                              child: const Text(
                                "Price",
                                style: TextStyle(
                                    color: colorTextWhite,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ]),
                    ]),
                Expanded(
                  child: isDataLoad
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5.0,
                            color: colorYellow,
                          ),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                              color: colorTextWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: colorYellow,
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 1.0,
                                ),
                              ]),
                          child: ListView.builder(
                              primary: false,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height: data[index].items!.length * 0.068.sh,
                                  child: ReorderableListView.builder(
                                      primary: false,
                                      itemCount: data[index].items!.length,
                                      scrollController: _controller,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, i) {
                                        return Container(
                                          key: ValueKey(
                                              data[index].items![i].name),
                                          color: i % 2 == 0
                                              ? const Color.fromRGBO(
                                                  228, 225, 246, 1)
                                              : colorTextWhite,
                                          child: Slidable(
                                            endActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                const Spacer(),
                                                // SizedBox(
                                                //   width: MediaQuery.of(context)
                                                //           .size
                                                //           .width *
                                                //       0.15,
                                                //   child:
                                                  SlidableAction(
                                                    onPressed: (context) {
                                                      dialogDeleteType(
                                                          TypeListDataModel(
                                                              TYPE_MENU_ITEM,
                                                              data[index]
                                                                  .items![i]
                                                                  .sId!,
                                                              0,
                                                              data[index]
                                                                  .items![i]
                                                                  .name!,
                                                              data[index]
                                                                  .items![i]
                                                                  .description!,
                                                              "",
                                                              "",
                                                              [],
                                                              "",
                                                              "",
                                                              "",
                                                              "",
                                                              0));
                                                    },
                                                    backgroundColor:
                                                        colorButtonYellow,
                                                    foregroundColor:
                                                        colorTextWhite,
                                                    icon: Icons.delete,
                                                  ),
                                                // ),
                                                // SizedBox(
                                                //   width: MediaQuery.of(context)
                                                //           .size
                                                //           .width *
                                                //       0.15,
                                                //   child:
                                                  SlidableAction(
                                                      backgroundColor:
                                                          colorTextBlack,
                                                      foregroundColor:
                                                          colorTextWhite,
                                                      icon: Icons.edit,
                                                      onPressed: (context) {
                                                        editMenuItem(data[index]
                                                            .items![i]);
                                                      }),
                                                // ),
                                              ],
                                            ),
                                            key: ValueKey(
                                                data[index].items![i].name),
                                            child: Table(
                                                key: ValueKey(
                                                    data[index].items![i].name),
                                                columnWidths: const {
                                                  0: FlexColumnWidth(7.1),
                                                  1: FlexColumnWidth(5.0),
                                                  2: FlexColumnWidth(5.0),
                                                },
                                                defaultVerticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                children: [
                                                  TableRow(children: [
                                                    Container(
                                                      color: i % 2 == 0
                                                          ? const Color
                                                                  .fromRGBO(
                                                              228, 225, 246, 1)
                                                          : colorTextWhite,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10,
                                                          vertical: 15),
                                                      child: Text(
                                                          data[index]
                                                              .items![i]
                                                              .name!,
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                              color:
                                                                  colorTextBlack,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ),
                                                    Container(
                                                      color: i % 2 == 0
                                                          ? const Color
                                                                  .fromRGBO(
                                                              228, 225, 246, 1)
                                                          : colorTextWhite,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10,
                                                          vertical: 15),
                                                      child: Text(
                                                          data[index]
                                                              .items![i]
                                                              .category!
                                                              .name!,
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                              color:
                                                                  colorTextBlack,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ),
                                                    Container(
                                                      color: i % 2 == 0
                                                          ? const Color
                                                                  .fromRGBO(
                                                              228, 225, 246, 1)
                                                          : colorTextWhite,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10,
                                                          vertical: 15),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          getOptionPrice(
                                                              data[index]
                                                                  .items![i]
                                                                  .options!,
                                                              data[index]
                                                                  .items![i]
                                                                  .price!),
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                              color:
                                                                  colorButtonYellow,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ),
                                                  ]),
                                                ]),
                                          ),
                                        );
                                      },
                                      onReorder: (int oldIndex, int newIndex) {
                                        setState(() {
                                          if (newIndex > oldIndex) {
                                            newIndex -= 1;
                                          }

                                          var newPosition = data[index]
                                              .items![newIndex]
                                              .position;
                                          var oldPosition = data[index]
                                              .items![oldIndex]
                                              .position;
                                          var currentItemId = data[index]
                                              .items!
                                              .elementAt(oldIndex)
                                              .sId;
                                          var targetItemId = data[index]
                                              .items!
                                              .elementAt(newIndex)
                                              .sId;
                                          print('New Dragged Index :' +
                                              newPosition.toString());
                                          print('Old Dragged Index :' +
                                              oldPosition.toString());
                                          print('Current Item Id :' +
                                              currentItemId.toString());
                                          print('Target Item Id :' +
                                              targetItemId.toString());
                                          print('New Index :' +
                                              newIndex.toString());
                                          print('Old Index :' +
                                              oldIndex.toString());
                                          updatePosition(
                                              oldPosition,
                                              newPosition,
                                              currentItemId,
                                              targetItemId,
                                              oldIndex,
                                              newIndex,
                                              data[index].items!);
                                          print("==========================else 1 ========================");
                                        });
                                      }),
                                );
                              }),
                        ),
                )
              ],
            ),
          )),
    );
  }

  void filterCars(String enteredKeyword) {
    List<Items> results = [];
    for (int i = 0; data.length > i; i++) {
      results = data[i].items!;
      if (enteredKeyword.isEmpty) {
        results = data[i].items!;
      } else {
        results = data[i]
            .items!
            .where((user) =>
                user.name!.toUpperCase().contains(enteredKeyword.toUpperCase()))
            .toList();
      }
      setState(() {
        data[i].items = results;
      });
    }
  }

  String getOptionName(List<Options> list) {
    String optionName = "";
    if (list.isEmpty) {
      optionName = "None";
    } else {
      for (Options data in list) {
        if (optionName.isEmpty) {
          optionName = data.name!;
        } else {
          optionName = "$optionName | ${data.name!}";
        }
      }
    }
    return optionName;
  }

  String getToppingGroupName(List<Options> list) {
    String toppingGroup = "";
    if (list.isEmpty) {
      toppingGroup = "None";
    } else {
      for (int i = 0; list.length > i; i++) {
        if (toppingGroup.isEmpty) {
          toppingGroup = list[i].name!;
          print("===============" + toppingGroup);
        } else {
          toppingGroup = "$toppingGroup | ${list[i]}";
        }
      }
    }
    return toppingGroup;
  }

  void dialogDeleteType(TypeListDataModel model) {
    showDialog(
      context: context,
      builder: (deleteDialogContext) {
        return DialogDeleteType(
          model: model,
          onDialogClose: () {
            setState(() {
              data = [];
            });
            getMenuItems();
          },
        );
      },
    );
  }

  String getOptionPrice(List<Options> list, String? defaultPrice) {
    String optionPrice = "";
    if (list.isEmpty) {
      optionPrice = getAmountWithCurrency(defaultPrice);
    } else {
      for (Options data in list) {
        if (optionPrice.isEmpty) {
          optionPrice = getAmountWithCurrency(data.price);
        } else {
          optionPrice = "$optionPrice | ${getAmountWithCurrency(data.price)}";
        }
      }
    }
    return optionPrice;
  }

  void editMenuItem(Items itemData) {
    // for (Items items in itemData)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (menuDialogContext) {
        return DialogMenuItems(
          isEdit: true,
          editItem: itemData,
          onAddDeleteSuccess: () {
            setState(() {
              itemList = [];
            });
            getMenuItems();
          },
          type: 'Menu',
          // isShowTable: widget.isShowTable,
        );
      },
    );
  }

  void doNothing(BuildContext context) {}

  void addMoreDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration:
                    const BoxDecoration(color: Color.fromRGBO(11, 4, 58, 0.7)),
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 100.0, bottom: 150.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  dialogAddNewitem("Add New Item");
                                });
                              },
                              child: Card(
                                color: colorButtonBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text(
                                    "Add New Item",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  dialogAddNewCategory(TYPE_CATEGORY);
                                });
                              },
                              child: Card(
                                color: colorButtonBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text(
                                    "Add New Category",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.of(context).pop();
                              dialogAddNewOption(TYPE_OPTION);
                            });
                          },
                          child: Card(
                            color: colorButtonBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            child: const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Text(
                                "Add Option",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: colorButtonBlue,
                          height: 20,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  dialogAddNewTopping(TYPE_TOPPINGS);
                                });
                              },
                              child: Card(
                                color: colorButtonBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text(
                                    "Add Toppings",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  dialogAddNewToppingGroup(TYPE_GROUP_TOPPINGS);
                                });
                              },
                              child: Card(
                                color: colorButtonBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text(
                                    "Add Toppings Group",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: colorButtonBlue,
                          height: 20,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  dialogAddNewAllergy(TYPE_ALLERGY);
                                });
                              },
                              child: Card(
                                color: colorButtonBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text(
                                    "Add Allergy",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  dialogAddNewAllergyGroup(TYPE_ALLERGY_GROUP);
                                });
                              },
                              child: Card(
                                color: colorButtonBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text(
                                    "Add Allergy Group",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: colorButtonBlue,
                          height: 20,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  dialogAddNewVarient(TYPE_VERIANT);
                                });
                              },
                              child: Card(
                                color: colorButtonBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text(
                                    "Add Varient",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  dialogAddNewVarientGroup(TYPE_VARIANT_GROUP);
                                });
                              },
                              child: Card(
                                color: colorButtonBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text(
                                    "Add Varient Group",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: colorButtonBlue,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.6),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    icOrderCross,
                    height: MediaQuery.of(context).size.height * 0.035,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void dialogAddNewitem(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return DialogMenuItems(
          onAddDeleteSuccess: () {
            setState(() {});
          },
          type: 'Menu',
          isEdit: false,
        );
      },
    );
  }

  void dialogAddNewCategory(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddNewCategory(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewAllergy(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddNewAllergy(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewOption(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddOption(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewTopping(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddToppings(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewToppingGroup(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddToppingGroups(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewAllergyGroup(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddAllergyGroups(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewVarient(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddNewVarient(
          onDialogClose: () {},
        );
      },
    );
  }

  void dialogAddNewVarientGroup(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AddVarientGroups(
          onDialogClose: () {},
        );
      },
    );
  }
}
