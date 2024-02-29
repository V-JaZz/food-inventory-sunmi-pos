// ignore_for_file: avoid_unnecessary_containers, avoid_print, prefer_adjacent_string_concatenation, prefer_typing_uninitialized_variables, unrelated_type_equality_checks, prefer_if_null_operators, unused_field, import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_inventory/UI/order/Repository/order_manage_repository.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/model/login_model.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/image.dart';
import 'model/order_list_response_model.dart';

// ignore: must_be_immutable
class OrderDetailsDialog extends StatefulWidget {
  OrderDataModel orderDataModel;
  VoidCallback onOrderUpdate;
  String name;

  OrderDetailsDialog(
      {Key? key,
      required this.orderDataModel,
      required this.onOrderUpdate,
      required this.name})
      : super(key: key);

  @override
  _OrderDetailsDialogState createState() => _OrderDetailsDialogState();
}

class _OrderDetailsDialogState extends State<OrderDetailsDialog> {
  late OrderManageRepository _orderManageRepository;

  static const platformChannel =
      MethodChannel('com.suresh.foodinventory/orderprint');
  var itemDiscount;
  var catDiscount;
  var _orderName;
  late SharedPreferences prefs;
  late Timer _timer;
  int mCounter = 1;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

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
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 3.0,
        sigmaY: 3.0,
      ),
      child: Container(
        color: const Color.fromRGBO(11, 4, 58, 0.7),
        child: Dialog(
            insetPadding: const EdgeInsets.all(20.0),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.66,
                    // width: MediaQuery.of(context).size.width * 0.343,
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    // padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: colorTextWhite,
                        borderRadius: BorderRadius.circular(13)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ListView(
                          controller: ScrollController(),
                          shrinkWrap: true,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    // mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 15,
                                                bottom: 15),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                    text: TextSpan(
                                                        text: 'Name:  ',
                                                        style: const TextStyle(
                                                            color: colorTextBlack,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            fontSize: 10),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                              "${defaultValue(widget.orderDataModel.userDetails!.firstName, "")} ${defaultValue(widget.orderDataModel.userDetails!.lastName, "")}",
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                              )),
                                                        ])),
                                                const SizedBox(height: 8),
                                                widget.orderDataModel
                                                    .deliveryType ==
                                                    'DELIVERY'
                                                    ? RichText(
                                                    text: TextSpan(
                                                        text: "Address :  ",
                                                        style: const TextStyle(
                                                            color:
                                                            colorTextBlack,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            fontSize: 10),
                                                        children: [
                                                          TextSpan(
                                                              text: defaultValue(
                                                                  widget
                                                                      .orderDataModel
                                                                      .userDetails!
                                                                      .address.toString() +
                                                                      ' P.C. - ' +
                                                                      widget.orderDataModel.userDetails!.postcode.toString(),
                                                                  "N/A"),
                                                              style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                              )),
                                                        ]))
                                                    : const SizedBox(),
                                                const SizedBox(height: 8),
                                                RichText(
                                                    text: TextSpan(
                                                        text: "Contact :  ",
                                                        style: const TextStyle(
                                                            color: colorTextBlack,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            fontSize: 10),
                                                        children: [
                                                          TextSpan(
                                                              text: defaultValue(
                                                                  widget
                                                                      .orderDataModel
                                                                      .userDetails!
                                                                      .contact,
                                                                  "N/A"),
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                              )),
                                                        ])),
                                                const SizedBox(height: 8),
                                                widget.orderDataModel.orderTime !=
                                                    null
                                                    ? widget.orderDataModel
                                                    .deliveryType ==
                                                    'DELIVERY'
                                                    ? RichText(
                                                    text: TextSpan(
                                                        text:
                                                        "Delivery Time :  ",
                                                        style: const TextStyle(
                                                            color:
                                                            colorTextBlack,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            fontSize: 10),
                                                        children: [
                                                          TextSpan(
                                                              text: widget
                                                                  .orderDataModel
                                                                  .orderTime!,
                                                              style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                              )),
                                                        ]))
                                                    : RichText(
                                                    text: TextSpan(
                                                        text:
                                                        "Collection Time :  ",
                                                        style: const TextStyle(
                                                            color:
                                                            colorTextBlack,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            fontSize: 10),
                                                        children: [
                                                          TextSpan(
                                                              text: widget
                                                                  .orderDataModel
                                                                  .orderTime!,
                                                              style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                              )),
                                                        ]))
                                                    : const SizedBox(),


                                                const SizedBox(height: 8),
                                                RichText(
                                                    text: TextSpan(
                                                        text:
                                                        "Payment Mode :  ",
                                                        style: const TextStyle(
                                                            color:
                                                            colorTextBlack,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            fontSize: 10
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                              text: widget
                                                                  .orderDataModel
                                                                  .paymentMode.toString() == 'Online' ? 'Online' : 'Cash',
                                                              style:
                                                              const TextStyle(
                                                                  color: Color(0xff51C800),
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w400
                                                              )),
                                                        ]))
                                                ,
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
                                        height: 80,
                                        decoration: const BoxDecoration(
                                            color: colorDividerGreen),
                                      ),
                                      Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 8,
                                                bottom: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                    text: TextSpan(
                                                        text: "Order Number :  ",
                                                        style: const TextStyle(
                                                            color: colorTextBlack,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            fontSize: 10),
                                                        children: [
                                                          TextSpan(
                                                              text: defaultValue(
                                                                  widget.orderDataModel
                                                                      .orderNumber,
                                                                  "N/A"),
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                              )),
                                                        ])),
                                                const SizedBox(height: 8),
                                                RichText(
                                                    text: TextSpan(
                                                        text: "Order Type :  ",
                                                        style: const TextStyle(
                                                            color: colorTextBlack,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            fontSize: 10),
                                                        children: [
                                                          TextSpan(
                                                              text: widget
                                                                  .orderDataModel
                                                                  .deliveryType![0]
                                                                  .toUpperCase() +
                                                                  widget.orderDataModel
                                                                      .deliveryType!
                                                                      .substring(1),
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                              )),
                                                        ])),
                                                const SizedBox(height: 8),
                                                RichText(
                                                    text: TextSpan(
                                                        text: "Order Time :  ",
                                                        style: const TextStyle(
                                                            color: colorTextBlack,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            fontSize: 10),
                                                        children: [
                                                          TextSpan(
                                                              text: widget
                                                                  .orderDataModel
                                                                  .orderDateTime!,
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                              )),
                                                        ]))

                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    decoration: const BoxDecoration(
                                        color: colorDividerGreen),
                                  ),
                                  widget.orderDataModel.itemDetails == null ||
                                      widget.orderDataModel.itemDetails!
                                          .isEmpty
                                      ? Container()
                                      : ListView.builder(
                                    controller: ScrollController(),
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemCount: widget.orderDataModel
                                        .itemDetails!.length,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 25, top: 16),
                                    itemBuilder: (context, index) {
                                      ItemDetails itemData = widget
                                          .orderDataModel
                                          .itemDetails![index];
                                      for (int i = 0;
                                      itemData.toppings!.length > i;
                                      i++) {
                                        var qty = itemData
                                            .toppings![i].toppingCount;
                                        var price =
                                            itemData.toppings![i].price;
                                        print("Quantity: " +
                                            qty.toString());
                                        print(
                                            "Price: " + price.toString());
                                        // getOptionName(itemData.toppings!);
                                      }
                                      getOptionName(
                                          itemData.toppings!, itemData);
                                      var toppingsTag = "";
                                      if (itemData.toppings != null) {
                                        for (Toppings topping
                                        in itemData.toppings!) {
                                          if (toppingsTag.isEmpty) {
                                            String priceTag = "";
                                            String quantityTag = "";
                                            if (double.parse(defaultValue(
                                                topping.price
                                                    .toString(),
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
                                                topping.price
                                                    .toString(),
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
                                        if (checkString(
                                            itemOptSelection)) {
                                          itemOptSelection =
                                          "[$toppingsTag]";
                                        } else {
                                          itemOptSelection =
                                          "$itemOptSelection [$toppingsTag]";
                                        }
                                      }

                                      return Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 05),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        itemData.excludeDiscount ==
                                                            false
                                                            ? itemData.discount !=
                                                            null &&
                                                            itemData.discount !=
                                                                0
                                                            ? defaultValue(
                                                            itemData
                                                                .name,
                                                            "N/A") +
                                                            " (${getAmountWithCurrency(defaultValue(itemData.discount.toString(), "0")).replaceAll('€', "% OFF").replaceAll('.0', '')})"
                                                            : itemData.catDiscount !=
                                                            null &&
                                                            itemData.catDiscount !=
                                                                0
                                                            ? defaultValue(itemData.name, "N/A") +
                                                            " (${getAmountWithCurrency(defaultValue(itemData.catDiscount.toString(), "0")).replaceAll('€', "% OFF").replaceAll('.0', '')})"
                                                            : itemData.overallDiscount != null &&
                                                            itemData.overallDiscount !=
                                                                0
                                                            ? defaultValue(itemData.name, "N/A") +
                                                            " (${getAmountWithCurrency(defaultValue(itemData.overallDiscount.toString(), "0")).replaceAll('€', "% OFF").replaceAll('.0', '')})"
                                                            : defaultValue(
                                                            itemData
                                                                .name,
                                                            "N/A")
                                                            : defaultValue(
                                                            itemData.name,
                                                            "N/A"),
                                                        style: const TextStyle(
                                                            color:
                                                            colorTextBlack,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            fontSize: 10),
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      checkString(
                                                          itemOptSelection)
                                                          ? Container()
                                                          : Text(
                                                        itemOptSelection,
                                                        style:
                                                        const TextStyle(
                                                          color:
                                                          colorGreen,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                        ),
                                                      ),
                                                      itemData.variant !=
                                                          null &&
                                                          itemData.variantPrice !=
                                                              '0'
                                                          ? Text(
                                                        "${itemData.variant} (${itemData.variantPrice.toString()})",
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xff51C800),
                                                            fontSize:
                                                            14),
                                                      )
                                                          : const SizedBox(),
                                                      itemData.subVariant !=
                                                          null &&
                                                          itemData.subVariantPrice !=
                                                              0
                                                          ? Text(
                                                        "${itemData.subVariant} (${itemData.subVariantPrice.toString()})",
                                                        style: const TextStyle(
                                                            color:
                                                            colorTextBlack,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            fontSize:
                                                            10),
                                                      )
                                                          : const SizedBox(),
                                                      Text(
                                                        itemData.note
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                            colorTextBlack,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            Container(
                                              child: Text(
                                                // "",
                                                "${defaultValue(itemData.quantity.toString(), "1")} X ${getOptionName(itemData.toppings!, itemData) == "" ? getAmountWithCurrency(itemData.price.toString()) : getAmountWithCurrency(getOptionName(itemData.toppings!, itemData).toString())}",
                                                style: const TextStyle(
                                                    color: colorTextBlack,
                                                    fontWeight:
                                                    FontWeight.w500,
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
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 25),
                                    decoration:
                                    const BoxDecoration(color: colorBlack),
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
                                  widget.orderDataModel.deliveryType ==
                                      'DELIVERY'
                                      ? Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 20, right: 25),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Container(
                                              child: const Text(
                                                "Delivery Charge",
                                                style: TextStyle(
                                                    color: colorGreen,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    fontSize: 10),
                                              ),
                                            )),
                                        Container(
                                          child: Text(
                                            getAmountWithCurrency(
                                                defaultValue(
                                                    widget.orderDataModel
                                                        .deliveryCharge
                                                        .toString(),
                                                    "0")),
                                            style: const TextStyle(
                                                color: colorGreen,
                                                fontWeight:
                                                FontWeight.w500,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                      : const SizedBox(),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 16, right: 25),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Container(
                                              child: const Text(
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
                                                widget.orderDataModel.discount
                                                    .toString(),
                                                "0")),
                                            style: const TextStyle(
                                                color: colorGreen,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 16, right: 25),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Container(
                                              child: const Text(
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
                                            style: const TextStyle(
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
                                    color: const Color(0xffDFDEDE),
                                    padding: const EdgeInsets.all(10.0),
                                    margin: const EdgeInsets.only(
                                        top: 15, left: 15, right: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Container(
                                              child: const Text(
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
                                            style: const TextStyle(
                                                color: colorTextBlack,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  widget.orderDataModel.orderStatus ==
                                      STATUS_ACCEPTED
                                      ? const Text(
                                    "Order Accepted",
                                    style: TextStyle(
                                        color: Color(0xff51C800),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  )
                                      : widget.orderDataModel.orderStatus ==
                                      STATUS_ACCEPTED
                                      ? const Text(
                                    "Order Declined",
                                    style: TextStyle(
                                        color: Color(0xffFCAE03),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  )
                                      : widget.orderDataModel.orderStatus ==
                                      STATUS_PENDING
                                      ? const SizedBox()
                                      : const SizedBox(),
                                  checkString(widget.orderDataModel.note)
                                      ? Container()
                                      : Container(
                                    width:
                                    MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(
                                        top: 14, left: 20, right: 25),
                                    padding: const EdgeInsets.only(
                                        left: 16,
                                        top: 13,
                                        bottom: 13,
                                        right: 16),
                                    decoration: const BoxDecoration(
                                        color: colorBackground),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Note :-",
                                          style: TextStyle(
                                              color: colorTextBlack,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          defaultValue(
                                              widget.orderDataModel.note,
                                              "N/A"),
                                          style: const TextStyle(
                                              color: colorTextBlack,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // : Container(
                                  //     margin: EdgeInsets.only(bottom: 14),
                                  //   )
                                ],
                              ),
                          ),
                        ])),
                        // Visibility(
                        //   visible: widget.orderDataModel.orderStatus ==
                        //           STATUS_PENDING
                        //       ? true
                        //       : false,
                        //   child: Expanded(
                        //     flex: 2,
                        //     child: widget.orderDataModel.orderStatus ==
                        //             STATUS_PENDING
                        //         ? Container(
                        //             margin: const EdgeInsets.only(
                        //                 top: 1, left: 20, right: 25),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.center,
                        //               children: [
                        //                 GestureDetector(
                        //                   child: Column(
                        //                     children: [
                        //                       Stack(
                        //                         alignment: Alignment.center,
                        //                         children: [
                        //                           const Icon(Icons.circle,
                        //                               size: 40,
                        //                               color: Color.fromRGBO(
                        //                                   234, 234, 234, 1)),
                        //                           SvgPicture.asset(icCheck,
                        //                               height:
                        //                                   MediaQuery.of(context)
                        //                                           .size
                        //                                           .height *
                        //                                       0.024,
                        //                               color:
                        //                                   const Color.fromRGBO(
                        //                                       81, 200, 0, 1))
                        //                         ],
                        //                       ),
                        //                       const Text(
                        //                         "Accept",
                        //                         style: TextStyle(
                        //                             color: colorButtonBlue,
                        //                             fontWeight: FontWeight.w500,
                        //                             fontSize: 15),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                   onTap: () {
                        //                     callUpdateStatusApi(
                        //                         STATUS_ACCEPTED);
                        //                   },
                        //                   behavior: HitTestBehavior.opaque,
                        //                 ),
                        //                 const SizedBox(
                        //                   width: 50,
                        //                 ),
                        //                 GestureDetector(
                        //                   child: Column(
                        //                     children: [
                        //                       Stack(
                        //                         alignment: Alignment.center,
                        //                         children: [
                        //                           const Icon(Icons.circle,
                        //                               size: 40,
                        //                               color: Color.fromRGBO(
                        //                                   234, 234, 234, 1)),
                        //                           SvgPicture.asset(icCross,
                        //                               height:
                        //                                   MediaQuery.of(context)
                        //                                           .size
                        //                                           .height *
                        //                                       0.024,
                        //                               color:
                        //                                   const Color.fromRGBO(
                        //                                       252, 174, 3, 1))
                        //                         ],
                        //                       ),
                        //                       const Text(
                        //                         "Decline",
                        //                         style: TextStyle(
                        //                             color: colorButtonBlue,
                        //                             fontWeight: FontWeight.w500,
                        //                             fontSize: 15),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                   behavior: HitTestBehavior.opaque,
                        //                   onTap: () {
                        //                     callUpdateStatusApi(STATUS_DENIED);
                        //                   },
                        //                 ),
                        //               ],
                        //             ),
                        //           )
                        //         : Container(),
                        //   ),
                        // ),
                        Visibility(
                          visible: widget.orderDataModel.orderStatus ==
                                  STATUS_PENDING
                              ? true
                              : false,
                          child: Container(
                            child: widget.orderDataModel.orderStatus ==
                                    STATUS_PENDING
                                ?
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    child: Container(
                                              height:
                                              MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.072,
                                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                                      decoration: const BoxDecoration(
                                        color: colorGreen,
                                        borderRadius:
                                        BorderRadius.only(topLeft: Radius.circular(13.0) ,bottomLeft: Radius.circular(13.0)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.check, color: Colors.white),
                                          SizedBox(width: 3),
                                          // Stack(
                                          //   alignment: Alignment.center,
                                          //   children: [
                                          //     const Icon(Icons.circle,
                                          //         size: 40,
                                          //         color: Color.fromRGBO(
                                          //             234, 234, 234, 1)),
                                          //     SvgPicture.asset(icCheck,
                                          //         height:
                                          //         MediaQuery.of(context)
                                          //             .size
                                          //             .height *
                                          //             0.024,
                                          //         color:
                                          //         const Color.fromRGBO(
                                          //             81, 200, 0, 1))
                                          //   ],
                                          // ),
                                          Text(
                                            "Accept",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      callUpdateStatusApi(
                                          STATUS_ACCEPTED);
                                    },
                                    behavior: HitTestBehavior.opaque,
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    child: Container(
                                              height:
                                              MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.072,
                                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(252, 174, 3, 1),
                                        borderRadius:
                                        BorderRadius.only(topRight: Radius.circular(13.0) ,bottomRight: Radius.circular(13.0)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.close, color: Colors.white),
                                          SizedBox(width: 3),
                                          // Stack(
                                          //   alignment: Alignment.center,
                                          //   children: [
                                          //     const Icon(Icons.circle,
                                          //         size: 40,
                                          //         color: Color.fromRGBO(
                                          //             234, 234, 234, 1)),
                                          //     SvgPicture.asset(icCross,
                                          //         height:
                                          //         MediaQuery.of(context)
                                          //             .size
                                          //             .height *
                                          //             0.024,
                                          //         color:
                                          //         const Color.fromRGBO(
                                          //             252, 174, 3, 1))
                                          //   ],
                                          // ),
                                          Text(
                                            "Decline",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      callUpdateStatusApi(STATUS_DENIED);
                                    },
                                  ),
                                ),
                              ],
                            )
                                : const SizedBox.shrink()
                          ),
                        ),
                        Visibility(
                          visible: widget.orderDataModel.orderStatus ==
                                  STATUS_PENDING
                              ? false
                              : true,
                          child: Container(
                            child: widget.orderDataModel.orderStatus ==
                                    STATUS_PENDING
                                ? const SizedBox()
                                :
                                // : Platform.isAndroid
                                // ?
                                Column(
                                  children: [
                                    GestureDetector(
                                        child: Container(
                                          height: 60,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: colorButtonYellow,
                                            borderRadius:
                                                BorderRadius.circular(13.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                "Print",
                                                style: TextStyle(
                                                    color: colorTextWhite,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Icon(Icons.print,
                                                  color: Colors.white),
                                            ],
                                          ),
                                        ),
                                        onTap: () async {
                                          // callUpdateStatusApi(STATUS_ACCEPTED);
                                          int printCount = ApiBaseHelper.printCount;
                                          print("DestPrint " +
                                              printCount.toString());
                                          clearCache();
                                          _printOrder();
                                          _timer = Timer.periodic(
                                              const Duration(seconds: 3), (timer) {
                                            print("CounterCount " +
                                                mCounter.toString());
                                            if (printCount >
                                                mCounter) {
                                              if (mounted) {
                                                setState(() {
                                                  print("Print Count time");
                                                  _printOrder();
                                                  mCounter++;
                                                });
                                              }
                                            } else {
                                              _timer.cancel();
                                            }
                                          });
                                        },
                                        behavior: HitTestBehavior.opaque,
                                      ),
                                  ],
                                ),
                          ),
                        )
                      ],
                    )),
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset(
                      icOrderCross,
                      height: MediaQuery.of(context).size.height * 0.030,
                    ),
                  ),
                )
              ],
            )),
      ),
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

  Future<void> delayedPrint(String value) async {
    await Future.delayed(const Duration(seconds: 1));
    print('delayedPrint: $value');
  }

  var ip;
  var port;
  var url;
  var jsondata;

  Future<void> _printOrder() async {

    StorageUtil.getData(StorageUtil.keyLoginData, "")!.then((value) async {
      print("Storage Data : $value");
      if (value != null && value != "") {
        LoginData loginData = LoginData.fromJson(jsonDecode(value));

        print('ApiBaseHelper.websiteURL 2');
        print(ApiBaseHelper.websiteURL);

        if (checkString(loginData.wifiPrinterIP) ||
            checkString(loginData.wifiPrinterPort)) {
          showMessage(
              "Add WIFI Printer IP Address and Port number from Setting.",
              context);
        } else {
          try {
            var name = jsonEncode(widget.orderDataModel);
            print("OrderDetill  $name");

            if (ApiBaseHelper.print50mm == true) {

              SunmiPrinter.text(
                widget.orderDataModel.orderDateTime,
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.right),
              );

              SunmiPrinter.text(
                loginData.restaurantName,
                styles: const SunmiStyles(
                    bold: true,
                    underline: false,
                    align: SunmiAlign.center,
                    size: SunmiSize.md),
              );

              SunmiPrinter.text(
                loginData.location,
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              );

              SunmiPrinter.text(
                "Tel.: " + loginData.phoneNumber.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              );

              SunmiPrinter.text(
                "Bestellnummer : " +
                    widget.orderDataModel.orderNumber.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              );

              SunmiPrinter.text(
                widget.orderDataModel.deliveryType.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              );

              SunmiPrinter.text(
                "Bestatigte Ziet : " + widget.orderDataModel.orderTime!,
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              );

              SunmiPrinter.hr();

              SunmiPrinter.text(
                widget.orderDataModel.userDetails!.firstName.toString() +
                    " " +
                    widget.orderDataModel.userDetails!.lastName.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.left),
              );

              SunmiPrinter.text(
                widget.orderDataModel.userDetails!.contact.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.left),
              );

              if (widget.orderDataModel.deliveryType != "PICKUP") {
                SunmiPrinter.text(
                  widget.orderDataModel.userDetails!.address.toString(),
                  styles: const SunmiStyles(
                      bold: true, underline: false, align: SunmiAlign.left),
                );
              }

              if (widget.orderDataModel.deliveryType != "PICKUP") {
                SunmiPrinter.text(
                  widget.orderDataModel.userDetails!.postcode.toString(),
                  styles: const SunmiStyles(
                      bold: true, underline: false, align: SunmiAlign.left),
                );
              }

              SunmiPrinter.hr();

              String quantity = "";
              int sum = 0;
              int sumParse = 0;
              int discount = 0;

              for (var i = 0; i < widget.orderDataModel.itemDetails!.length; i++) {

                ItemDetails itemData = widget.orderDataModel.itemDetails![i];
                discount = itemData.discount!;
                quantity = itemData.quantity!.toString();
                sumParse = int.parse(quantity);
                sum = sum + sumParse;
                print(" QuantityTotal $quantity ");
                print(" QuantitySum $sum ");

                if (discount != 0) {
                  SunmiPrinter.text(
                    itemData.discount.toString() + "% OFF",
                    styles: const SunmiStyles(
                        bold: true, underline: false, align: SunmiAlign.left),
                  );
                } else if (itemData.catDiscount != 0) {
                  SunmiPrinter.text(
                    itemData.catDiscount.toString() + "% OFF",
                    styles: const SunmiStyles(
                        bold: true, underline: false, align: SunmiAlign.left),
                  );
                } else if (itemData.overallDiscount != 0) {
                  SunmiPrinter.text(
                    itemData.overallDiscount.toString() + "% OFF",
                    styles: const SunmiStyles(
                        bold: true, underline: false, align: SunmiAlign.left),
                  );
                }

                SunmiPrinter.row(cols: [
                  SunmiCol(
                      text: itemData.quantity.toString() +
                          "x " +
                          itemData.name.toString(),
                      width: 8,
                      align: SunmiAlign.left),
                  SunmiCol(text: ' ', width: 1, align: SunmiAlign.center),
                  SunmiCol(
                      text: /*itemData.price*/ getAmountWithCurrency(
                          itemData.price.toString()),
                      width: 3,
                      align: SunmiAlign.right),
                ], bold: true);

                if (itemData.option.toString().isNotEmpty) {
                  SunmiPrinter.text(
                    itemData.option.toString(),
                    styles: const SunmiStyles(
                        bold: true, underline: false, align: SunmiAlign.left),
                  );
                }

                if (itemData.toppings!.isNotEmpty) {
                  for (int toppping = 0;
                  toppping < itemData.toppings!.length;
                  toppping++) {
                    Toppings top = itemData.toppings![toppping];
                    SunmiPrinter.text(
                      "+ " +
                          top.toppingCount.toString() +
                          " " +
                          top.name.toString() +
                          " " +
                          " (" +
                          top.price.toString() +
                          ")",
                      styles: const SunmiStyles(
                          bold: true, underline: false, align: SunmiAlign.left),
                    );
                  }
                }
                SunmiPrinter.text(
                  itemData.note.toString(),
                  styles: const SunmiStyles(
                      bold: true, underline: false, align: SunmiAlign.left),
                );
                /*  SunmiPrinter.text(
                  "${defaultValue(itemData.quantity.toString(), "1")} X ${getOptionName(itemData.toppings!, itemData) == "" ? getAmountWithCurrency(itemData.price.toString()) : getAmountWithCurrency(getOptionName(itemData.toppings!, itemData).toString())}",
                  styles: SunmiStyles(
                      bold: true, underline: false, align: SunmiAlign.right),
                );
                SunmiPrinter.hr();*/
              }
              SunmiPrinter.hr();

              if (widget.orderDataModel.deliveryCharge != 0) {
                SunmiPrinter.row(cols: [
                  SunmiCol(
                      text: 'Liefergebuehr : ',
                      width: 8,
                      align: SunmiAlign.left),
                  SunmiCol(text: '', width: 1, align: SunmiAlign.center),
                  SunmiCol(
                      text: widget.orderDataModel.deliveryCharge,
                      width: 3,
                      align: SunmiAlign.right),
                ], bold: true);
              }

              SunmiPrinter.hr();

              SunmiPrinter.row(cols: [
                SunmiCol(text: 'Rabatt : ', width: 4, align: SunmiAlign.left),
                SunmiCol(text: '', width: 4, align: SunmiAlign.center),
                SunmiCol(
                    text: getAmountWithCurrency(defaultValue(
                        widget.orderDataModel.discount.toString(), "0")),
                    width: 4,
                    align: SunmiAlign.right),
              ], bold: true);

              SunmiPrinter.hr();

              SunmiPrinter.row(cols: [
                SunmiCol(text: 'Gesamt : ', width: 4, align: SunmiAlign.left),
                SunmiCol(text: '', width: 4, align: SunmiAlign.center),
                SunmiCol(
                    text: widget.orderDataModel.totalAmount,
                    width: 4,
                    align: SunmiAlign.right),
              ], bold: true);

              SunmiPrinter.hr();

              widget.orderDataModel.note != null && widget.orderDataModel.note != '' && widget.orderDataModel.note != ' '
              ?
              SunmiPrinter.text(
                "Notiz : " + widget.orderDataModel.note.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              )
              : SunmiPrinter()
              ;

              SunmiPrinter.text(
                "Zahlungsmethode : " +
                    widget.orderDataModel.paymentMode.toString(),
                styles: const SunmiStyles(
                    bold: true, underline: false, align: SunmiAlign.center),
              );

              if (widget.orderDataModel.paymentMode == "Online") {
                SunmiPrinter.text(
                  "Bestellung wurde online bezahlt",
                  styles: const SunmiStyles(
                      bold: true, underline: false, align: SunmiAlign.center),
                );
              }

              SunmiPrinter.hr();

              // Test image
              var response = await http.get(Uri.parse('https://api.qrcode-monkey.com/qr/custom?data=${ApiBaseHelper.websiteURL}'));
              if (response.statusCode == 200) {
                // final qrCodeImage = Image.memory(response.bodyBytes);
                // Display the QR code image in your app
                final buffer = response.bodyBytes.buffer;
                final imgData = base64.encode(Uint8List.view(buffer));
                SunmiPrinter.image(imgData);
              }

              SunmiPrinter.emptyLines(3);

            } else {
              platformChannel.invokeMethod('print_order', {
                'name': defaultValue(loginData.restaurantName, ""),
                'phone': defaultValue(loginData.phoneNumber, ""),
                'address': defaultValue(loginData.location, ""),
                'quantity': widget.orderDataModel.itemDetails!.length.toString(),
                'orderData': jsonEncode(widget.orderDataModel),
                'ip_address': defaultValue(loginData.wifiPrinterIP, ""),
                'port_number': defaultValue(loginData.wifiPrinterPort, "")
              });
            }
          } on PlatformException {
            print("PlatformException");
          }
        }
      }
    });
  }

  void clearCache() {
    DefaultCacheManager().emptyCache();
  }

// runCommand() async {

//   final path = Directory("$_orderName");
//   if ((await path.exists())) {
//     // ignore: non_constant_identifier_names
//     Process.run('dir', [], runInShell: true).then((ProcessResultrs) {});
//     print("exist");
//     print(path);
//   } else {
//     print(path);
//     print("not exist");
//   }
// }

// Future<String> get _localPath async {
//   final directory = await getDownloadsDirectory();
//   return directory!.path;
// }

// Future<File> get _localFile async {
//   final path = await _localPath;
//   // final folderName = "orderData";
//   print('$path/$_orderName.xml');
//   return File('$path/$_orderName.xml');
// }

// Future<File> writeCounter(Object counter) async {
//   final file = await _localFile;
//   return file.writeAsString('$counter');
// }
}
