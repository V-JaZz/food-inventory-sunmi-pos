import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_inventory/UI/OrderHistory/order_history_date_model.dart';
import 'package:food_inventory/UI/order/dialog_order_details.dart';
import 'package:food_inventory/UI/order/model/order_list_response_model.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

typedef OrderResponseFunc = void Function(String, SummaryData);

// ignore: must_be_immutable
class OrderHistory extends StatefulWidget {
  OrderResponseFunc onOrderResponse;
  String name;
  OrderHistory({Key? key, required this.onOrderResponse, required this.name})
      : super(key: key);
  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  bool isToday = true, isHistory = false;
  bool showReport = false;
  bool orders = false;
  List<OrderDataModel> _orderList = [];
  List<OrderHistoryData> _historyList = [];
  bool isDataLoad = false;

  io.Socket socket =
  io.io("https://test-foodinventoryde.herokuapp.com", <String, dynamic>{
  // IO.io("https://orderonline.foodinventory.co.uk", <String, dynamic>{
    "transports": ["websocket"],
    'autoConnect': false
  });
  bool isSocketOrderAdded = false;
  String email = "";
  OrderListResponseModel model = OrderListResponseModel.fromJson({});
  String localIp = '';
  List<String> devices = [];
  bool isDiscovering = false;
  int found = -1;
  TextEditingController portController = TextEditingController(text: '9100');
  late String acceptedOrder, declinedOrder, orderReceived, cash, online, total;
  @override
  void initState() {
    super.initState();
    _orderList = [];
    _historyList = [];
    getOrderList(true);
    StorageUtil.getData(StorageUtil.keyEmail, "")!.then((email) async {
      this.email = email;
      socket.connect();
      socket.onConnect((_) {
        socket.emit("joinOwner", email);
      });
      listenToSocket();
    });
    isToday = false;
    isHistory = true;
    //stopOrderUpdateTimer();
    getHistoryDateData();
  }

  @override
  void dispose() {
    super.dispose();
    // socket.emit("leaveOwner", this.email);
    // socket.clearListeners();
    // socket.disconnect();
    isSocketOrderAdded = false;
  }

  listenToSocket() {
    socket.on("onOrderAdded", (response) {
      isSocketOrderAdded = true;
      model = OrderListResponseModel.fromJson(response);
      getOrderList(false);
    });
  }

