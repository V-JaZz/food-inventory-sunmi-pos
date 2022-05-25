import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_inventory/constant/colors.dart';
// ignore: library_prefixes
import 'package:food_inventory/constant/switch.dart' as SW;
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

import 'model/restaurantTimeSlotResponseModel.dart';

class RestaurantTimeSet extends StatefulWidget {
  const RestaurantTimeSet({Key? key}) : super(key: key);

  @override
  State<RestaurantTimeSet> createState() => _RestaurantTimeSetState();
}

class _RestaurantTimeSetState extends State<RestaurantTimeSet> {
  bool isDataLoad = false;
  List<TimeSlotItemData> itemList = [];
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
        final response = await ApiBaseHelper()
            .get(ApiBaseHelper.getRestaurantTimeSlot, token);
        RestauantTimeSlotListResponseModel model =
            RestauantTimeSlotListResponseModel.fromJson(
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
      decoration: const BoxDecoration(color: colorBackground),
      child: Column(
        children: [
          const Text(
            "Restaurant Time Zone",
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
                          decoration: const BoxDecoration(color: colorTextWhite,
                              // borderRadius: BorderRadius.only(
                              //     topLeft: Radius.circular(15),
                              //     topRight: Radius.circular(15)),
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
                                                    // dialogDeleteType(
                                                    //     TypeListDataModel(
                                                    //         TYPE_MENU_ITEM,
                                                    //         data[index]
                                                    //             .items![i]
                                                    //             .sId!,
                                                    //         0,
                                                    //         data[index]
                                                    //             .items![i]
                                                    //             .name!,
                                                    //         data[index]
                                                    //             .items![i]
                                                    //             .description!,
                                                    //         "",
                                                    //         "",
                                                    //         [],
                                                    //         "",
                                                    //         "",
                                                    //         "",
                                                    //         "",
                                                    //         0));
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
                                                      // editMenuItem(
                                                      //     data[index].items![i]);
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: Text(itemList[i].name!,
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
                                                      0.27),
                                              Text(itemList[i].startTime!,
                                                  style: const TextStyle(
                                                      color: colorTextBlack,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Text(
                                                  itemList[i]
                                                      .endTime! /* getOptionName(itemList[i].options!)*/,
                                                  style: const TextStyle(
                                                      color: colorTextBlack,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Container(
                                                  // padding: const EdgeInsets
                                                  //         .symmetric(
                                                  //     horizontal: 10),
                                                  alignment: Alignment.center,
                                                  child: SW.Switch(
                                                      value:
                                                          itemList[i].isActive!,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          itemList[i].isActive =
                                                              value;
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
                              Container(
                                margin: const EdgeInsets.all(15.0),
                                width: MediaQuery.of(context).size.width * 0.15,
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
                            ],
                          ),
                        )
                      ],
                    ))
        ],
      ),
    );
  }
}
