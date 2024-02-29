import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_inventory/UI/DeliverySettings/dailog_delivery_setting.dart';
import 'package:food_inventory/UI/DeliverySettings/repository/models/delivery_data_model.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/main.dart';
import 'package:food_inventory/model/common_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';

import 'dialog_create_delivery.dart';

class DeliverySetting extends StatefulWidget {
  const DeliverySetting({Key? key}) : super(key: key);

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
        setState(() {
          resId = restaurantId;
        });
        setState(() {
          isDataLoad = true;
        });
        try {
          final response = await ApiBaseHelper()
              .get(ApiBaseHelper.getDeliveryData + "/" + restaurantId, token);
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
      padding: const EdgeInsets.only(left: 12, right: 12),
      decoration: const BoxDecoration(color: colorBackground),
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
            columnWidths: const {
              0: FlexColumnWidth(6.0),
              1: FlexColumnWidth(4.0),
              2: FlexColumnWidth(4.0),
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
                        "Postcode & City",
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
                        "Charge",
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
                        "Min. Order",
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
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5.0,
                        color: colorGreen,
                      ),
                    )
                  : ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: [
                        Container(
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: Slidable(
                                            endActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                const Spacer(),
                                                // SizedBox(
                                                  // height: MediaQuery.of(context)
                                                  //         .size
                                                  //         .height *
                                                  //     0.05,
                                                  // width: MediaQuery.of(context)
                                                  //         .size
                                                  //         .width *
                                                  //     0.15,
                                                  // child:
                                                  // Column(
                                                  //   children: [
                                                      SlidableAction(
                                                        onPressed: (context) {
                                                          deleteDelivery(
                                                              itemList[i]
                                                                  .id
                                                                  .toString());
                                                        },
                                                        backgroundColor:
                                                            colorButtonYellow,
                                                        foregroundColor:
                                                            colorTextWhite,
                                                        icon: Icons.delete,
                                                      ),
                                                  //   ],
                                                  // ),
                                                // ),
                                                // SizedBox(
                                                  // height: MediaQuery.of(context)
                                                  //         .size
                                                  //         .height *
                                                  // //     0.05,
                                                  // width: MediaQuery.of(context)
                                                  //         .size
                                                  //         .width *
                                                  //     0.15,
                                                  // child:
                                                  // Column(
                                                  //   children: [
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
                                                  //   ],
                                                  // ),
                                                // ),
                                              ],
                                            ),
                                            key: ValueKey(itemList[i]),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.365,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  child: Text(
                                                      itemList[i]
                                                              .postcode
                                                              .toString(),
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: const TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 14,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.165,
                                                  child: Text(
                                                      itemList[i]
                                                              .deliveryCharge
                                                              .toString() +
                                                          "€",
                                                      style: const TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 14,
                                                      )),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  child: Text(
                                                      itemList[i]
                                                          .minOrder
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 14,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  child: Text(
                                                      itemList[i]
                                                          .deliveryTime
                                                          .toString(),
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                        color: colorTextBlack,
                                                        fontSize: 14,
                                                      )),
                                                ),
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
                              const SizedBox(
                                height: 24,
                              )
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

  final ApiBaseHelper _helper = ApiBaseHelper();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  deleteDelivery(String id) {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        var body = jsonEncode({
          'id': id,
        });

        if (body.isNotEmpty) {
          Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
          try {
            final response = await _helper.post(
                ApiBaseHelper.deleteDeliveryData, body, token);

            CommonModel model =
                CommonModel.fromJson(_helper.returnResponse(context, response));
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
            if (model.success!) {
              // Navigator.pop(context);
              getDeliveryData();
            } else {
              showMessage(model.message!, context);
              // Navigator.pop(context);
              getDeliveryData();
            }
          } catch (e) {
            // Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          }
        }
      });
    });
  }
}
