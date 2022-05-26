import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_inventory/UI/DeliverySettings/dailog_delivery_setting.dart';
import 'package:food_inventory/UI/DeliverySettings/repository/models/delivery_data_model.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

import 'dialog_create_delivery.dart';

class DeliverySetting extends StatefulWidget {
  // const DeliverySetting({ Key? key }) : super(key: key);

  @override
  _DeliverySettingState createState() => _DeliverySettingState();
}

class _DeliverySettingState extends State<DeliverySetting> {
  bool isDataLoad = false;
  List<DistanceDetail> itemList = [];
  String resId = '';
  @override
  void initState() {
    super.initState();
    getDeliveryData();
  }

  getDeliveryData() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        print("restauranttoday");
        print(restaurantId);
        setState(() {
          resId = restaurantId;
        });
        setState(() {
          isDataLoad = true;
        });
        try {
          final response = await ApiBaseHelper()
              .get(ApiBaseHelper.getDeliveryData + "/" + restaurantId, token);
          print(response);
          DeliveryListResponseModel model = DeliveryListResponseModel.fromJson(
              ApiBaseHelper().returnResponse(context, response));
          setState(() {
            isDataLoad = false;
          });
          if (model.success!) {
            if (model.data!.distanceDetail!.isNotEmpty) {
              setState(() {
                itemList = model.data!.distanceDetail!;
              });
            } else {
              itemList = [];
            }
          }
        } catch (e) {
          print(e.toString());
          setState(() {
            isDataLoad = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: colorBackground),
      child: Column(
        children: [
          const Text(
            "Delivery Settings",
            style: TextStyle(
                color: colorTextBlack,
                fontWeight: FontWeight.w700,
                fontSize: 18),
          ),
          const SizedBox(height: 20),
          Table(
            columnWidths: {
              0: FlexColumnWidth(6.0),
              1: FlexColumnWidth(4.0),
              2: FlexColumnWidth(4.0),
              3: FlexColumnWidth(3.0),
            },
            // border: TableBorder.all(color: colorDividerGreen),
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
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                      // decoration:
                      //     BoxDecoration(color: colorGreen),
                      child: Text(
                        "Delivery Radius",
                        style: TextStyle(
                            color: colorTextWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                      // decoration:
                      //     BoxDecoration(color: colorGreen),
                      child: Text(
                        "Charge",
                        style: TextStyle(
                            color: colorTextWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                      // decoration:
                      //     BoxDecoration(color: colorGreen),
                      child: Text(
                        "Min. Order",
                        style: TextStyle(
                            color: colorTextWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                      // decoration:
                      //     BoxDecoration(color: colorGreen),
                      child: Text(
                        "Time",
                        style: TextStyle(
                            color: colorTextWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ]),
            ],
          ),
          Expanded(
              child: isDataLoad
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5.0,
                        color: colorGreen,
                      ),
                    )
                  : ListView(
                      primary: false,
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
                                        padding: EdgeInsets.only(
                                            left: 17, right: 16),
                                        color: i % 2 == 0
                                            ? const Color.fromRGBO(
                                                228, 225, 246, 1)
                                            : colorTextWhite,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
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
                                                  child: Column(
                                                    children: [
                                                      SlidableAction(
                                                        onPressed: (context) {
                                                          // dialogDeleteTime(
                                                          //     PRODUCT_TIME_DELETE,
                                                          //     itemList[i]);
                                                        },
                                                        backgroundColor:
                                                            colorButtonYellow,
                                                        foregroundColor:
                                                            colorTextWhite,
                                                        icon: Icons.delete,
                                                      ),
                                                    ],
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
                                                  child: Column(
                                                    children: [
                                                      SlidableAction(
                                                          backgroundColor:
                                                              colorTextBlack,
                                                          foregroundColor:
                                                              colorTextWhite,
                                                          icon: Icons.edit,
                                                          onPressed: (context) {
                                                            dialogAddNewType(
                                                                itemList[i]);
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            key: ValueKey(itemList[i]),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.34,
                                                  child: Text(
                                                      itemList[i]
                                                              .minDistance
                                                              .toString() +
                                                          " - " +
                                                          itemList[i]
                                                              .maxDistance
                                                              .toString(),
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 14,
                                                      )),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  child: Text(
                                                      itemList[i]
                                                              .deliveryCharge
                                                              .toString() +
                                                          "€",
                                                      style: TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 14,
                                                      )),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.14,
                                                  child: Text(
                                                      itemList[i]
                                                          .minOrder
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 14,
                                                      )),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  child: Text(
                                                      itemList[i]
                                                          .deliveryTime
                                                          .toString(),
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 14,
                                                      )),
                                                ),
                                                // GestureDetector(
                                                //   child: Container(
                                                //     padding: EdgeInsets.symmetric(
                                                //         horizontal: 10, vertical: 13),
                                                //     alignment: Alignment.center,
                                                //     child: Text("Edit",
                                                //         style: TextStyle(
                                                //           color: colorLightRed,
                                                //           fontSize: 14,
                                                //         )),
                                                //   ),
                                                //   onTap: () {
                                                //     dialogAddNewType(itemList[i]);
                                                //   },
                                                // ),
                                              ],
                                            )),
                                      )
                                    ]),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  dialogDeliveryCreate("");
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

  void dialogAddNewType(DistanceDetail itemList) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return DialogDeliverySetting(
          itemList: itemList,
          onDialogClose: () {
            setState(() {
              getDeliveryData();
            });
          },
        );
      },
    );
  }

  void dialogDeliveryCreate(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return DialogDeliveryCreate(
          type: type,
          onDialogClose: () {
            setState(() {
              getDeliveryData();
            });
          },
        );
      },
    );
  }
}
