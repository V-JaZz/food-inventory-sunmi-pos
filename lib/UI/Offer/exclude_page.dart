import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_inventory/UI/menu/model/menu_items.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import '../../main.dart';
import 'package:food_inventory/constant/switch.dart' as SW;

// ignore: must_be_immutable
class ExcluedPage extends StatefulWidget {
  var type;
  VoidCallback onDialogClose;

  ExcluedPage({this.type, required this.onDialogClose});

  @override
  _ExcluedPageState createState() => _ExcluedPageState();
}

class _ExcluedPageState extends State<ExcluedPage> {
  List itemIds = [];
  List discountType = [];

  @override
  void initState() {
    super.initState();
    initialList = itemList;
    getMenuItems();
    _searchFieldController.addListener(onChange);
  }

  onChange() {
    setState(() {});
  }

  var data;
  var datatwo;
  bool search = false;
  final _searchFieldController = TextEditingController();

  bool isDataLoad = false;
  int selected = 0;
  bool visible = true;
  bool item = true;
  bool category = true;
  @override
  Widget build(BuildContext context) {
    filterCars(_searchFieldController.text);
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 3.0,
        sigmaY: 3.0,
      ),
      child: Container(
        decoration: new BoxDecoration(color: Color.fromRGBO(11, 4, 58, 0.7)),
        child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Column(
              children: [
                isDataLoad
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                          color: colorGreen,
                        ),
                      )
                    : Container(
                        // color: colorTextWhite,
                        decoration: BoxDecoration(
                            color: colorTextWhite,
                            borderRadius: BorderRadius.circular(13)),
                        margin: EdgeInsets.only(top: 200),
                        height: MediaQuery.of(context).size.height * 0.37,
                        child: Column(
                          children: [
                            search
                                ? Row(
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
                                          padding:
                                              EdgeInsets.only(bottom: 03.5),
                                          height: 55,
                                          child: TextField(
                                            onEditingComplete: () {
                                              setState(() {
                                                filterCars(
                                                    _searchFieldController
                                                        .text);
                                              });
                                            },
                                            onSubmitted: (value) =>
                                                setState(() {
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
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300,
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
                                  )
                                : Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                        // color: colorGreen,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(14),
                                            topRight: Radius.circular(14))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Text(
                                            "Select Items",
                                            style: TextStyle(
                                                color: colorTextBlack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
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
                                          child: Container(
                                            padding: EdgeInsets.only(right: 15),
                                            child: Icon(Icons.search,
                                                size: 25,
                                                color: colorButtonYellow),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Container(
                              margin: EdgeInsets.only(bottom: 05),
                              height: MediaQuery.of(context).size.height * 0.24,
                              child: ListView.builder(
                                itemCount: dataList.length,
                                shrinkWrap: true,
                                itemBuilder: (listContext, index) {
                                  return Column(
                                    children: [
                                      for (int i = 0;
                                          dataList[index].items!.length > i;
                                          i++)
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          padding: EdgeInsets.only(left: 15),
                                          decoration: BoxDecoration(
                                              color: i % 2 == 0
                                                  ? Color.fromRGBO(
                                                      228, 225, 246, 1)
                                                  : colorTextWhite),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.54,
                                                child: Text(
                                                  dataList[index]
                                                      .items![i]
                                                      .name!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: colorTextBlack,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13),
                                                ),
                                              ),
                                              SW.Switch(
                                                  value: dataList[index]
                                                      .items![i]
                                                      .excludeDiscount!,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      dataList[index]
                                                              .items![i]
                                                              .excludeDiscount =
                                                          value;
                                                      itemIds.add(
                                                          dataList[index]
                                                              .items![i]
                                                              .sId);
                                                      _itemsData.add({
                                                        'id': dataList[index]
                                                            .items![i]
                                                            .sId,
                                                        'excludeDiscount':
                                                            dataList[index]
                                                                .items![i]
                                                                .excludeDiscount
                                                      });

                                                      print(_itemsData
                                                          .toString());
                                                      discountType.add(
                                                          dataList[index]
                                                              .items![i]
                                                              .excludeDiscount);
                                                    });
                                                  },
                                                  // activeColor: colorGreen,
                                                  inactiveTrackColor:
                                                      colorButtonYellow,
                                                  activeTrackColor: colorGreen,
                                                  thumbColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.white))
                                            ],
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Container(
                              // margin: EdgeInsets.only(top: 20, right: 22, left: 10),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              // width: 480,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 14),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            color: colorGreen,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                              color: colorTextWhite,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12),
                                        ),
                                      ),
                                      onTap: () {
                                        // Navigator.of(context).pop();
                                        itemDiscount(data, datatwo);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 14),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 8),
                                        decoration: BoxDecoration(
                                            color: colorGrey,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Text(
                                          "Cancel",
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
                      ),
              ],
            )),
      ),
    );
  }

  List<Items> itemList = [];
  List<Items> initialList = [];
  List<Data> dataList = [];
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
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            setState(() {
              dataList = model.data!;
              for (int i = 0; i < model.data!.length; i++) {
                itemList = model.data![i].items!;
                initialList = model.data![i].items!;
              }
              // itemList = model.data!;
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

  var _itemsData = [];
  // late BuildContext context;
  final ApiBaseHelper _helper = ApiBaseHelper();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  itemDiscount(ids, allowDiscount) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      Map data = {};
      data['items'] = _itemsData;
      var body = json.encode(data);
      if (body.isNotEmpty) {
        Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
        try {
          final response = await _helper.post(
              ApiBaseHelper.updateItemDiscountStatus, body, token);
          CommonModel model =
              CommonModel.fromJson(_helper.returnResponse(context, response));

          if (model.success!) {
            showMessage("Discount updated successfully...", context);
            // getMenuItems();
            Navigator.of(context).pop();
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            setState(() {
              itemIds.clear();
              _itemsData.clear();
            });
          }
        } catch (e) {
          print(e.toString());
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        }
      }
    });
  }

  void filterCars(String enteredKeyword) {
    List<Items> results = [];
    if (enteredKeyword.isEmpty) {
      results = itemList;
    } else {
      results = itemList
          .where((user) =>
              user.name!.toUpperCase().contains(enteredKeyword.toUpperCase()))
          .toList();
    }
    setState(() {
      initialList = results;
    });
  }
}
