import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_inventory/UI/itemsTimeSet/dialog_add_time_zone.dart';
import 'package:food_inventory/UI/itemsTimeSet/dialog_delete_type.dart';
import 'package:food_inventory/UI/itemsTimeSet/dialog_edit_status.dart';
import 'package:food_inventory/UI/itemsTimeSet/dialog_edit_type.dart';
import 'package:food_inventory/UI/itemsTimeSet/model/time_zone_response_list.dart';
import 'package:food_inventory/UI/menu/dialog_type_list_view.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/switch.dart' as sw;
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

class ItemsTimeSet extends StatefulWidget {
  const ItemsTimeSet({Key? key}) : super(key: key);

  @override
  State<ItemsTimeSet> createState() => _ItemsTimeSetState();
}

class _ItemsTimeSetState extends State<ItemsTimeSet> {
  bool isDataLoad = false;
  List<TimeZoneItemData> itemList = [];
  late String delId;

  @override
  void initState() {
    super.initState();
    itemList = [];
    getTimeZone();
  }

  getTimeZone() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response =
            await ApiBaseHelper().get(ApiBaseHelper.getTimeZone, token);
        if (kDebugMode) {
          print(response);
        }
        TimeListResponseModel model = TimeListResponseModel.fromJson(
            ApiBaseHelper().returnResponse(context, response));
        setState(() {
          isDataLoad = false;
        });
        if (model.success!) {
          if (model.data!.isNotEmpty) {
            setState(() {
              itemList = model.data!;
            });
          } else {
            itemList = [];
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
        setState(() {
          isDataLoad = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      decoration: const BoxDecoration(color: colorBackground),
      child: Column(
        children: [
          const Text(
            "Items/Category Time Zone",
            style: TextStyle(
                color: colorTextBlack,
                fontWeight: FontWeight.w700,
                fontSize: 18),
          ),
          const SizedBox(height: 20),
          Table(
              columnWidths: const {
                0: FlexColumnWidth(7.0),
                1: FlexColumnWidth(2.5),
                2: FlexColumnWidth(2.5),
                3: FlexColumnWidth(3.0),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 13),
                        child: const Text(
                          "Zone Name",
                          style: TextStyle(
                              color: colorTextWhite,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 13),
                        child: const Text(
                          "Start",
                          style: TextStyle(
                              color: colorTextWhite,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 13),
                        child: const Text(
                          "End",
                          style: TextStyle(
                              color: colorTextWhite,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 13),
                        alignment: Alignment.center,
                        child: const Text(
                          "Status",
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
                  : ListView(
                      primary: false,
                      // padding: const EdgeInsets.only(top: 30),
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          decoration: const BoxDecoration(
                              color: colorTextWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: colorYellow,
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 1.0,
                                ),
                              ]),
                          child: Column(
                            children: [
                              Table(
                                children: [
                                  for (var i = 0; i < itemList.length; i++)
                                    TableRow(children: [
                                      Container(
                                        color: i % 2 == 0
                                            ? const Color.fromRGBO(
                                                228, 225, 246, 1)
                                            : colorTextWhite,
                                        child: Slidable(
                                          endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            children: [
                                              const Spacer(),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.05,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: SlidableAction(
                                                  onPressed: (context) {
                                                    dialogDeleteTime(
                                                        PRODUCT_TIME_DELETE,
                                                        itemList[i]);
                                                  },
                                                  backgroundColor:
                                                      colorButtonYellow,
                                                  foregroundColor:
                                                      colorTextWhite,
                                                  icon: Icons.delete,
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.05,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: SlidableAction(
                                                    backgroundColor:
                                                        colorTextBlack,
                                                    foregroundColor:
                                                        colorTextWhite,
                                                    icon: Icons.edit,
                                                    onPressed: (context) {
                                                      dialogEditTime(
                                                          TYPE_TOPPINGS,
                                                          itemList[i]);
                                                    }),
                                              ),
                                            ],
                                          ),
                                          key: ValueKey(itemList[i]),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.46,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Text(itemList[i].name!,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    overflow: TextOverflow.clip,
                                                    style: const TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.12,
                                                child: Text(
                                                    itemList[i].startTime!,
                                                    style: const TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.12,
                                                child: Text(
                                                    itemList[i]
                                                        .endTime! /* getOptionName(itemList[i].options!)*/,
                                                    style: const TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              Container(
                                                  // color: Colors.red,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.23,
                                                  alignment: Alignment.center,
                                                  child: sw.Switch(
                                                      value:
                                                          itemList[i].isActive!,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          itemList[i].isActive =
                                                              value;
                                                          if (itemList[i]
                                                                  .isActive ==
                                                              value) {
                                                            if (itemList[i]
                                                                    .isActive ==
                                                                false) {
                                                              dialogEditStatus(
                                                                  "Deactivate",
                                                                  itemList[i]);
                                                            } else if (itemList[
                                                                        i]
                                                                    .isActive ==
                                                                true) {
                                                              dialogEditStatus(
                                                                  "Active",
                                                                  itemList[i]);
                                                            }
                                                          } else {
                                                          }

                                                        });
                                                      },
                                                      // activeColor: colorGreen,
                                                      inactiveTrackColor:
                                                          colorButtonYellow,
                                                      activeTrackColor:
                                                          colorGreen,
                                                      thumbColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .white))),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ])
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  dialogAddNewType(TYPE_TOPPINGS);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(15.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child: const Icon(
                                    Icons.add,
                                    color: colorTextWhite,
                                    size: 32,
                                  ),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                          colors: [coloryello2, coloryello])),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
        ],
      ),
    );
  }

  void dialogAddNewType(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return DialogAddNewType(
          type: type,
          onDialogClose: () {
            setState(() {
              getTimeZone();
            });
          },
        );
      },
    );
  }

  void dialogEditStatus(String type, TimeZoneItemData itemList) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return DialogEditStatus(
          type: type,
          itemList: itemList,
          onDialogClose: () {
            setState(() {
              getTimeZone();
            });
          },
        );
      },
    );
  }

  void dialogEditTime(String type, TimeZoneItemData itemList) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return DialogEditTimeZone(
          type: type,
          itemList: itemList,
          onDialogClose: () {
            setState(() {
              getTimeZone();
            });
          },
        );
      },
    );
  }

  void dialogDeleteTime(String type, TimeZoneItemData itemList) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return DialogDeleteType(
          onDialogClose: () {
            setState(() {
              getTimeZone();
            });
          },
          model: TypeListDataModel(PRODUCT_TIME_DELETE, itemList.sId!, 0,
              itemList.name!, "", "", "", [], "", "", "", "", 0),
        );
      },
    );
  }
}
