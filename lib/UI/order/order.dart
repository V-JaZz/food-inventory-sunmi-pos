// ignore_for_file: avoid_print, unused_local_variable, unnecessary_string_interpolations, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/order/dialog_order_details.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import '../../constant/app_util.dart';
import '../../constant/image.dart';
import '../../model/common_model.dart';
import '../OrderHistory/order_history.dart';
import 'model/order_list_response_model.dart';

late _OrderState orderState;

// ignore: must_be_immutable
class Order extends StatefulWidget {
  OrderResponseFunc onOrderResponse;
  String name;

  Order({Key? key, required this.onOrderResponse, required this.name}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<Order> createState() {
    orderState = _OrderState();
    return orderState;
  }
}

List<OrderDataModel> orderList = [];

class _OrderState extends State<Order> {
  bool isDataLoad = false;

  //https://foodinventoryukvariant.herokuapp.com/
  //https://demo-foodinventoryde.herokuapp.com
  // static const platformChannel =
  //     MethodChannel('com.suresh.foodinventory/orderprint');

  bool isSocketOrderAdded = false;
  String email = "";
  late OrderDataModel orderDataModel;
  OrderListResponseModel model = OrderListResponseModel.fromJson({});

  AutoPrintOrderModel autoPrintOrderModel = AutoPrintOrderModel.fromJson({});

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
    orderList = [];
    print('inside initState');
    getOrderList(true);

