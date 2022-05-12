// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_inventory/UI/dashboard/forms/Items/model/menu_items.dart';
import 'package:food_inventory/UI/menu/dialog_delete_type.dart';
import 'package:food_inventory/UI/menu/dialog_type_list_view.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

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

  ApiBaseHelper _helper = ApiBaseHelper();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
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
        Dialogs.showLoadingDialog(context, _keyLoader);
        try {
          final response =
              await _helper.post(ApiBaseHelper.updateItemPosition, body, token);

          CommonModel model =
              CommonModel.fromJson(_helper.returnResponse(context, response));
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          if (model.success!) {
            showMessage("Item position updated successfully...", context);
            getMenuItems();
          }
        } catch (e) {
          print(e.toString());
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        }
      }
    });
  }

  Widget _singleToDoWidget(String title, int index) {
    return Text(
      title,
      key: ValueKey(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    filterCars(_searchFieldController.text);

    return Container(
      decoration: const BoxDecoration(color: colorBackground),
      child: Column(
        children: [
          Table(
              columnWidths: {
                0: const FlexColumnWidth(7.1),
                1: const FlexColumnWidth(5.0),
                2: const FlexColumnWidth(5.0),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        search = !search;
                                        _searchFieldController.clear();
                                        filterCars(_searchFieldController.text);
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
                                      padding: const EdgeInsets.only(bottom: 03.5),
                                      height: 55,
                                      child: TextField(
                                        onChanged: (value) => setState(() {
                                          filterCars(
                                              _searchFieldController.text);
                                          getMenuItems();
                                        }),
                                        controller: _searchFieldController,
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
                                        filterCars(_searchFieldController.text);
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
                                    onTap: () {
                                      setState(() {
                                        filter = !filter;
                                        change = "?sortBy=ASC";
                                        getMenuItems();
                                        print('True');
                                      });
                                    },
                                  )
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
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
                                    onTap: () {
                                      setState(() {
                                        filter = !filter;
                                        change = "?sortBy=DESC";
                                        getMenuItems();
                                        print('True');
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
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
                    decoration:
                        const BoxDecoration(color: colorTextWhite, boxShadow: [
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
                            height: data[index].items!.length *
                                MediaQuery.of(context).size.height *
                                0.0551,
                            child: ReorderableListView.builder(
                                primary: false,
                                itemCount: data[index].items!.length,
                                scrollController: _controller,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, i) {
                                  return Container(
                                    key: ValueKey(data[index].items![i].name),
                                    color: i % 2 == 0
                                        ? const Color.fromRGBO(228, 225, 246, 1)
                                        : colorTextWhite,
                                    child: Slidable(
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          const Spacer(),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: SlidableAction(
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
                                              foregroundColor: colorTextWhite,
                                              icon: Icons.delete,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: SlidableAction(
                                              onPressed: doNothing,
                                              backgroundColor: colorTextBlack,
                                              foregroundColor: colorTextWhite,
                                              icon: Icons.edit,
                                            ),
                                          ),
                                        ],
                                      ),
                                      key: ValueKey(data[index].items![i].name),
                                      child: Table(
                                          key: ValueKey(
                                              data[index].items![i].name),
                                          columnWidths: {
                                            0: const FlexColumnWidth(7.1),
                                            1: const FlexColumnWidth(5.0),
                                            2: const FlexColumnWidth(5.0),
                                          },
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          children: [
                                            TableRow(children: [
                                              Container(
                                                color: i % 2 == 0
                                                    ? const Color.fromRGBO(
                                                        228, 225, 246, 1)
                                                    : colorTextWhite,
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 15),
                                                child: Text(
                                                    data[index].items![i].name!,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              Container(
                                                color: i % 2 == 0
                                                    ? const Color.fromRGBO(
                                                        228, 225, 246, 1)
                                                    : colorTextWhite,
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 15),
                                                child: Text(
                                                    data[index]
                                                        .items![i]
                                                        .category!
                                                        .name!,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              Container(
                                                color: i % 2 == 0
                                                    ? const Color.fromRGBO(
                                                        228, 225, 246, 1)
                                                    : colorTextWhite,
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 15),
                                                alignment: Alignment.center,
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
                                                            FontWeight.w500)),
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

                                    var newPosition =
                                        data[index].items![newIndex].position;
                                    var oldPosition =
                                        data[index].items![oldIndex].position;
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
                                    print('New Index :' + newIndex.toString());
                                    print('Old Index :' + oldIndex.toString());
                                    updatePosition(
                                        oldPosition,
                                        newPosition,
                                        currentItemId,
                                        targetItemId,
                                        oldIndex,
                                        newIndex,
                                        data[index].items!);
                                    print(
                                        "==========================else 1 ========================");
                                  });
                                }),
                          );
                        }),
                  ),
          )
        ],
      ),
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

  void doNothing(BuildContext context) {}
}
