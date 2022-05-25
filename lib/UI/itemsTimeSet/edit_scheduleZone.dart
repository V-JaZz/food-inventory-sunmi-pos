// ignore_for_file: unnecessary_null_comparison, unused_field, must_be_immutable, must_call_super

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/itemsTimeSet/repository/addTimeZoneItem.dart';
import 'package:food_inventory/UI/itemsTimeSet/restaurantSelect.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import 'model/category_list_response_model.dart';
import 'model/menu_list_response_model.dart';
import 'model/time_zone_response_list.dart';

class DialogEditScheduleProduct extends StatefulWidget {
  VoidCallback onDialogClose;
  late String name;
  late String nameEdit;
  late String category;
  TimeZoneItemData itemList;

  DialogEditScheduleProduct(
      {required this.onDialogClose,
      required this.name,
      required this.nameEdit,
      required this.category,
      required this.itemList});

  @override
  _DialogScheduleProductState createState() => _DialogScheduleProductState();
}

class _DialogScheduleProductState extends State<DialogEditScheduleProduct> {
  var _dropDownValue = "";
  List<TypeList> _selectedGrpData = [];
  List<SelectionModel> selectionModel = [];
  String timeStart = "";
  String timeEnd = "";

  late String dateTime;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  var Color1 = Colors.grey;
  var Color2 = Colors.grey;
  var Color3 = Colors.grey;
  var Color4 = Colors.grey;
  var Color5 = Colors.grey;
  var Color6 = Colors.grey;
  var Color7 = Colors.grey;

  var ColorGrey = Colors.grey;
  var ColorGreen = Colors.green;

  bool valuesecond = false;

  bool isDataLoad = false;
  bool isDataLoaded = false;
  var _valueC = false;

  List<MenuItemData> itemList = [];
  List<ItemIds> itemsData = [];
  List<String> days = [];
  List<String> items = [];
  List<String> dataCategoryItems = [];

  List<CategoryDataModel> dataListCategory = [];
  late AddItemsRepository _addItemsRepository;
  late TimeOfDay selectedStartTime, selectedEndTime;
  var _productCheckBox = false;
  late GlobalKey dropdownProduct;

  @override
  void initState() {
    dropdownProduct = GlobalKey();
    _addItemsRepository = new AddItemsRepository(context, widget);
    selectedStartTime = new TimeOfDay.now();
    selectedEndTime = new TimeOfDay.now();
    itemList = [];
    dataListCategory = [];
    for (int i = 0; i < widget.itemList.options!.length; i++) {
      dataCategoryItems.add(widget.itemList.options![i].name.toString());
      setState(() {
        print(
            "DataPrint ${widget.itemList.options![i].sId}  ${widget.itemList.options![i].name} ${widget.itemList.options![i].categoryId}");
        ItemIds mode = new ItemIds();
        mode.sId = widget.itemList.options![i].sId;
        mode.name = widget.itemList.options![i].name;
        mode.categoryID = widget.itemList.options![i].categoryId;
        List<String> idList = [];
        idList.add(mode.sId!);
        _selectedGrpData.add(TypeList(
            "ReEdit", mode.sId!, mode.name!, mode.categoryID!, idList, false));
        itemsData.add(mode);
      });
    }
    getMenuItems();
    getCategories();
  }