    /*  StorageUtil.getData(StorageUtil.keyEmail, "")!.then((email) async {
      this.email = email;
      print("Inside initLocalStorage " + email);
      socket.connect();
      socket.onConnect((_) {
        print("Connected");
        socket.emit("joinOwner", email);
      });
      listenToSocket();
    });*/

    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyEmail, "")!.then((email) async {
        print("Inside initLocalStorage " + email);
        this.email = email;


        // socket.emit("leaveOwner", this.email);
        // socket.clearListeners();
        // socket.disconnect();

        // socket.open();
        // socket.connect();
        // socket.onConnect((_) {
        //   print("Connected O");
        //   socket.emit("joinOwner", email);
        // });
        //   listenToSocket(token);
        // getOrderList(false);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("inside dispose method...disconnecting");
    // socket.emit("leaveOwner", this.email);
    // socket.clearListeners();
    // socket.disconnect();
    // socket.destroy();
    // socket.dispose();
    // socket.close();
    isSocketOrderAdded = false;
  }

  String orderId = '';

  // listenToSocket(token) {
  //   print("Socket Called O");
  //
  //   Future.delayed(const Duration(seconds: 1),() async {
  //   socket.on("onAutoPrintOrder", (response) async {
  //
  //       if (ApiBaseHelper.autoAccept == true) {
  //         print('---Auto Print Order Response O---');
  //         print(response.toString());
  //         orderId = response;
  //         await changeOrderStatus(STATUS_ACCEPTED, orderId);
  //         getOrderListTwo(false);
  //         print("orderID" + orderId);
  //
  //       }
  //
  //   });
  //
  //   },);
  //
  //   socket.on("onOrderAdded", (response) async {
  //     print("Socket Response Data Order O " + response.toString());
  //     if (ApiBaseHelper.autoAccept == false) {
  //         print("Socket response O");
  //         isSocketOrderAdded = true;
  //         model = OrderListResponseModel.fromJson(response);
  //         getOrderList(false);
  //     }
  //   });
  // }

  final ApiBaseHelper _helper = ApiBaseHelper();

  changeOrderStatus(String status, orderId) {
    print("Change Order Status qq");
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((value) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        // Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
        try {
          final response = await _helper.put(
              ApiBaseHelper.updateorderstatus + "/" + orderId,
              jsonEncode(<String, String>{'orderStatus': status}),
              value,
              restaurantId);
          CommonModel model =
          CommonModel.fromJson(_helper.returnResponse(context, response));
          // Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          if (model.success!) {
            ApiBaseHelper.pending = ApiBaseHelper.pending - 1;
            if (ApiBaseHelper.pending < 1) {
              // playSound();
              ApiBaseHelper.orderbool = true;
            }
            // Navigator.pop(context);
            // widget.onOrderUpdate();
          } else {
            showMessage(model.message!, context);
          }
        } catch (e) {
          print(e.toString());
          // Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        }
      });
    });
  }

  getOrderListTwo(bool isLoad) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      StorageUtil.getData(StorageUtil.keyRestaurantId, "")!
          .then((restaurantId) async {
        print("Change Order Done");

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

          // if (!isSocketOrderAdded) {
          await Future.delayed(const Duration(seconds: 3), () async {
            print("Change Order Api");
            final response = await ApiBaseHelper()
                .getwith(ApiBaseHelper.getOrders, token, restaurantId);
            model = OrderListResponseModel.fromJson(
                ApiBaseHelper().returnResponse(context, response));
          });
          // }
          // isSocketOrderAdded = false;
          print("todayresponfirst");
          print("todayresponfirst");
          // print(model.data.toString());
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
                orderList = [];
              });
            } else {
              setState(() {
                orderList = model.data!;
                for (int i = 0; orderList.length > i; i++) {
                  setState(() {
                    orderDataModel = orderList[i];
                    print("ORDER MODEL: " + orderDataModel.toString());
                  });
                }
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
                print("OrderPendngNAme $pendingOrder");
                if (pendingOrder > 0) {}
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
                orderList = [];
              });
            } else {
              setState(() {
                orderList = model.data!;
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

  void showOrderDialog(OrderDataModel orderDataModel, String name) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (buildContext) {
        return OrderDetailsDialog(
          orderDataModel: orderDataModel,
          name: name,
          onOrderUpdate: () {
            print("OrderAccepted1 CallBack");
            setState(() {
              print("OrderAccepted CallBack");
              orderList = [];
              getOrderList(true);
            });
            // _player.stop();
          },
        );
      },
    );
  }

  // getAutoPrintOrder(token, orderId) async {
  //
  //   Future.delayed(const Duration(milliseconds: 3000), () {
  //
  //     int mCounter = 0;
  //     _timer = Timer.periodic(
  //         const Duration(seconds: 3), (timer) async {
  //
  //       if (ApiBaseHelper.printCount > mCounter) {
  //         if (mounted) {
  //           await _printOrder(orderList[0]);
  //           mCounter++;
  //         }
  //       } else {
  //         _timer.cancel();
  //       }
  //     });
  //   });
  //
  // }
  //
  // Future<void> _printOrder(OrderDataModel orderDataModel) async {
  //   StorageUtil.getData(StorageUtil.keyLoginData, "")!.then((value) async {
  //     print("Storage Data : $value");
  //     if (value != null && value != "") {
  //       LoginData loginData = LoginData.fromJson(jsonDecode(value));
  //
  //       if (checkString(loginData.wifiPrinterIP) ||
  //           checkString(loginData.wifiPrinterPort)) {
  //         showMessage(
  //             "Add WIFI Printer IP Address and Port number from Setting.",
  //             context);
  //       } else {
  //         try {
  //           var name = jsonEncode(orderDataModel);
  //           print("OrderDetill  $name");
  //
  //           if (ApiBaseHelper.print50mm == true) {
  //             // Test regular text
  //             /*     SunmiPrinter.hr();
  //           SunmiPrinter.text(
  //             'Test Sunmi Printer',
  //             styles: SunmiStyles(align: SunmiAlign.center),
  //           );
  //           SunmiPrinter.hr();*/
  //
  //             // Test align
  //             /*SunmiPrinter.text(
  //             'left',
  //             styles: SunmiStyles(bold: true, underline: true),
  //           );
  //           SunmiPrinter.text(
  //             'center',
  //             styles:
  //             SunmiStyles(bold: true, underline: true, align: SunmiAlign.center),
  //           );*/
  //             SunmiPrinter.text(
  //               orderDataModel.orderDateTime,
  //               styles: const SunmiStyles(
  //                   bold: true, underline: false, align: SunmiAlign.right),
  //             );
  //
  //             SunmiPrinter.text(
  //               loginData.restaurantName,
  //               styles: const SunmiStyles(
  //                   bold: true,
  //                   underline: false,
  //                   align: SunmiAlign.center,
  //                   size: SunmiSize.md),
  //             );
  //
  //             SunmiPrinter.text(
  //               loginData.location,
  //               styles: const SunmiStyles(
  //                   bold: true, underline: false, align: SunmiAlign.center),
  //             );
  //
  //             SunmiPrinter.text(
  //               "Tel.: " + loginData.phoneNumber.toString(),
  //               styles: const SunmiStyles(
  //                   bold: true, underline: false, align: SunmiAlign.center),
  //             );
  //
  //             SunmiPrinter.text(
  //               "Bestellnummer : " +
  //                   orderDataModel.orderNumber.toString(),
  //               styles: const SunmiStyles(
  //                   bold: true, underline: false, align: SunmiAlign.center),
  //             );
  //
  //             SunmiPrinter.text(
  //               orderDataModel.deliveryType.toString(),
  //               styles: const SunmiStyles(
  //                   bold: true, underline: false, align: SunmiAlign.center),
  //             );
  //
  //             SunmiPrinter.text(
  //               "Bestatigte Ziet : " + orderDataModel.orderTime!,
  //               styles: const SunmiStyles(
  //                   bold: true, underline: false, align: SunmiAlign.center),
  //             );
  //
  //             /*  SunmiPrinter.row(cols: [
  //               SunmiCol(text: 'Auftragsart', width: 5, align: SunmiAlign.left),
  //               SunmiCol(text: '', width: 2, align: SunmiAlign.center),
  //               SunmiCol(
  //                   text: widget.orderDataModel.deliveryType,
  //                   width: 5,
  //                   align: SunmiAlign.right),
  //             ], bold: true);*/
  //
  //             /*SunmiPrinter.row(cols: [
  //               SunmiCol(text: 'Lieferzeit ', width: 5, align: SunmiAlign.left),
  //               SunmiCol(text: '', width: 2, align: SunmiAlign.center),
  //               SunmiCol(
  //                   text: widget.orderDataModel.orderTime,
  //                   width: 5,
  //                   align: SunmiAlign.right),
  //             ], bold: true);*/
  //
  //             /* SunmiPrinter.row(cols: [
  //               SunmiCol(
  //                   text: 'Zahlungsmethode', width: 5, align: SunmiAlign.left),
  //               SunmiCol(text: '', width: 2, align: SunmiAlign.center),
  //               SunmiCol(
  //                   text: widget.orderDataModel.paymentMode,
  //                   width: 5,
  //                   align: SunmiAlign.right),
  //             ], bold: true);*/
  //
  //             SunmiPrinter.hr();
  //             SunmiPrinter.text(
  //               orderDataModel.userDetails!.firstName.toString() +
  //                   " " +
  //                   orderDataModel.userDetails!.lastName.toString(),
  //               styles: const SunmiStyles(
  //                   bold: true, underline: false, align: SunmiAlign.left),
  //             );
  //
  //             SunmiPrinter.text(
  //               orderDataModel.userDetails!.contact.toString(),
  //               styles: const SunmiStyles(
  //                   bold: true, underline: false, align: SunmiAlign.left),
  //             );
  //
  //             if (orderDataModel.deliveryType != "PICKUP") {
  //               SunmiPrinter.text(
  //                 orderDataModel.userDetails!.address.toString(),
  //                 styles: const SunmiStyles(
  //                     bold: true, underline: false, align: SunmiAlign.left),
  //               );
  //             }
  //             SunmiPrinter.hr();
  //
  //             String quantity = "";
  //             int sum = 0;
  //             int sumParse = 0;
  //             int discount = 0;
  //             for (var i = 0;
  //             i < orderDataModel.itemDetails!.length;
  //             i++) {
  //               ItemDetails itemData = orderDataModel.itemDetails![i];
  //               discount = itemData.discount!;
  //               quantity = itemData.quantity!.toString();
  //               sumParse = int.parse(quantity);
  //               sum = sum + sumParse;
  //               print(" QuantityTotal $quantity ");
  //               print(" QuantitySum $sum ");
  //               if (discount != 0) {
  //                 SunmiPrinter.text(
  //                   itemData.discount.toString() + "% OFF",
  //                   styles: const SunmiStyles(
  //                       bold: true, underline: false, align: SunmiAlign.left),
  //                 );
  //               } else if (itemData.catDiscount != 0) {
  //                 SunmiPrinter.text(
  //                   itemData.catDiscount.toString() + "% OFF",
  //                   styles: const SunmiStyles(
  //                       bold: true, underline: false, align: SunmiAlign.left),
  //                 );
  //               } else if (itemData.overallDiscount != 0) {
  //                 SunmiPrinter.text(
  //                   itemData.overallDiscount.toString() + "% OFF",
  //                   styles: const SunmiStyles(
  //                       bold: true, underline: false, align: SunmiAlign.left),
  //                 );
  //               }
  //
  //               SunmiPrinter.row(cols: [
  //                 SunmiCol(
  //                     text: itemData.quantity.toString() +
  //                         "x " +
  //                         itemData.name.toString(),
  //                     width: 7,
  //                     align: SunmiAlign.left),
  //                 SunmiCol(text: '', width: 1, align: SunmiAlign.center),
  //                 SunmiCol(
  //                     text: /*itemData.price*/ getAmountWithCurrency(
  //                         itemData.price.toString()),
  //                     width: 4,
  //                     align: SunmiAlign.right),
  //               ], bold: true);
  //
  //               if (itemData.option.toString().isNotEmpty) {
  //                 SunmiPrinter.text(
  //                   itemData.option.toString(),
  //                   styles: const SunmiStyles(
  //                       bold: true, underline: false, align: SunmiAlign.left),
  //                 );
  //               }
  //
  //               if (itemData.toppings!.isNotEmpty) {
  //                 for (int toppping = 0;
  //                 toppping < itemData.toppings!.length;
  //                 toppping++) {
  //                   Toppings top = itemData.toppings![toppping];
  //                   SunmiPrinter.text(
  //                     "+ " +
  //                         top.toppingCount.toString() +
  //                         " " +
  //                         top.name.toString() +
  //                         " " +
  //                         " (" +
  //                         top.price.toString() +
  //                         ")",
  //                     styles: const SunmiStyles(
  //                         bold: true, underline: false, align: SunmiAlign.left),
  //                   );
  //                 }
  //               }
  //               SunmiPrinter.text(
  //                 itemData.note.toString(),
  //                 styles: const SunmiStyles(
  //                     bold: true, underline: false, align: SunmiAlign.left),
  //               );
  //               /*  SunmiPrinter.text(
  //                 "${defaultValue(itemData.quantity.toString(), "1")} X ${getOptionName(itemData.toppings!, itemData) == "" ? getAmountWithCurrency(itemData.price.toString()) : getAmountWithCurrency(getOptionName(itemData.toppings!, itemData).toString())}",
  //                 styles: SunmiStyles(
  //                     bold: true, underline: false, align: SunmiAlign.right),
  //               );
  //               SunmiPrinter.hr();*/
  //             }
  //             SunmiPrinter.hr();
  //
  //             if (orderDataModel.deliveryCharge != 0) {
  //               SunmiPrinter.row(cols: [
  //                 SunmiCol(
  //                     text: 'Liefergebuehr : ',
  //                     width: 8,
  //                     align: SunmiAlign.left),
  //                 SunmiCol(text: '', width: 1, align: SunmiAlign.center),
  //                 SunmiCol(
  //                     text: orderDataModel.deliveryCharge,
  //                     width: 3,
  //                     align: SunmiAlign.right),
  //               ], bold: true);
  //             }
  //
  //             /*SunmiPrinter.row(cols: [
  //               SunmiCol(text: 'Rabatt : ', width: 7, align: SunmiAlign.left),
  //               SunmiCol(text: '', width: 2, align: SunmiAlign.center),
  //               SunmiCol(
  //                   text: widget.orderDataModel.discount,
  //                   width: 4,
  //                   align: SunmiAlign.right),
  //             ], bold: true);*/
  //
  //             /*SunmiPrinter.row(
  //             cols: [
  //               SunmiCol(
  //                   text: 'Tip : ',
  //                   width: 5,
  //                   align: SunmiAlign.left),
  //               SunmiCol(text: '', width: 3, align: SunmiAlign.center),
  //               SunmiCol(
  //                   text: widget.orderDataModel.tip,
  //                   width: 4,
  //                   align: SunmiAlign.right),
  //             ],
  //           );*/
  //
  //             SunmiPrinter.hr();
  //
  //             SunmiPrinter.row(cols: [
  //               SunmiCol(text: 'Rabatt : ', width: 4, align: SunmiAlign.left),
  //               SunmiCol(text: '', width: 4, align: SunmiAlign.center),
  //               SunmiCol(
  //                   text: getAmountWithCurrency(defaultValue(
  //                       orderDataModel.discount.toString(), "0")),
  //                   width: 4,
  //                   align: SunmiAlign.right),
  //             ], bold: true);
  //
  //             SunmiPrinter.hr();
  //
  //             SunmiPrinter.row(cols: [
  //               SunmiCol(text: 'Gesamt : ', width: 4, align: SunmiAlign.left),
  //               SunmiCol(text: '', width: 4, align: SunmiAlign.center),
  //               SunmiCol(
  //                   text: orderDataModel.totalAmount,
  //                   width: 4,
  //                   align: SunmiAlign.right),
  //             ], bold: true);
  //
  //             SunmiPrinter.hr();
  //
  //             SunmiPrinter.text(
  //               orderDataModel.note != null
  //                   ? "Notiz :-" + orderDataModel.note.toString()
  //                   : "",
  //               styles: const SunmiStyles(
  //                   bold: true, underline: false, align: SunmiAlign.center),
  //             );
  //
  //             SunmiPrinter.text(
  //               "Zahlungsmethode : " +
  //                   orderDataModel.paymentMode.toString(),
  //               styles: const SunmiStyles(
  //                   bold: true, underline: false, align: SunmiAlign.center),
  //             );
  //             if (orderDataModel.paymentMode == "Online") {
  //               SunmiPrinter.text(
  //                 "Bestellung wurde online bezahlt Bezahlung Online",
  //                 styles: const SunmiStyles(
  //                     bold: true, underline: false, align: SunmiAlign.center),
  //               );
  //             } else {
  //               SunmiPrinter.text(
  //                 "Bestellung wurde nicht online bezahlt",
  //                 styles: const SunmiStyles(
  //                     bold: true, underline: false, align: SunmiAlign.center),
  //               );
  //             }
  //             if (orderDataModel.paymentMode == "Online") {
  //               SunmiPrinter.text(
  //                 "Bazahlung : " + orderDataModel.paymentMode.toString(),
  //                 styles: const SunmiStyles(
  //                     bold: true, underline: false, align: SunmiAlign.center),
  //               );
  //             }
  //
  //             SunmiPrinter.hr();
  //
  //             /*   // Test text size
  //           SunmiPrinter.text('Extra small text',
  //               styles: SunmiStyles(size: SunmiSize.xs));
  //           SunmiPrinter.text('Medium text', styles: SunmiStyles(size: SunmiSize.md));
  //           SunmiPrinter.text('Large text', styles: SunmiStyles(size: SunmiSize.lg));
  //           SunmiPrinter.text('Extra large text',
  //               styles: SunmiStyles(size: SunmiSize.xl));
  //
  //           // Test row
  //           SunmiPrinter.row(
  //             cols: [
  //               SunmiCol(text: 'col1', width: 4),
  //               SunmiCol(text: 'col2', width: 4, align: SunmiAlign.center),
  //               SunmiCol(text: 'col3', width: 4, align: SunmiAlign.right),
  //             ],
  //           );*/
  //
  //             // Test image
  //             ByteData bytes = await rootBundle.load('assets/qr_bill.png');
  //             final buffer = bytes.buffer;
  //             final imgData = base64.encode(Uint8List.view(buffer));
  //             SunmiPrinter.image(imgData);
  //
  //             SunmiPrinter.emptyLines(3);
  //           } else {
  //             platformChannel.invokeMethod('print_order', {
  //               'name': defaultValue(loginData.restaurantName, ""),
  //               'phone': defaultValue(loginData.phoneNumber, ""),
  //               'address': defaultValue(loginData.location, ""),
  //               'quantity':
  //               orderDataModel.itemDetails!.length.toString(),
  //               'orderData': jsonEncode(orderDataModel),
  //               'ip_address': defaultValue(loginData.wifiPrinterIP, ""),
  //               'port_number': defaultValue(loginData.wifiPrinterPort, "")
  //             });
  //           }
  //         } on PlatformException {
  //           print("PlatformException");
  //         }
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 12, right: 12),
        color: colorBackgroundyellow,
        child: isDataLoad
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  color: colorGreen,
                ),
              )
            : ListView.builder(
                itemCount: orderList.length,
                itemBuilder: (BuildContext context, index) {
                  String status = "";
                  if (orderList[index].orderStatus == STATUS_PENDING) {
                    status = "New Order";
                  } else {
                    status = orderList[index].orderStatus![0].toUpperCase() +
                        orderList[index]
                            .orderStatus!
                            .substring(1)
                            .toLowerCase();
                  }

                  OrderDataModel orderObj = orderList[index];
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
                                    style: const TextStyle(
                                        color: colorTextBlack,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: truncateString(
                                              orderObj.orderNumber!.trimRight(),
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
                                      width: MediaQuery.of(context).size.width *
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              text: orderObj.orderTime!,
                                              style: orderObj.orderTime! ==
                                                      "Sofort"
                                                  ? const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )
                                                  : const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: coloryello,
                                                      fontSize: 14)),
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
                  );
                }));
  }
}
