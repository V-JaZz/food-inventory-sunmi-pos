import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_inventory/UI/order/Repository/order_manage_repository.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/login_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml_parser/xml_parser.dart';

import '../../constant/image.dart';
import 'model/order_list_response_model.dart';
// import 'package:just_audio/just_audio.dart';

class OrderDetailsDialog extends StatefulWidget {
  OrderDataModel orderDataModel;
  VoidCallback onOrderUpdate;
  String name;

  OrderDetailsDialog(
      {required this.orderDataModel,
      required this.onOrderUpdate,
      required this.name});

  @override
  _OrderDetailsDialogState createState() => _OrderDetailsDialogState();
}

class _OrderDetailsDialogState extends State<OrderDetailsDialog> {
  late OrderManageRepository _orderManageRepository;

  static const platformChannel =
      MethodChannel('com.suresh.foodinventory/orderprint');
  var itemDiscount;
  var catDiscount;
  var OrderName;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    sharedPrefs();
    for (int i = 0; i < widget.orderDataModel.itemDetails!.length; i++) {
      setState(() {
        itemDiscount =
            widget.orderDataModel.itemDetails![i].discount.toString();
        catDiscount =
            widget.orderDataModel.itemDetails![i].catDiscount.toString();
      });
    }
    print("ITEM DISCOUNT" + itemDiscount.toString());
    print("ITEM DISCOUNT22" + catDiscount.toString());
    _orderManageRepository = OrderManageRepository(context, widget);
  }

  sharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  callUpdateStatusApi(String status) async {
    _orderManageRepository.changeOrderStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(11, 4, 58, 0.7),
      child: Dialog(
          insetPadding: EdgeInsets.all(20.0),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.46,
                // width: MediaQuery.of(context).size.width * 0.343,
                margin: EdgeInsets.only(top: 10, right: 10),
                // padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: colorTextWhite,
                    borderRadius: BorderRadius.circular(13)),
                child: ListView(
                  controller: ScrollController(),
                  shrinkWrap: true,
                  children: [
                    Column(
                      children: [
                        Row(
                          // mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 15, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      text: TextSpan(
                                          text: 'Name: ',
                                          style: TextStyle(
                                              color: colorTextBlack,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10),
                                          children: [
                                        TextSpan(
                                            text:
                                                "${defaultValue(widget.orderDataModel.userDetails!.firstName, "")} ${defaultValue(widget.orderDataModel.userDetails!.lastName, "")}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ])),
                                  SizedBox(height: 8),
                                  widget.orderDataModel.deliveryType ==
                                          'DELIVERY'
                                      ? RichText(
                                          text: TextSpan(
                                              text: "Address : ",
                                              style: TextStyle(
                                                  color: colorTextBlack,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10),
                                              children: [
                                              TextSpan(
                                                  text: defaultValue(
                                                      widget.orderDataModel
                                                          .userDetails!.address,
                                                      "N/A"),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                            ]))
                                      : SizedBox(),
                                  SizedBox(height: 8),
                                  RichText(
                                      text: TextSpan(
                                          text: "Contact : ",
                                          style: TextStyle(
                                              color: colorTextBlack,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10),
                                          children: [
                                        TextSpan(
                                            text: defaultValue(
                                                widget.orderDataModel
                                                    .userDetails!.contact,
                                                "N/A"),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ])),
                                  SizedBox(height: 8),
                                  widget.orderDataModel.orderTime != null
                                      ? widget.orderDataModel.deliveryType ==
                                              'DELIVERY'
                                          ? RichText(
                                              text: TextSpan(
                                                  text: "Delivery Time : ",
                                                  style: TextStyle(
                                                      color: colorTextBlack,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 10),
                                                  children: [
                                                  TextSpan(
                                                      text: widget
                                                          .orderDataModel
                                                          .orderTime!,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                ]))
                                          : RichText(
                                              text: TextSpan(
                                                  text: "Collection Time : ",
                                                  style: TextStyle(
                                                      color: colorTextBlack,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 10),
                                                  children: [
                                                  TextSpan(
                                                      text: widget
                                                          .orderDataModel
                                                          .orderTime!,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                ]))
                                      : SizedBox(),
                                  // widget.orderDataModel.advanceOrderDate ==
                                  //         null
                                  //     ? RichText(
                                  //         text: TextSpan(
                                  //             text:
                                  //                 "Advance Order Date :- ",
                                  //             style: TextStyle(
                                  //                 color: colorTextBlack,
                                  //                 fontSize: 14),
                                  //             children: [
                                  //             TextSpan(
                                  //                 text: widget
                                  //                     .orderDataModel
                                  //                     .advanceOrderDate!,
                                  //                 style: TextStyle(
                                  //                     color: colorTextBlack,
                                  //                     fontSize: 14)),
                                  //           ]))
                                  //     : SizedBox(),
                                ],
                              ),
                            )),
                            Container(
                              width: 1,
                              height: 100,
                              decoration:
                                  BoxDecoration(color: colorDividerGreen),
                            ),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 15, bottom: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      text: TextSpan(
                                          text: "Order Number :- ",
                                          style: TextStyle(
                                              color: colorTextBlack,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10),
                                          children: [
                                        TextSpan(
                                            text: defaultValue(
                                                widget
                                                    .orderDataModel.orderNumber,
                                                "N/A"),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ])),
                                  SizedBox(height: 8),
                                  RichText(
                                      text: TextSpan(
                                          text: "Order Type ",
                                          style: TextStyle(
                                              color: colorTextBlack,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10),
                                          children: [
                                        TextSpan(
                                            text: widget.orderDataModel
                                                    .deliveryType![0]
                                                    .toUpperCase() +
                                                widget.orderDataModel
                                                    .deliveryType!
                                                    .substring(1),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ])),
                                  SizedBox(height: 8),
                                  RichText(
                                      text: TextSpan(
                                          text: "Order Time :- ",
                                          style: TextStyle(
                                              color: colorTextBlack,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10),
                                          children: [
                                        TextSpan(
                                            text: widget
                                                .orderDataModel.orderDateTime!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ])),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ))
                          ],
                        ),
                        Container(
                          height: 1,
                          decoration: BoxDecoration(color: colorDividerGreen),
                        ),
                        widget.orderDataModel.itemDetails == null ||
                                widget.orderDataModel.itemDetails!.isEmpty
                            ? Container()
                            : ListView.builder(
                                controller: ScrollController(),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    widget.orderDataModel.itemDetails!.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                    left: 15, right: 25, top: 16),
                                itemBuilder: (context, index) {
                                  ItemDetails itemData =
                                      widget.orderDataModel.itemDetails![index];
                                  for (int i = 0;
                                      itemData.toppings!.length > i;
                                      i++) {
                                    var qty =
                                        itemData.toppings![i].toppingCount;
                                    var price = itemData.toppings![i].price;
                                    print("Quantity: " + qty.toString());
                                    print("Price: " + price.toString());
                                    // getOptionName(itemData.toppings!);
                                  }
                                  getOptionName(itemData.toppings!, itemData);
                                  var toppingsTag = "";
                                  if (itemData.toppings != null) {
                                    for (Toppings topping
                                        in itemData.toppings!) {
                                      if (toppingsTag.isEmpty) {
                                        String priceTag = "";
                                        String quantityTag = "";
                                        if (double.parse(defaultValue(
                                                topping.price.toString(),
                                                "0")) >
                                            0) {
                                          priceTag =
                                              "(${getAmountWithCurrency(defaultValue(topping.price.toString(), "0"))})";
                                          quantityTag =
                                              "(${defaultValue(topping.toppingCount.toString(), "0")})";
                                        }
                                        toppingsTag =
                                            "${defaultValue(topping.name, "N/A")} $priceTag $quantityTag";
                                      } else {
                                        String priceTag = "";
                                        String quantityTag = "";
                                        if (double.parse(defaultValue(
                                                topping.price.toString(),
                                                "0")) >
                                            0) {
                                          priceTag =
                                              "(${getAmountWithCurrency(defaultValue(topping.price.toString(), "0"))})";
                                          quantityTag =
                                              "(${defaultValue(topping.toppingCount.toString(), "0")})";
                                        }
                                        toppingsTag =
                                            "$toppingsTag, ${defaultValue(topping.name, "N/A")} $priceTag $quantityTag";
                                      }
                                    }
                                  }

                                  var itemOptSelection = "";
                                  if (!checkString(itemData.option)) {
                                    itemOptSelection =
                                        "(${defaultValue(itemData.option, "N/A")})";
                                  }
                                  if (!checkString(toppingsTag)) {
                                    if (checkString(itemOptSelection)) {
                                      itemOptSelection = "[$toppingsTag]";
                                    } else {
                                      itemOptSelection =
                                          "$itemOptSelection [$toppingsTag]";
                                    }
                                  }

                                  return Container(
                                    margin: EdgeInsets.only(bottom: 05),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                itemData.excludeDiscount ==
                                                        false
                                                    ? itemData.discount !=
                                                                null &&
                                                            itemData.discount !=
                                                                0
                                                        ? defaultValue(
                                                                itemData.name,
                                                                "N/A") +
                                                            " (${getAmountWithCurrency(defaultValue(itemData.discount.toString(), "0")).replaceAll('€', "% OFF").replaceAll('.0', '')})"
                                                        : itemData.catDiscount !=
                                                                    null &&
                                                                itemData.catDiscount !=
                                                                    0
                                                            ? defaultValue(
                                                                    itemData
                                                                        .name,
                                                                    "N/A") +
                                                                " (${getAmountWithCurrency(defaultValue(itemData.catDiscount.toString(), "0")).replaceAll('€', "% OFF").replaceAll('.0', '')})"
                                                            : itemData.overallDiscount !=
                                                                        null &&
                                                                    itemData.overallDiscount !=
                                                                        0
                                                                ? defaultValue(
                                                                        itemData
                                                                            .name,
                                                                        "N/A") +
                                                                    " (${getAmountWithCurrency(defaultValue(itemData.overallDiscount.toString(), "0")).replaceAll('€', "% OFF").replaceAll('.0', '')})"
                                                                : defaultValue(
                                                                    itemData
                                                                        .name,
                                                                    "N/A")
                                                    : defaultValue(
                                                        itemData.name, "N/A"),
                                                style: TextStyle(
                                                    color: colorTextBlack,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              checkString(itemOptSelection)
                                                  ? Container()
                                                  : Text(
                                                      "$itemOptSelection",
                                                      style: TextStyle(
                                                        color: colorGreen,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                              itemData.variant != null &&
                                                      itemData.variantPrice !=
                                                          '0'
                                                  ? Text(
                                                      "${itemData.variant} (${itemData.variantPrice.toString()})",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff51C800),
                                                          fontSize: 14),
                                                    )
                                                  : SizedBox(),
                                              itemData.subVariant != null &&
                                                      itemData.subVariantPrice !=
                                                          0
                                                  ? Text(
                                                      "${itemData.subVariant} (${itemData.subVariantPrice.toString()})",
                                                      style: TextStyle(
                                                          color: colorTextBlack,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 10),
                                                    )
                                                  : SizedBox(),
                                              Text(
                                                itemData.note.toString(),
                                                style: TextStyle(
                                                    color: colorTextBlack,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        )),
                                        Container(
                                          child: Text(
                                            // "",
                                            "${defaultValue(itemData.quantity.toString(), "1")} X ${getOptionName(itemData.toppings!, itemData) == "" ? getAmountWithCurrency(itemData.price.toString()) : getAmountWithCurrency(getOptionName(itemData.toppings!, itemData).toString())}",
                                            style: TextStyle(
                                                color: colorTextBlack,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                        Container(
                          height: 1,
                          margin: EdgeInsets.only(left: 20, right: 25),
                          decoration: BoxDecoration(color: colorBlack),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(
                        //       top: 16, left: 20, right: 25),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Expanded(
                        //           child: Container(
                        //         child: Text(
                        //           "Total Quantity",
                        //           style: TextStyle(
                        //               color: colorTextBlack, fontSize: 16),
                        //         ),
                        //       )),
                        //       Container(
                        //         child: Text(
                        //           widget.orderDataModel.itemDetails!.length
                        //               .toString(),
                        //           style: TextStyle(
                        //               color: colorTextBlack, fontSize: 16),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   margin: EdgeInsets.only(
                        //       top: 16, left: 20, right: 25),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Expanded(
                        //           child: Container(
                        //         child: Text(
                        //           "Subtotal",
                        //           style: TextStyle(
                        //               color: colorTextBlack, fontSize: 16),
                        //         ),
                        //       )),
                        //       Container(
                        //         child: Text(
                        //           getAmountWithCurrency(defaultValue(
                        //                   widget.orderDataModel.subTotal,
                        //                   "0"))
                        //               ,
                        //           style: TextStyle(
                        //               color: colorTextBlack, fontSize: 16),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        widget.orderDataModel.deliveryType == 'DELIVERY'
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: 10, left: 20, right: 25),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      child: Text(
                                        "Delivery Charge",
                                        style: TextStyle(
                                            color: colorGreen,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10),
                                      ),
                                    )),
                                    Container(
                                      child: Text(
                                        getAmountWithCurrency(defaultValue(
                                            widget.orderDataModel.deliveryCharge
                                                .toString(),
                                            "0")),
                                        style: TextStyle(
                                            color: colorGreen,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 16, right: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Container(
                                child: Text(
                                  "Discount",
                                  style: TextStyle(
                                      color: colorGreen,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10),
                                ),
                              )),
                              Container(
                                child: Text(
                                  getAmountWithCurrency(defaultValue(
                                      widget.orderDataModel.discount.toString(),
                                      "0")),
                                  style: TextStyle(
                                      color: colorGreen,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 16, right: 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Container(
                                child: Text(
                                  "Tip",
                                  style: TextStyle(
                                      color: colorGreen,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10),
                                ),
                              )),
                              Container(
                                child: Text(
                                  widget.orderDataModel.tip!,
                                  style: TextStyle(
                                      color: colorGreen,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   height: 1,
                        //   margin: EdgeInsets.only(
                        //       left: 20, right: 25, top: 14),
                        //   decoration: BoxDecoration(color: colorBlack),
                        // ),
                        Container(
                          color: Color(0xffDFDEDE),
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(top: 15, left: 15, right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Container(
                                child: Text(
                                  "Grand Total",
                                  style: TextStyle(
                                      color: colorTextBlack,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10),
                                ),
                              )),
                              Container(
                                child: Text(
                                  getAmountWithCurrency(widget
                                      .orderDataModel.totalAmount
                                      .toString()),
                                  style: TextStyle(
                                      color: colorTextBlack,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        widget.orderDataModel.orderStatus == STATUS_ACCEPTED
                            ? Text(
                                "Order Accepted",
                                style: TextStyle(
                                    color: Color(0xff51C800),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              )
                            : widget.orderDataModel.orderStatus ==
                                    STATUS_ACCEPTED
                                ? Text(
                                    "Order Declined",
                                    style: TextStyle(
                                        color: Color(0xffFCAE03),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  )
                                : widget.orderDataModel.orderStatus ==
                                        STATUS_PENDING
                                    ? SizedBox()
                                    : SizedBox(),
                        checkString(widget.orderDataModel.note)
                            ? Container()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    top: 14, left: 20, right: 25),
                                padding: EdgeInsets.only(
                                    left: 16, top: 13, bottom: 13, right: 16),
                                decoration:
                                    BoxDecoration(color: colorBackground),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Note :-",
                                      style: TextStyle(
                                          color: colorTextBlack, fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      defaultValue(
                                          widget.orderDataModel.note, "N/A"),
                                      style: TextStyle(
                                          color: colorTextBlack, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                        widget.orderDataModel.orderStatus == STATUS_PENDING
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: 15, left: 20, right: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Icon(Icons.circle,
                                                  size: 50,
                                                  color: Color.fromRGBO(
                                                      234, 234, 234, 1)),
                                              SvgPicture.asset(icCheck,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.025,
                                                  color: Color.fromRGBO(
                                                      81, 200, 0, 1))
                                            ],
                                          ),
                                          Text(
                                            "Accept",
                                            style: TextStyle(
                                                color: colorButtonBlue,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        callUpdateStatusApi(STATUS_ACCEPTED);
                                      },
                                      behavior: HitTestBehavior.opaque,
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    GestureDetector(
                                      child: Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Icon(Icons.circle,
                                                  size: 50,
                                                  color: Color.fromRGBO(
                                                      234, 234, 234, 1)),
                                              SvgPicture.asset(icCross,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.025,
                                                  color: Color.fromRGBO(
                                                      252, 174, 3, 1))
                                            ],
                                          ),
                                          Text(
                                            "Decline",
                                            style: TextStyle(
                                                color: colorButtonBlue,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        callUpdateStatusApi(STATUS_DENIED);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        SizedBox(height: 10),
                        widget.orderDataModel.orderStatus == STATUS_PENDING
                            ? SizedBox()
                            :
                            // : Platform.isAndroid
                            // ?
                            GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 05),
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Color(0xff0B043A),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Text(
                                    "Print",
                                    style: TextStyle(
                                        color: colorTextWhite,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                onTap: () {
                                  // callUpdateStatusApi(STATUS_ACCEPTED);
                                  _printOrder();
                                },
                                behavior: HitTestBehavior.opaque,
                              )
                        // : Container(
                        //     margin: EdgeInsets.only(bottom: 14),
                        //   )
                      ],
                    )
                  ],
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
          )),
    );
  }

  String getOptionName(List<Toppings> list, ItemDetails items) {
    String optionName = "";
    String dataa = "";
    if (list.isEmpty) {
      optionName = "";
    } else {
      for (Toppings data in list) {
        if (optionName.isEmpty) {
          optionName = "${data.toppingCount! * double.parse(data.price!)}";
          var vPrice = '0';
          var vSprice = '0';
          items.variantPrice != 0 ? vPrice = items.variantPrice! : vPrice;
          items.subVariantPrice != 0 ? vSprice = items.variantPrice! : vSprice;
          dataa =
              "${double.parse(optionName) + double.parse(vPrice) + double.parse(vSprice) + double.parse(items.price!)}";
          // print("Total ncic: " + data);
        } else {
          var dat = "${data.toppingCount! * double.parse(data.price!)}";
          optionName = "${double.parse(optionName) + double.parse(dat)}";
          var vPrice = '0';
          var vSprice = '0';
          items.variantPrice != 0 ? vPrice = items.variantPrice! : vPrice;
          items.subVariantPrice != 0 ? vSprice = items.variantPrice! : vSprice;
          dataa =
              "${double.parse(optionName) + double.parse(vPrice) + double.parse(vSprice) + double.parse(items.price!)}";
          // print("Total ncic: " + data);
        }
      }
    }

    return dataa;
  }

  var ip;
  var port;
  var url;
  var jsondata;
  Future<void> _printOrder() async {
    StorageUtil.getData(StorageUtil.keyLoginData, "")!.then((value) {
      print("Storage Data : $value");
      if (value != null && value != "") {
        LoginData loginData = LoginData.fromJson(jsonDecode(value));

        if (checkString(loginData.wifiPrinterIP) ||
            checkString(loginData.wifiPrinterPort)) {
          showMessage(
              "Add WIFI Printer IP Address and Port number from Setting.",
              context);
        } else {
          setState(() {
            jsondata = jsonEncode({
              'name': defaultValue(loginData.restaurantName, ""),
              'phone': defaultValue(loginData.phoneNumber, ""),
              'address': defaultValue(loginData.location, ""),
              'quantity': widget.orderDataModel.itemDetails!.length.toString(),
              'orderData': widget.orderDataModel,
              'ip_address': defaultValue(loginData.wifiPrinterIP, ""),
              'port_number': defaultValue(loginData.wifiPrinterPort, "")
            });
            ip = prefs.getString(ApiBaseHelper.ip) == null
                ? defaultValue(loginData.wifiPrinterIP, "")
                : prefs.getString(ApiBaseHelper.ip);
            port = prefs.getString(ApiBaseHelper.port) == null
                ? defaultValue(loginData.wifiPrinterPort, "")
                : prefs.getString(ApiBaseHelper.port);
            url = prefs.getString(ApiBaseHelper.url) == null
                ? defaultValue(loginData.websiteURL, "")
                : prefs.getString(ApiBaseHelper.url);

            print("$ip" + "IPPPPPPPPPPPPPPPPPPPPPPPPP");
            print("$port" + "IPPPPPPPPPPPPPPPPPPPPPPPPP");
            print("$url" + "IPPPPPPPPPPPPPPPPPPPPPPPPP");

            OrderName = widget.orderDataModel.orderNumber!;
            XmlDocument xmlDocument = XmlDocument([
              XmlDeclaration(version: '1.0', encoding: 'UTF-8'),
              XmlElement(name: 'order', children: [
                XmlElement(name: 'ip', children: [XmlText(ip)]),
                XmlElement(name: 'port', children: [XmlText(port)]),
                XmlElement(name: 'websiteURL', children: [XmlText(url)]),
                XmlElement(name: 'restaurant', children: [
                  XmlElement(name: 'restaurantid'),
                  XmlElement(name: 'name', children: [
                    XmlText(defaultValue(loginData.restaurantName, ""))
                  ]),
                  XmlElement(name: 'telephone', children: [
                    XmlText(defaultValue(loginData.phoneNumber, ""))
                  ]),
                  XmlElement(name: 'Address', children: [
                    XmlText(defaultValue(loginData.location, ""))
                  ]),
                ]),
                //Customer
                XmlElement(name: 'customer', children: [
                  XmlElement(name: 'newcustomer', children: [XmlText("false")]),
                  XmlElement(name: 'customerbusinessname'),
                  XmlElement(name: 'customername', children: [
                    XmlText(widget.orderDataModel.userDetails!.firstName! +
                        " " +
                        widget.orderDataModel.userDetails!.lastName!)
                  ]),
                  XmlElement(name: 'firstname'),
                  XmlElement(name: 'lastname', children: [
                    XmlText(widget.orderDataModel.userDetails!.firstName! +
                        " " +
                        widget.orderDataModel.userDetails!.lastName!)
                  ]),
                  XmlElement(name: 'telephone', children: [
                    XmlText(widget.orderDataModel.userDetails!.contact!)
                  ]),
                  XmlElement(name: 'customerAddress', children: [
                    XmlText(widget.orderDataModel.userDetails!.address!)
                  ]),
                ]),
                //Address
                XmlElement(name: 'OrderType', children: [
                  XmlText(widget.orderDataModel.deliveryType!),
                ]),
                XmlElement(name: 'OrderTime', children: [
                  XmlText(widget.orderDataModel.orderTime!),
                ]),
                // XmlElement(name: 'CollectionTime', children: [
                //   XmlText(widget.orderDataModel.orderTime ?? "0"),
                // ]),
                XmlElement(name: 'paymentreference', children: [
                  XmlText(widget.orderDataModel.paymentMode!),
                ]),
                XmlElement(name: 'orderdate', children: [
                  XmlText(widget.orderDataModel.orderDateTime!),
                ]),
                XmlElement(name: 'deliverytime', children: [
                  XmlText(
                      defaultValue(widget.orderDataModel.deliveryDatetime, "")),
                ]),
                //Addd
                XmlElement(name: 'paydetails', children: [
                  XmlElement(name: 'paysexact', children: [XmlText("false")]),
                  XmlElement(name: 'alternativeamount'),
                  XmlElement(name: 'customerbusinessname'),
                  XmlElement(name: 'electronicallypaid', children: [
                    XmlText(widget.orderDataModel.isPaid.toString())
                  ]),
                  XmlElement(name: 'paymentmethod', children: [
                    XmlText(widget.orderDataModel.paymentMode ?? "")
                  ]),
                  XmlElement(
                      name: 'customerremarks',
                      children: [XmlText(widget.orderDataModel.note ?? "")]),
                ]),
                //Order Date
                XmlElement(name: 'products', children: [
                  for (int i = 0;
                      i < widget.orderDataModel.itemDetails!.length;
                      i++)
                    XmlElement(name: 'product', children: [
                      XmlElement(name: 'productid', children: [
                        XmlText(widget.orderDataModel.itemDetails![i].sId ?? "")
                      ]),
                      XmlElement(name: 'number', children: [
                        XmlText(
                            widget.orderDataModel.itemDetails![i].quantity ??
                                "")
                      ]),
                      XmlElement(name: 'name', children: [
                        XmlText(
                            widget.orderDataModel.itemDetails![i].name ?? "")
                      ]),
                      XmlElement(name: 'price', children: [
                        XmlText(
                            widget.orderDataModel.itemDetails![i].price ?? "")
                      ]),
                      XmlElement(name: 'discount', children: [
                        XmlText(
                            "${widget.orderDataModel.itemDetails![i].discount ?? "0"}")
                      ]),
                      XmlElement(name: 'Catdiscount', children: [
                        XmlText(
                            "${widget.orderDataModel.itemDetails![i].catDiscount ?? "0"}")
                      ]),
                      XmlElement(name: 'OverAllDiscount', children: [
                        XmlText(
                            "${widget.orderDataModel.itemDetails![i].overallDiscount ?? "0"}")
                      ]),
                      XmlElement(name: 'remarks', children: [
                        XmlText(
                            widget.orderDataModel.itemDetails![i].note ?? "")
                      ]),
                    ])
                ]),

                XmlElement(name: 'amounts', children: [
                  XmlElement(name: 'subtotal', children: [
                    XmlText(widget.orderDataModel.subTotal ?? "")
                  ]),
                  XmlElement(name: 'deliverycosts', children: [
                    XmlText(widget.orderDataModel.deliveryCharge ?? "")
                  ]),
                  XmlElement(name: 'Discount', children: [
                    XmlText(widget.orderDataModel.discount ?? "0")
                  ]),
                  XmlElement(
                      name: 'Tip',
                      children: [XmlText(widget.orderDataModel.tip ?? "")]),
                  XmlElement(name: 'total', children: [
                    XmlText(widget.orderDataModel.totalAmount ?? "")
                  ]),
                ]),
              ]),
            ]);
            writeCounter(xmlDocument);
            Process.run('start', ["flutter_pos_driver", "$OrderName", "online"],
                runInShell: true);
          });
          // try {
          //   String quantity = "";
          //   int sum = 0;
          //   int sumParse = 0;
          //   for (var i = 0;
          //       i < widget.orderDataModel.itemDetails!.length;
          //       i++) {
          //     ItemDetails itemData = widget.orderDataModel.itemDetails![i];
          //     quantity = itemData.quantity!.toString();
          //     sumParse = int.parse(quantity);
          //     sum = sum + sumParse;
          //     print(" QuantityTotal $quantity ");
          //     print(" QuantitySum $sum ");
          //   }
          //   var name = jsonEncode(widget.orderDataModel);
          //   print("OrderDetill  $name");
          //   platformChannel.invokeMethod('print_order', {
          //     'name': defaultValue(loginData.restaurantName, ""),
          //     'phone': defaultValue(loginData.phoneNumber, ""),
          //     'address': defaultValue(loginData.location, ""),
          //     'quantity': widget.orderDataModel.itemDetails!.length.toString(),
          //     'orderData': jsonEncode(widget.orderDataModel),
          //     'ip_address': defaultValue(loginData.wifiPrinterIP, ""),
          //     'port_number': defaultValue(loginData.wifiPrinterPort, "")
          //   });
          // } on PlatformException {
          //   print("PlatformException");
          // }
        }
      }
    });
  }

  // _createFolder() async {
  //   final folderName = "orderData";
  //   final path = Directory("$folderName");
  //   if ((await path.exists())) {
  //     // TODO:
  //     print("exist");
  //   } else {
  //     // TODO:
  //     print("not exist");
  //     path.create();
  //   }
  // }
  runCommand() async {
    final directory = await getApplicationDocumentsDirectory();

    final path = Directory("$OrderName");
    if ((await path.exists())) {
      Process.run('dir', [], runInShell: true).then((ProcessResultrs) {});
      print("exist");
      print(path);
    } else {
      print(path);

      print("not exist");
    }
  }

  Future<String> get _localPath async {
    final directory = await getDownloadsDirectory();
    return directory!.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    // final folderName = "orderData";
    print('$path/$OrderName.xml');
    return File('$path/$OrderName.xml');
  }

  Future<File> writeCounter(Object counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }
}