  getOrderList(bool isLoad) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
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
                .getwith(ApiBaseHelper.getOrders + body, token, restaurantId);
            model = OrderListResponseModel.fromJson(
                ApiBaseHelper().returnResponse(context, response));
          }
          isSocketOrderAdded = false;

          if (isLoad) {
            setState(() {
              isDataLoad = false;
            });
          }
          if (model.success!) {
            if (model.data!.isEmpty) {
              setState(() {
                _orderList = [];
                acceptedOrder = model.summaryData!.acceptedOrder!;
                declinedOrder = model.summaryData!.declinedOrder!;
                orderReceived = model.summaryData!.orderReceived!;
                cash = model.summaryData!.cashOrderAmount!;
                online = model.summaryData!.onlineOrderAmount!;
                total = model.summaryData!.totalOrderAmount!;
              });
            } else {
              setState(() {
                _orderList = model.data!;
                acceptedOrder = model.summaryData!.acceptedOrder!;
                declinedOrder = model.summaryData!.declinedOrder!;
                orderReceived = model.summaryData!.orderReceived!;
                cash = model.summaryData!.cashOrderAmount!;
                online = model.summaryData!.onlineOrderAmount!;
                total = model.summaryData!.totalOrderAmount!;
              });
            }
            widget.onOrderResponse(
                selectedDate,
                model.summaryData == null
                    ? SummaryData(
                        sId: "0",
                        acceptedOrder: "0",
                        declinedOrder: "0",
                        orderReceived: "0",
                        cashOrderAmount: "0",
                        onlineOrderAmount: "0",
                        totalOrderAmount: "0")
                    : model.summaryData!);
            if (isLoad) {
              if (model.summaryData != null) {
                var pendingOrder = int.parse(defaultValue(
                    model.summaryData?.pendingOrder.toString(), "0"));
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
          if (mounted) {
            setState(() {
              isDataLoad = false;
            });
          }
        }
      });
    });
  }

  getHistoryDateData() async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        if (_historyList.isEmpty) {
          setState(() {
            isDataLoad = true;
          });
        }
        try {
          final response = await ApiBaseHelper()
              .getwith(ApiBaseHelper.orderHistory, token, restaurantId);
          OrderHistoryDateModel model = OrderHistoryDateModel.fromJson(
              ApiBaseHelper().returnResponse(context, response));
          if (_historyList.isEmpty) {
            setState(() {
              isDataLoad = false;
            });
          }
          if (model.success!) {
            if (model.data!.isEmpty) {
              setState(() {
                _historyList = [];
              });
            } else {
              setState(() {
                _historyList = model.data!;
              });
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
    return Scaffold(
      backgroundColor: colorBackgroundyellow,
      body: Column(
        children: [
          Expanded(child: orders ? orderListData() : historyCalender()),
          isDataLoad
              ? const SizedBox()
              : showReport
                  ? Container(
                      decoration: BoxDecoration(
                        color: colorTextWhite,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10, left: 20, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "Today's Status",
                                  style: TextStyle(
                                      color: colorTextBlack,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: "Accepted Order :- ",
                                            style: const TextStyle(
                                                color: colorTextBlack,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                            children: [
                                          TextSpan(
                                              text: acceptedOrder,
                                              style: const TextStyle(
                                                  color: colorButtonYellow,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700)),
                                        ])),
                                    RichText(
                                        text: TextSpan(
                                            text: "Declined Order :- ",
                                            style: const TextStyle(
                                                color: colorTextBlack,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                            children: [
                                          TextSpan(
                                              text: declinedOrder,
                                              style: const TextStyle(
                                                  color: colorButtonYellow,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700)),
                                        ])),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: "Order Received :- ",
                                            style: const TextStyle(
                                                color: colorTextBlack,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                            children: [
                                          TextSpan(
                                              text: orderReceived == 'null'
                                                  ? "0"
                                                  : orderReceived,
                                              style: const TextStyle(
                                                  color: colorButtonYellow,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700)),
                                        ])),
                                    RichText(
                                        text: TextSpan(
                                            text: "Cash :- ",
                                            style: const TextStyle(
                                                color: colorTextBlack,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                            children: [
                                          TextSpan(
                                              text: cash,
                                              style: const TextStyle(
                                                  color: colorButtonYellow,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700)),
                                        ])),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: "Online :- ",
                                            style: const TextStyle(
                                                color: colorTextBlack,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                            children: [
                                          TextSpan(
                                              text: online.replaceAll('.', ','),
                                              style: const TextStyle(
                                                  color: colorButtonYellow,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700)),
                                        ])),
                                    RichText(
                                        text: TextSpan(
                                            text: "Total :- ",
                                            style: const TextStyle(
                                                color: colorTextBlack,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                            children: [
                                          TextSpan(
                                              text: total.replaceAll('.', ','),
                                              style: const TextStyle(
                                                  color: colorButtonYellow,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700)),
                                        ])),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20, left: 20),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isToday = true;
                                      isHistory = false;
                                      orders = !orders;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: colorButtonYellow,
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                        orders
                                            ? "Select another date"
                                            : "Full Details",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: colorTextWhite,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox()
        ],
      ),
    );
  }

  Widget historyCalender() {
    return SafeArea(
        child: Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 10, right: 40, top: 11, bottom: 11),
          decoration: const BoxDecoration(color: colorTextBlack),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Row(
                children: [
                  GestureDetector(
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onTap: () {
                      setState(() {
                        selectedDate = "";
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    selectedDate.isEmpty
                        ? "Today"
                        : getOrderStatusDate(selectedDate),
                    style: const TextStyle(
                        color: colorTextWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            shrinkWrap: true,
            // padding: EdgeInsets.only(left: 38, right: 35, bottom: 29, top: 29),
            children: [
              TableCalendar(
                availableGestures: AvailableGestures.horizontalSwipe,
                calendarStyle: const CalendarStyle(isTodayHighlighted: false),
                daysOfWeekHeight: 30,
                rowHeight: 59,
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    final text = DateFormat.E().format(day);
                    return Container(
                      height: 100,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        top: 3,
                        bottom: 3,
                      ),
                      margin:
                          const EdgeInsets.only(right: 1, left: 1, bottom: 1),
                      decoration: const BoxDecoration(color: colorButtonBlue),
                      child: Text(
                        text,
                        maxLines: 1,
                        style: const TextStyle(
                            color: colorTextWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    );
                  },
                  defaultBuilder: (context, day, focusedDay) {
                    final text = DateFormat("dd").format(day);
                    String totalAmountOnDay = "";
                    final stCheckDay = DateFormat("yyyy-MM-dd").format(day);
                    if (_historyList.isNotEmpty) {
                      for (OrderHistoryData history in _historyList) {
                        if (history.sId == stCheckDay) {
                          totalAmountOnDay =
                              defaultValue(history.totalOrderAmount, "");
                        }
                      }
                    }
                    var now = DateTime.now();
                    var isToday = false;
                    if (getSendableDate(day) == getSendableDate(now)) {
                      isToday = true;
                    }
                    return Container(
                      height: 58,
                      decoration: BoxDecoration(
                        color: selectedDate == getSendableDate(day)
                            ? const Color(0xff51C800)
                            : selectedDate.isEmpty && isToday
                                ? colorGreen
                                : colorTextWhite,
                      ),
                      // border:
                      //     Border.all(color: colorDividerGreen, width: 1)),
                      margin: const EdgeInsets.all(1),
                      child: Stack(
                        children: [
                          Positioned(
                            child: Text(
                              text,
                              style: TextStyle(
                                  color: selectedDate == getSendableDate(day)
                                      ? colorTextWhite
                                      : selectedDate.isEmpty && isToday
                                          ? colorTextWhite
                                          : colorTextBlack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            bottom: 40,
                            left: 10,
                          ),
                          Positioned(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  icHistoryCal,
                                  height: 9,
                                  width: 9,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  getAmountWithCurrencyH(totalAmountOnDay)
                                      .split(".")
                                      .first,
                                  style: TextStyle(
                                      color:
                                          selectedDate == getSendableDate(day)
                                              ? colorTextWhite
                                              : selectedDate.isEmpty && isToday
                                                  ? colorTextWhite
                                                  : colorButtonYellow,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            top: 25,
                            right: 08,
                          )
                        ],
                      ),
                    );
                  },
                  outsideBuilder: (context, day, focusedDay) {
                    final text = DateFormat("d").format(day);
                    return Container(
                      height: 58,
                      decoration: const BoxDecoration(color: colorTextWhite),
                      margin: const EdgeInsets.all(1),
                      child: Stack(
                        children: [
                          Positioned(
                            child: Text(
                              text,
                              style: const TextStyle(
                                  color: colorTextGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            bottom: 40,
                            left: 10,
                          ),
                        ],
                      ),
                    );
                  },
                  disabledBuilder: (context, day, focusedDay) {
                    final text = DateFormat("d").format(day);
                    return Container(
                      height: 58,
                      // decoration: BoxDecoration(color: colorTextWhite),
                      margin: const EdgeInsets.all(1),
                      child: Stack(
                        children: [
                          Positioned(
                            child: Text(
                              text,
                              style: const TextStyle(
                                  color: colorTextGrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            bottom: 40,
                            left: 10,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                headerVisible: false,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.now(),
                focusedDay: _focusedDay,
                dayHitTestBehavior: HitTestBehavior.opaque,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                    // isToday = true;
                    // isHistory = false;
                    showReport = true;
                    var now = DateTime.now();
                    // if (selectedDay.difference(now).inDays == 0) {
                    if (getSendableDate(selectedDay) == getSendableDate(now)) {
                      selectedDate = "";
                    } else {
                      selectedDate = getSendableDate(selectedDay);
                    }
                  });
                  getOrderList(true);
                },
              ),
            ],
          ),
        )
      ],
    ));
  }

  String truncateString(String data, int length) {
    return (data.length >= length) ? data.substring(0, length) : data;
  }

  DateTime _focusedDay = DateTime.now();
  String day = "", month = "", year = "";

  // DateTime selectedHistoryDate = DateTime.now();

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: _focusedDay,
  //       firstDate: DateTime(1990),
  //       lastDate: DateTime.now());
  //   if (picked != null && picked != _focusedDay) {
  //     setState(() {
  //       // selectedHistoryDate = picked;
  //       _focusedDay = picked;
  //       if (_focusedDay.day < 10) {
  //         day = "0${_focusedDay.day.toString()}";
  //       } else {
  //         day = _focusedDay.day.toString();
  //       }
  //       if (_focusedDay.month < 10) {
  //         month = "0${_focusedDay.month.toString()}";
  //       } else {
  //         month = _focusedDay.month.toString();
  //       }
  //       year = _focusedDay.year.toString();
  //     });
  //   }
  // }

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
            });
            getOrderList(true);
          },
        );
      },
    );
  }

  Widget orderListData() {
    return isDataLoad
        ? const Center(
            child: CircularProgressIndicator(
              strokeWidth: 5.0,
              color: colorGreen,
            ),
          )
        : Column(
            // shrinkWrap: true,
            children: [
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 40, top: 11, bottom: 11),
                  decoration: const BoxDecoration(color: colorTextBlack),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          GestureDetector(
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onTap: () {
                              setState(() {
                                selectedDate = "";
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            selectedDate.isEmpty
                                ? "Today"
                                : getOrderStatusDate(selectedDate),
                            style: const TextStyle(
                                color: colorTextWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _orderList.length,
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  itemBuilder: (context, index) {
                    if (_orderList[index].orderStatus == STATUS_PENDING) {
                    } else {
                    }

                    OrderDataModel orderObj = _orderList[index];
                    return GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        // margin: const EdgeInsets.only(left: 5, right: 5, top: 10.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'Order: ',
                                      style: const TextStyle(
                                          color: colorTextBlack,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: truncateString(
                                                orderObj.orderNumber!
                                                    .trimRight(),
                                                16),
                                            style: const TextStyle(
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.014,
                                        color: colorButtonYellow,
                                      ),
                                    ),
                                    const SizedBox(width: 05),
                                    Text(
                                      "${orderObj.orderDateTime}",
                                      softWrap: false,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                          color: colorTextBlack,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ])
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Delivery Time: ',
                                          style: const TextStyle(
                                              color: colorTextBlack,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    orderObj.deliveryDatetime ??
                                                        "",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 05),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Delivery Type: ',
                                          style: const TextStyle(
                                              color: colorTextBlack,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: orderObj.deliveryType,
                                                style: const TextStyle(
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
                                        style: const TextStyle(
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
                      onTap: () {
                        showOrderDialog(orderObj, widget.name);
                      },
                      behavior: HitTestBehavior.opaque,
                    );
                  },
                ),
              ),
            ],
          );
  }
}
