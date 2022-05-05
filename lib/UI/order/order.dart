import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/order/dialog_order_details.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import '../../constant/app_util.dart';
import '../../constant/image.dart';
import 'model/order_list_response_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  List<OrderDataModel> _orderList = [];
  bool isDataLoad = false;
  IO.Socket socket =
      IO.io("https://demo-foodinventoryde.herokuapp.com", <String, dynamic>{
    "transports": ["websocket"],
    'autoConnect': false
  });
  bool isSocketOrderAdded = false;
  String email = "";
  OrderListResponseModel model = OrderListResponseModel.fromJson({});
  String truncateString(String data, int length) {
    return (data.length >= length) ? '${data.substring(0, length)}' : data;
  }

  String localIp = '';
  List<String> devices = [];
  bool isDiscovering = false;
  int found = -1;
  TextEditingController portController = TextEditingController(text: '9100');
  @override
  void initState() {
    super.initState();
    _orderList = [];
    print('inside initState');
    getOrderList(true);
    StorageUtil.getData(StorageUtil.keyEmail, "")!.then((email) async {
      this.email = email;
      print("Inside initLocalStorage " + email);
      socket.connect();
      socket.onConnect((_) {
        print("Connected");
        socket.emit("joinOwner", email);
      });
      listenToSocket();
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("inside dispose method...disconnecting");
    // socket.emit("leaveOwner", this.email);
    // socket.clearListeners();
    // socket.disconnect();
    isSocketOrderAdded = false;
  }

  listenToSocket() {
    socket.on("onOrderAdded", (response) {
      print("Socket response");
      isSocketOrderAdded = true;
      model = OrderListResponseModel.fromJson(response);
      getOrderList(false);
    });
  }

  getOrderList(bool isLoad) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        print("restauranttoday");
        print(restaurantId);
        if (isLoad) {
          if (mounted) {
            setState(() {
              isDataLoad = true;
            });
          }
        }
        try {
          String params = "";
          if (selectedDate.isNotEmpty) {
            params = "date=$selectedDate";
          }

          String body = "";
          if (params.isNotEmpty) {
            body = "?$params";
          }

          if (!isSocketOrderAdded) {
            final response = await ApiBaseHelper()
                .getwith(ApiBaseHelper.getOrders, token, restaurantId);
            model = OrderListResponseModel.fromJson(
                ApiBaseHelper().returnResponse(context, response));
          }
          isSocketOrderAdded = false;

          print("todayresponfirst");
          print("todayresponfirst");
          print(model.data.toString());
          if (isLoad) {
            setState(() {
              isDataLoad = false;
            });
          }
          if (model.success!) {
            print("todayresponse");
            print(model.data.toString());
            if (model.data!.isEmpty) {
              setState(() {
                _orderList = [];
              });
            } else {
              setState(() {
                _orderList = model.data!;
              });
            }
            // widget.onOrderResponse(
            //     selectedDate,
            //     model.summaryData == null
            //         ? SummaryData(
            //             sId: "0",
            //             acceptedOrder: "0",
            //             declinedOrder: "0",
            //             orderReceived: "0",
            //             cashOrderAmount: "0",
            //             onlineOrderAmount: "0",
            //             totalOrderAmount: "0")
            //         : model.summaryData!);
            if (isLoad) {
              if (model.summaryData != null) {
                var pendingOrder = int.parse(defaultValue(
                    model.summaryData?.pendingOrder.toString(), "0"));
                print("OrderPendngNAme $pendingOrder");
                if (pendingOrder > 0) {
                  // FlutterRingtonePlayer.play(
                  //   android: AndroidSounds.notification,
                  //   ios: IosSounds.glass,
                  //   looping: false, // Android only - API >= 28
                  //   volume: 1.0, // Android only - API >= 28
                  //   asAlarm: false, // Android only - all APIs
                  // );
                }
              }
            }
          }
        } catch (e) {
          print(e.toString());
          if (mounted) {
            setState(() {
              isDataLoad = false;
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: colorBackgroundyellow,
        child: isDataLoad
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  color: colorGreen,
                ),
              )
            : ListView.builder(
                itemCount: _orderList.length,
                itemBuilder: (BuildContext context, index) {
                  String status = "";
                  if (_orderList[index].orderStatus == STATUS_PENDING) {
                    status = "New Order";
                  } else {
                    status = _orderList[index].orderStatus![0].toUpperCase() +
                        _orderList[index]
                            .orderStatus!
                            .substring(1)
                            .toLowerCase();
                  }

                  OrderDataModel orderObj = _orderList[index];
                  return GestureDetector(
                    onTap: () {
                      showOrderDialog(orderObj, "VVVVVVV");
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      // margin: const EdgeInsets.only(left: 5, right: 5, top: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Order: ',
                                    style: TextStyle(
                                        color: colorTextBlack,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: truncateString(
                                              "${orderObj.orderNumber!.trimRight()}",
                                              16),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ],
                                  ),
                                ),
                                Row(children: [
                                  GestureDetector(
                                    child: SvgPicture.asset(
                                      icClock,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.014,
                                      width: MediaQuery.of(context).size.width *
                                          0.014,
                                      color: colorButtonYellow,
                                    ),
                                  ),
                                  SizedBox(width: 05),
                                  Text(
                                    "${orderObj.orderDateTime}",
                                    softWrap: false,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        color: colorTextBlack,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                ])
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'Delivery Time: ',
                                        style: TextStyle(
                                            color: colorTextBlack,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  "${orderObj.deliveryDatetime ?? ""}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 05),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Delivery Type: ',
                                        style: TextStyle(
                                            color: colorTextBlack,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: orderObj.deliveryType,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 40,
                                          color: orderObj.orderStatus ==
                                                  STATUS_PENDING
                                              ? colorButtonYellow
                                              : orderObj.orderStatus ==
                                                      STATUS_ACCEPTED
                                                  ? colorGreen
                                                  : orderObj.orderStatus ==
                                                          STATUS_DENIED
                                                      ? colorButtonYellow
                                                      : colorButtonYellow,
                                        ),
                                        SvgPicture.asset(
                                            orderObj.orderStatus ==
                                                    STATUS_PENDING
                                                ? icEye
                                                : orderObj.orderStatus ==
                                                        STATUS_ACCEPTED
                                                    ? icCheck
                                                    : orderObj.orderStatus ==
                                                            STATUS_DENIED
                                                        ? icCross
                                                        : icEye,
                                            height: 12,
                                            width: 18),
                                      ],
                                    ),
                                    Text(
                                      orderObj.orderStatus == STATUS_PENDING
                                          ? "View"
                                          : orderObj.orderStatus ==
                                                  STATUS_ACCEPTED
                                              ? "Accepted"
                                              : orderObj.orderStatus ==
                                                      STATUS_DENIED
                                                  ? "Declined"
                                                  : "View",
                                      style: TextStyle(
                                          color: colorTextBlack,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }));
  }

  void showOrderDialog(OrderDataModel orderDataModel, String name) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (buildContext) {
        return OrderDetailsDialog(
          orderDataModel: orderDataModel,
          name: name,
          onOrderUpdate: () {
            setState(() {
              _orderList = [];
              getOrderList(true);
            });
            // _player.stop();
          },
        );
      },
    );
  }
}