  getMenuItems() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getItemsTimeZone, token);
        MenuListResponseModel model = MenuListResponseModel.fromJson(
            ApiBaseHelper().returnResponse(context, response));
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            for (MenuItemData data in model.data!) {
              if (dataCategoryItems.contains(data.name)) {
                data.checkbox = true;
                itemList.add(data);
              } else {
                itemList.add(data);
              }
            }
            /*  setState(() {
              itemList = model.data!;
            });*/
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
        isDataLoaded = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getCategories, token);
        CategoryListResponseModel model = CategoryListResponseModel.fromJson(
            ApiBaseHelper().returnResponse(context, response));
        setState(() {
          isDataLoaded = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            for (CategoryListData data in model.data!) {
              if (dataCategoryItems.contains(data.name)) {
                if (data.description != null) {
                  dataListCategory.add(CategoryDataModel("Category", data.sId!,
                      data.name!, "", data.description!, [], true));
                } else {
                  dataListCategory.add(CategoryDataModel(
                      "Category", data.sId!, data.name!, "", "", [], true));
                }
              } else {
                if (data.description != null) {
                  dataListCategory.add(CategoryDataModel("Category", data.sId!,
                      data.name!, "", data.description!, [], false));
                } else {
                  dataListCategory.add(CategoryDataModel(
                      "Category", data.sId!, data.name!, "", "", [], false));
                }
              }
            }
          }
        }
      } catch (e) {
        print(e.toString());
        setState(() {
          isDataLoaded = false;
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
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select ${widget.itemList.zoneGroup}",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Text(
                    //   widget.name == "items" ? TYPE_MENU_ITEM : TYPE_CATEGORY,
                    //   style: TextStyle(
                    //       color: colorTextBlack,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 18),
                    //   textAlign: TextAlign.center,
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Container(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(223, 221, 239, 1),
                          borderRadius: BorderRadius.circular(05)),
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          selectTypeData(
                              "ReEdit",
                              widget.category == "items"
                                  ? TYPE_MENU_ITEM
                                  : TYPE_CATEGORY,
                              -1,
                              _selectedGrpData);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(223, 221, 239, 1),
                              borderRadius: BorderRadius.circular(05)),
                          child: Text(
                            "---Select---",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: selectionModel == null
                                    ? colorTextHint
                                    : colorTextBlack),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 60,
                      child: ListView(
                        children: [
                          Table(
                            children: [
                              for (var i = 0; i < _selectedGrpData.length; i++)
                                TableRow(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 1),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _selectedGrpData[i].name.toString(),
                                        style: TextStyle(
                                          color: colorTextBlack,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Opening Closing Schedule",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 19),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(18),
                                // width: 160,
                                decoration: BoxDecoration(
                                  color: Color(0xffDFDDEF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        maxLines: 1,
                                        enabled: false,
                                        controller: new TextEditingController(
                                            text: timeStart.isEmpty
                                                ? widget.itemList.startTime
                                                : formatTimeOfDay(
                                                    selectedStartTime,
                                                    'hh:mm a')),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: colorTextBlack),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          isDense: true,
                                          hintText: "Start Time",
                                          hintStyle: TextStyle(
                                              color: colorLightGrey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                          border: InputBorder.none,
                                        ),
                                        cursorColor: colorTextBlack,
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      icClock2,
                                      color: colorButtonYellow,
                                      width: 14,
                                      height: 14,
                                    ),
                                  ],
                                ),
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _selectStartTime();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "To",
                            style: TextStyle(
                                color: colorTextBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(18),
                                // width: 160,
                                decoration: BoxDecoration(
                                  color: Color(0xffDFDDEF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        maxLines: 1,
                                        enabled: false,
                                        controller: new TextEditingController(
                                            text: timeEnd.isEmpty
                                                ? widget.itemList.endTime
                                                : formatTimeOfDay(
                                                    selectedEndTime,
                                                    'hh:mm a')),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: colorTextBlack),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          isDense: true,
                                          hintText: "End Time",
                                          hintStyle: TextStyle(
                                              color: colorLightGrey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                          border: InputBorder.none,
                                        ),
                                        cursorColor: colorTextBlack,
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                    GestureDetector(
                                      child: SvgPicture.asset(
                                        icClock2,
                                        color: colorButtonYellow,
                                        width: 14,
                                        height: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _selectEndTime();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select Days ",
                          style: TextStyle(
                              color: colorTextBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              "Select All",
                              style: TextStyle(
                                  color: colorTextBlack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                            new Checkbox(
                              value: _valueC,
                              checkColor: Colors.grey,
                              onChanged: (bool? value) {
                                setState(() {
                                  _valueC = value!;
                                  if (value) {
                                    if (days.length != 0) {
                                      days.clear();
                                    }
                                    if (widget.itemList.days! != 0) {
                                      widget.itemList.days!.clear();
                                    }
                                    Color1 = Colors.green;
                                    Color2 = Colors.green;
                                    Color3 = Colors.green;
                                    Color4 = Colors.green;
                                    Color5 = Colors.green;
                                    Color6 = Colors.green;
                                    Color7 = Colors.green;
                                    days.add("Sunday");
                                    days.add("Monday");
                                    days.add("Tuesday");
                                    days.add("Wednesday");
                                    days.add("Thursday");
                                    days.add("Friday");
                                    days.add("Saturday");
                                  } else {
                                    Color1 = Colors.grey;
                                    Color2 = Colors.grey;
                                    Color3 = Colors.grey;
                                    Color4 = Colors.grey;
                                    Color5 = Colors.grey;
                                    Color6 = Colors.grey;
                                    Color7 = Colors.grey;
                                    if (days.length != 0) {
                                      days.clear();
                                    }

                                    if (widget.itemList.days! != 0) {
                                      widget.itemList.days!.clear();
                                    }
                                  }
                                  print('value: $value');
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                        child: Row(children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Sunday")) {
                                  widget.itemList.days!.remove("Sunday");
                                }
                                if (Color1 == Colors.grey) {
                                  Color1 = Colors.green;

                                  days.add("Sunday");
                                } else if (Color1 == Colors.green) {
                                  Color1 = Colors.grey;
                                  if (days.contains("Sunday")) {
                                    days.remove("Sunday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Sunday")
                                      ? (Color1 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color1,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "S",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Monday")) {
                                  widget.itemList.days!.remove("Monday");
                                }
                                if (Color2 == Colors.grey) {
                                  Color2 = Colors.green;
                                  days.add("Monday");
                                } else if (Color2 == Colors.green) {
                                  Color2 = Colors.grey;
                                  if (days.contains("Monday")) {
                                    days.remove("Monday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Monday")
                                      ? (Color2 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color2,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "M",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Tuesday")) {
                                  widget.itemList.days!.remove("Tuesday");
                                }
                                if (Color3 == Colors.grey) {
                                  Color3 = Colors.green;
                                  days.add("Tuesday");
                                } else if (Color3 == Colors.green) {
                                  Color3 = Colors.grey;
                                  days.remove("Tuesday");
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Tuesday")
                                      ? (Color3 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color3,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "T",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!
                                    .contains("Wednesday")) {
                                  widget.itemList.days!.remove("Wednesday");
                                }
                                if (Color4 == Colors.grey) {
                                  Color4 = Colors.green;

                                  days.add("Wednesday");
                                } else if (Color4 == Colors.green) {
                                  Color4 = Colors.grey;
                                  if (days.contains("Wednesday")) {
                                    days.remove("Wednesday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Wednesday")
                                      ? (Color4 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color4,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "W",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!
                                    .contains("Thursday")) {
                                  widget.itemList.days!.remove("Thursday");
                                }
                                if (Color5 == Colors.grey) {
                                  Color5 = Colors.green;
                                  days.add("Thursday");
                                } else if (Color5 == Colors.green) {
                                  Color5 = Colors.grey;
                                  if (days.contains("Thursday")) {
                                    days.remove("Thursday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Thursday")
                                      ? (Color5 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color5,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "T",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Friday")) {
                                  widget.itemList.days!.remove("Friday");
                                }
                                if (Color6 == Colors.grey) {
                                  Color6 = Colors.green;
                                  days.add("Friday");
                                } else if (Color6 == Colors.green) {
                                  Color6 = Colors.grey;
                                  if (days.contains("Friday")) {
                                    days.remove("Friday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Friday")
                                      ? (Color6 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color6,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "F",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!
                                    .contains("Saturday")) {
                                  widget.itemList.days!.remove("Saturday");
                                }
                                if (Color7 == Colors.grey) {
                                  Color7 = Colors.green;
                                  days.add("Saturday");
                                } else if (Color7 == Colors.green) {
                                  Color7 = Colors.grey;
                                  if (days.contains("Saturday")) {
                                    days.remove("Saturday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Saturday")
                                      ? (Color7 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color7,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "S",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ])),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.only(left: 30, right: 10),
                                decoration: BoxDecoration(
                                    color: colorGreen,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Update",
                                  style: TextStyle(
                                      color: colorTextWhite,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ),
                              onTap: () {
                                if (widget.itemList.days!.length != null) {
                                  for (String dataDays
                                      in widget.itemList.days!) {
                                    days.add(dataDays);
                                  }
                                }
                                _addItemsRepository.addEditOption(
                                    widget.nameEdit,
                                    timeStart,
                                    timeEnd,
                                    days,
                                    selectionModel,
                                    widget.itemList);
                              },
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.only(left: 8, right: 30),
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
                                Navigator.pop(context);
                              },
                              behavior: HitTestBehavior.opaque,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Future<Null> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      useRootNavigator: false,
      confirmText: "Set",
      cancelText: "Cancel",
      routeSettings: RouteSettings(),
      initialTime: selectedStartTime,
      builder: (BuildContext _context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(_context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedStartTime = picked;
        timeStart = formatTimeOfDay(selectedStartTime, 'HH:mm');
        print("$selectedStartTime");
      });
  }

  Future<Null> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      useRootNavigator: false,
      confirmText: "Set",
      cancelText: "Cancel",
      routeSettings: RouteSettings(),
      initialTime: selectedEndTime,
      builder: (BuildContext _context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(_context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedEndTime = picked;
        timeEnd = formatTimeOfDay(selectedEndTime, 'HH:mm');
        print("$selectedEndTime");
      });
  }

  getProductCheck(MenuItemData value, TimeZoneItemData itemList) {
    for (int i = 0; i < itemList.options!.length; i++) {
      if (itemList.options![i].name == value.name) {
        return true;
      } else {
        return false;
      }
    }
  }

  getCategoryCheck(CategoryDataModel value, TimeZoneItemData itemList) {
    for (int i = 0; i < itemList.options!.length; i++) {
      if (itemList.options![i].name == value.name) {
        return true;
      } else {
        return false;
      }
    }
  }

  void selectTypeData(
      String ty, String type, int index, List<TypeList> selectedData) {
    showDialog(
      context: context,
      builder: (selectDataDialogContext) {
        return DialogRestaurantDataSelection(
          type: type,
          typefor: ty,
          selectedData: selectedData,
          onSelectData: (List<SelectionModel> dataModel) {
            setState(() {
              List<String> idList = [];
              selectedData.clear();
              selectionModel = dataModel;
              for (SelectionModel menuItem in selectionModel) {
                idList.add(menuItem.id);
                selectedData.add(TypeList("ReEdit", menuItem.id, menuItem.name,
                    menuItem.catId, idList, false));
              }
            });
          },
        );
      },
    );
  }
}
