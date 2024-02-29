// ignore_for_file: unnecessary_null_comparison, unused_field, must_be_immutable, must_call_super

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/itemsTimeSet/repository/addTimeZoneItem.dart';
import 'package:food_inventory/UI/itemsTimeSet/restaurant_select.dart';
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
      {Key? key, required this.onDialogClose,
      required this.name,
      required this.nameEdit,
      required this.category,
      required this.itemList}) : super(key: key);

  @override
  _DialogScheduleProductState createState() => _DialogScheduleProductState();
}

class _DialogScheduleProductState extends State<DialogEditScheduleProduct> {
  final _dropDownValue = "";
  final List<TypeList> _selectedGrpData = [];
  List<SelectionModel> selectionModel = [];
  String timeStart = "";
  String timeEnd = "";

  late String dateTime;
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  var color1 = Colors.grey;
  var color2 = Colors.grey;
  var color3 = Colors.grey;
  var color4 = Colors.grey;
  var color5 = Colors.grey;
  var color6 = Colors.grey;
  var color7 = Colors.grey;

  var colorGrey = Colors.grey;
  var colorGreen = Colors.green;

  bool valueSecond = false;

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
  final _productCheckBox = false;
  late GlobalKey dropdownProduct;

  @override
  void initState() {
    dropdownProduct = GlobalKey();
    _addItemsRepository = AddItemsRepository(context, widget);
    selectedStartTime = TimeOfDay.now();
    selectedEndTime = TimeOfDay.now();
    itemList = [];
    dataListCategory = [];
    for (int i = 0; i < widget.itemList.options!.length; i++) {
      dataCategoryItems.add(widget.itemList.options![i].name.toString());
      setState(() {
        ItemIds mode = ItemIds();
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
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select ${widget.itemList.zoneGroup}",
                      style: const TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
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
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 60,
                      child: ListView(
                        children: [
                          Table(
                            children: [
                              for (var i = 0; i < _selectedGrpData.length; i++)
                                TableRow(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 1, vertical: 1),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _selectedGrpData[i].name.toString(),
                                        style: const TextStyle(
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
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Opening Closing Schedule",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 19),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                // width: 160,
                                decoration: const BoxDecoration(
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
                                        controller: TextEditingController(
                                            text: timeStart.isEmpty
                                                ? widget.itemList.startTime
                                                : formatTimeOfDay(
                                                    selectedStartTime,
                                                    'hh:mm a')),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: colorTextBlack),
                                        decoration: const InputDecoration(
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
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "To",
                            style: TextStyle(
                                color: colorTextBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                // width: 160,
                                decoration: const BoxDecoration(
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
                                        controller: TextEditingController(
                                            text: timeEnd.isEmpty
                                                ? widget.itemList.endTime
                                                : formatTimeOfDay(
                                                    selectedEndTime,
                                                    'hh:mm a')),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: colorTextBlack),
                                        decoration: const InputDecoration(
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
                        const Text(
                          "Select Days ",
                          style: TextStyle(
                              color: colorTextBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            const Text(
                              "Select All",
                              style: TextStyle(
                                  color: colorTextBlack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                            Checkbox(
                              value: _valueC,
                              checkColor: Colors.grey,
                              onChanged: (bool? value) {
                                setState(() {
                                  _valueC = value!;
                                  if (value) {
                                    if (days.isNotEmpty) {
                                      days.clear();
                                    }
                                    if (widget.itemList.days!.isNotEmpty) {
                                      widget.itemList.days!.clear();
                                    }
                                    color1 = Colors.green;
                                    color2 = Colors.green;
                                    color3 = Colors.green;
                                    color4 = Colors.green;
                                    color5 = Colors.green;
                                    color6 = Colors.green;
                                    color7 = Colors.green;
                                    days.add("Sunday");
                                    days.add("Monday");
                                    days.add("Tuesday");
                                    days.add("Wednesday");
                                    days.add("Thursday");
                                    days.add("Friday");
                                    days.add("Saturday");
                                  } else {
                                    color1 = Colors.grey;
                                    color2 = Colors.grey;
                                    color3 = Colors.grey;
                                    color4 = Colors.grey;
                                    color5 = Colors.grey;
                                    color6 = Colors.grey;
                                    color7 = Colors.grey;
                                    if (days.isNotEmpty) {
                                      days.clear();
                                    }

                                    if (widget.itemList.days!.isNotEmpty) {
                                      widget.itemList.days!.clear();
                                    }
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                        child: Row(children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Sunday")) {
                                  widget.itemList.days!.remove("Sunday");
                                }
                                if (color1 == Colors.grey) {
                                  color1 = Colors.green;

                                  days.add("Sunday");
                                } else if (color1 == Colors.green) {
                                  color1 = Colors.grey;
                                  if (days.contains("Sunday")) {
                                    days.remove("Sunday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Sunday")
                                      ? (color1 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color1,
                              radius: 17,
                              child: const Center(
                                child: Text(
                                  "S",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Monday")) {
                                  widget.itemList.days!.remove("Monday");
                                }
                                if (color2 == Colors.grey) {
                                  color2 = Colors.green;
                                  days.add("Monday");
                                } else if (color2 == Colors.green) {
                                  color2 = Colors.grey;
                                  if (days.contains("Monday")) {
                                    days.remove("Monday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Monday")
                                      ? (color2 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color2,
                              radius: 17,
                              child: const Center(
                                child: Text(
                                  "M",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Tuesday")) {
                                  widget.itemList.days!.remove("Tuesday");
                                }
                                if (color3 == Colors.grey) {
                                  color3 = Colors.green;
                                  days.add("Tuesday");
                                } else if (color3 == Colors.green) {
                                  color3 = Colors.grey;
                                  days.remove("Tuesday");
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Tuesday")
                                      ? (color3 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color3,
                              radius: 17,
                              child: const Center(
                                child: Text(
                                  "T",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!
                                    .contains("Wednesday")) {
                                  widget.itemList.days!.remove("Wednesday");
                                }
                                if (color4 == Colors.grey) {
                                  color4 = Colors.green;

                                  days.add("Wednesday");
                                } else if (color4 == Colors.green) {
                                  color4 = Colors.grey;
                                  if (days.contains("Wednesday")) {
                                    days.remove("Wednesday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Wednesday")
                                      ? (color4 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color4,
                              radius: 17,
                              child: const Center(
                                child: Text(
                                  "W",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!
                                    .contains("Thursday")) {
                                  widget.itemList.days!.remove("Thursday");
                                }
                                if (color5 == Colors.grey) {
                                  color5 = Colors.green;
                                  days.add("Thursday");
                                } else if (color5 == Colors.green) {
                                  color5 = Colors.grey;
                                  if (days.contains("Thursday")) {
                                    days.remove("Thursday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Thursday")
                                      ? (color5 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color5,
                              radius: 17,
                              child: const Center(
                                child: Text(
                                  "T",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Friday")) {
                                  widget.itemList.days!.remove("Friday");
                                }
                                if (color6 == Colors.grey) {
                                  color6 = Colors.green;
                                  days.add("Friday");
                                } else if (color6 == Colors.green) {
                                  color6 = Colors.grey;
                                  if (days.contains("Friday")) {
                                    days.remove("Friday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Friday")
                                      ? (color6 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color6,
                              radius: 17,
                              child: const Center(
                                child: Text(
                                  "F",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!
                                    .contains("Saturday")) {
                                  widget.itemList.days!.remove("Saturday");
                                }
                                if (color7 == Colors.grey) {
                                  color7 = Colors.green;
                                  days.add("Saturday");
                                } else if (color7 == Colors.green) {
                                  color7 = Colors.grey;
                                  if (days.contains("Saturday")) {
                                    days.remove("Saturday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Saturday")
                                      ? (color7 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color7,
                              radius: 17,
                              child: const Center(
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
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
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
                                child: const Text(
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

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      useRootNavigator: false,
      confirmText: "Set",
      cancelText: "Cancel",
      routeSettings: const RouteSettings(),
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
    if (picked != null) {
      setState(() {
        selectedStartTime = picked;
        timeStart = formatTimeOfDay(selectedStartTime, 'HH:mm');
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      useRootNavigator: false,
      confirmText: "Set",
      cancelText: "Cancel",
      routeSettings: const RouteSettings(),
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
    if (picked != null) {
      setState(() {
        selectedEndTime = picked;
        timeEnd = formatTimeOfDay(selectedEndTime, 'HH:mm');
      });
    }
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
          typeFor: ty,
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
