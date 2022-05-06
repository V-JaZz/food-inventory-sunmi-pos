import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_inventory/UI/menu/dialog_delete_type.dart';
import 'package:food_inventory/UI/menu/dialog_type_list_view.dart';
import 'package:food_inventory/UI/menu/model/menu_items.dart';
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
    // TODO: implement initState
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
        Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
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
      decoration: BoxDecoration(color: colorBackground),
      // padding: EdgeInsets.only(left: 40, right: 35, top: 20, bottom: 22),
      child: Column(
        children: [
          Table(
              columnWidths: {
                0: FlexColumnWidth(7.1),
                1: FlexColumnWidth(5.0),
                2: FlexColumnWidth(5.0),
                // 3: FlexColumnWidth(1.7),
                // 3: FlexColumnWidth(1.5),
                // 4: FlexColumnWidth(1.5),
              },
              border: TableBorder.all(
                  color: colorYellow,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                    decoration: BoxDecoration(
                        color: colorYellow,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    children: [
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 10, vertical: 13),
                      //   alignment: Alignment.center,
                      //   decoration: BoxDecoration(color: colorGreen),
                      //   child: Text(
                      //     "S. No",
                      //     style: TextStyle(
                      //         color: colorTextWhite,
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w500),
                      //   ),
                      // ),
                      search
                          ? Card(
                              margin: EdgeInsets.all(3),
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
                                    child: Icon(Icons.arrow_back,
                                        size: 28, color: colorBlack),
                                  ),
                                  SizedBox(
                                    width: 05,
                                  ),
                                  Flexible(
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 03.5),
                                      height: 55,
                                      child: TextField(
                                        onEditingComplete: () {
                                          setState(() {
                                            filterCars(
                                                _searchFieldController.text);
                                          });
                                        },
                                        onSubmitted: (value) => setState(() {
                                          filterCars(
                                              _searchFieldController.text);
                                        }),
                                        onChanged: (value) => setState(() {
                                          filterCars(
                                              _searchFieldController.text);
                                        }),
                                        controller: _searchFieldController,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: colorTextBlack),
                                        decoration: InputDecoration(
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 13),
                              // decoration: BoxDecoration(
                              //     // color: colorYellow,
                              //     borderRadius:
                              //         BorderRadius.circular(30)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
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
                                    child: Icon(Icons.search,
                                        size: 18, color: colorTextWhite),
                                  )
                                ],
                              ),
                            ),
                      filter
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              // decoration:
                              //     BoxDecoration(color: colorYellow),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Categories",
                                    style: TextStyle(
                                        color: colorTextWhite,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  GestureDetector(
                                    child: Icon(
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              // decoration:
                              //     BoxDecoration(color: colorYellow),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Categories",
                                    style: TextStyle(
                                        color: colorTextWhite,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  GestureDetector(
                                    child: Icon(
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
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 10, vertical: 13),
                      //   // decoration: BoxDecoration(color: colorYellow),
                      //   child: Text(
                      //     "Options",
                      //     style: TextStyle(
                      //         color: colorTextWhite,
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w500),
                      //   ),
                      // ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 10, vertical: 13),
                      //   // decoration: BoxDecoration(color: colorYellow),
                      //   child: Text(
                      //     "Toppings Groups",
                      //     style: TextStyle(
                      //         color: colorTextWhite,
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w500),
                      //   ),
                      // ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                        // decoration: BoxDecoration(color: colorYellow),
                        alignment: Alignment.center,
                        child: Text(
                          "Price",
                          style: TextStyle(
                              color: colorTextWhite,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(vertical: 13),
                      //   // decoration: BoxDecoration(color: colorYellow),
                      //   alignment: Alignment.center,
                      //   child: Text(
                      //     "Action",
                      //     style: TextStyle(
                      //         color: colorTextWhite,
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w500),
                      //   ),
                      // ),
                    ]),
              ]),
          Expanded(
            child: isDataLoad
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                      color: colorYellow,
                    ),
                  )
                : Container(
                    decoration:
                        BoxDecoration(color: colorTextWhite, boxShadow: [
                      BoxShadow(
                        color: colorYellow,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 1.0,
                      ),
                    ]),
                    child: ListView.builder(
                        primary: false,
                        physics: BouncingScrollPhysics(),
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
                                        // A motion is a widget used to control how the pane animates.
                                        motion: const ScrollMotion(),
                                        // All actions are defined in the children parameter.
                                        children: [
                                          Spacer(),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: SlidableAction(
                                              onPressed: (context) {
                                                // print("TAP");
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
                                              // label: 'Delete',
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
                                              // label: 'Share',
                                            ),
                                          ),
                                        ],
                                      ),
                                      key: ValueKey(data[index].items![i].name),
                                      child: Table(
                                          key: ValueKey(
                                              data[index].items![i].name),
                                          columnWidths: {
                                            0: FlexColumnWidth(7.1),
                                            1: FlexColumnWidth(5.0),
                                            2: FlexColumnWidth(5.0),
                                            // 3: FlexColumnWidth(1.7),
                                            // 3: FlexColumnWidth(1.5),
                                            // 4: FlexColumnWidth(1.5),
                                          },
                                          // border: TableBorder.all(
                                          //     width: 0.8,
                                          //     color: colorDividerGreen),
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          children: [
                                            TableRow(children: [
                                              // Container(
                                              //   padding: EdgeInsets.symmetric(
                                              //       horizontal: 10,
                                              //       vertical: 20),
                                              //   child: Text(
                                              //     (index + 1).toString(),
                                              //     style: TextStyle(
                                              //       color: colorTextBlack,
                                              //       fontSize: 14,
                                              //     ),
                                              //   ),
                                              // ),
                                              Container(
                                                color: i % 2 == 0
                                                    ? Color.fromRGBO(
                                                        228, 225, 246, 1)
                                                    : colorTextWhite,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 15),
                                                child: Text(
                                                    data[index].items![i].name!,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              Container(
                                                color: i % 2 == 0
                                                    ? Color.fromRGBO(
                                                        228, 225, 246, 1)
                                                    : colorTextWhite,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 15),
                                                child: Text(
                                                    data[index]
                                                        .items![i]
                                                        .category!
                                                        .name!,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              // Container(
                                              //   padding: EdgeInsets.symmetric(
                                              //       horizontal: 10, vertical: 20),
                                              //   child: Text(
                                              //       getOptionName(data[index]
                                              //           .items![i]
                                              //           .options!),
                                              //       // "None",
                                              //       style: TextStyle(
                                              //         color: colorTextBlack,
                                              //         fontSize: 14,
                                              //       )),
                                              // ),
                                              // for (int j = 0;
                                              //     data[i]
                                              //             .items![index]
                                              //             .toppings!
                                              //             .length <
                                              //         j;
                                              //     j++)
                                              // Container(
                                              //   padding: EdgeInsets.symmetric(
                                              //       horizontal: 10,
                                              //       vertical: 20),
                                              //   child: Text(
                                              //       // defaultValue(
                                              //       //     data[i]
                                              //       //         .items![index]
                                              //       //         .toppings![j]
                                              //       //         .name,
                                              //       //     "None"),
                                              //       getToppingGroupName(
                                              //           data[index]
                                              //               .items![i]
                                              //               .options!),
                                              //       maxLines: 1,
                                              //       style: TextStyle(
                                              //         color: colorTextBlack,
                                              //         fontSize: 14,
                                              //       )),
                                              // ),
                                              Container(
                                                color: i % 2 == 0
                                                    ? Color.fromRGBO(
                                                        228, 225, 246, 1)
                                                    : colorTextWhite,
                                                padding: EdgeInsets.symmetric(
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
                                                    // "",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color:
                                                            colorButtonYellow,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              // Row(
                                              //   // mainAxisAlignment:
                                              //   //     MainAxisAlignment
                                              //   //         aceAround,
                                              //   children: [
                                              //     GestureDetector(
                                              //       child: Text("Edit",
                                              //           textAlign: TextAlign.center,
                                              //           style: TextStyle(
                                              //             color: colorLightRed,
                                              //             fontSize: 14,
                                              //           )),
                                              //       onTap: () {
                                              //         // editMenuItem(
                                              //         //     data[index].items![i]);
                                              //       },
                                              //     ),
                                              //     SizedBox(width: 12),
                                              //     GestureDetector(
                                              //       child: SvgPicture.asset(
                                              //         icDelete,
                                              //         width: 20,
                                              //         height: 20,
                                              //       ),
                                              //       onTap: () {
                                              //         // dialogDeleteType(
                                              //         //     TypeListDataModel(
                                              //         //         TYPE_MENU_ITEM,
                                              //         //         data[index]
                                              //         //             .items![i]
                                              //         //             .sId!,
                                              //         //         0,
                                              //         //         data[index]
                                              //         //             .items![i]
                                              //         //             .name!,
                                              //         //         data[index]
                                              //         //             .items![i]
                                              //         //             .description!,
                                              //         //         "",
                                              //         //         "",
                                              //         //         [],
                                              //         //         "",
                                              //         //         "",
                                              //         //         "",
                                              //         //         "",
                                              //         //         0));
                                              //       },
                                              //     ),
                                              //   ],
                                              // ),
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
                                    // if (oldIndex < newIndex) {
                                    // newIndex -= 1;
                                    // var state1 = data[i]
                                    //     .items![newIndex - 1]
                                    //     .category!
                                    //     .sId;
                                    // var state2 = data[i]
                                    //     .items![oldIndex]
                                    //     .category!
                                    //     .sId;
                                    // if (newIndex < oldIndex) {
                                    //   oldIndex -= 1;
                                    //   print("OLD INDEX: " +
                                    //       oldIndex.toString());
                                    // }
                                    // if (state1 == state2) {
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
                                    // } else {
                                    //   showMessage(
                                    //       "Category Not Matched", context);
                                    // }
                                    // } else {
                                    //   print(
                                    //       "======================NOT MATCHED============================");
                                    // }
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
            // Navigator.pop(context);
            setState(() {
              data = [];
            });
            getMenuItems();
            // widget.onAddDeleteSuccess();
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
