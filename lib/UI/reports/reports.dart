// ignore_for_file: avoid_print, unnecessary_const, unused_element, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/storage_util.dart';
import 'package:food_inventory/networking/api_base_helper.dart';
import 'package:intl/intl.dart';

import '../dashboard/model/orderReportModel.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Reports> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Si zedBox(height: 20),
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            getOrderData("X");
                          });
                        },
                        child: Card(
                          color: colorButtonBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: const Padding(
                            padding: EdgeInsets.all(14),
                            child: Text(
                              "Print X Report",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            getOrderData("Y");
                          });
                        },
                        child: Card(
                          color: colorButtonBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: const Padding(
                            padding: EdgeInsets.all(14),
                            child: Text(
                              "Print Y Report",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool isDataLoad = false;
  List<ReportData> reportData = [];
  List<ItemData> itemDetails = [];

  getOrderData(type) async {
    StorageUtil.getData(StorageUtil.keyLoginToken, "")!.then((token) async {
      setState(() {
        isDataLoad = true;
      });
      try {
        final response = await ApiBaseHelper()
            .get(ApiBaseHelper.getOrderReport + type, token);
        print("ResponseData " + response.toString());
        print(ApiBaseHelper.getOrderReport + type);
        OrderReport model = OrderReport.fromJson(
            ApiBaseHelper().returnResponse(context, response));

        /*  setState(() {
          isDataLoad = false;
        });*/
        if (model.success!) {
          if (model.reportData!.isNotEmpty) {
            setState(() {
              reportData = model.reportData!;
              for (int i = 0; i < model.reportData!.length; i++) {
                itemDetails = model.reportData![i].itemDetails!;
              }
              print("nonovce API DATA======================================");
              if (type == "X") {
                _printOrderReport(
                    reportData, model.reportSummary!, model.restDetails!, type);
              } else {
                _printOrderReportY(
                    reportData, model.reportSummary!, model.restDetails!, type);
              }
            });
          }
        }
      } catch (e) {
        print(e.toString());
        /* setState(() {
          isDataLoad = false;
        });*/
      }
    });
  }

  Future<void> _printOrderReport(List<ReportData> orderDataModel,
      List<ReportSummary> report, RestDetails resDetails, type) async {
    print("sunmiXY======================================");
    // for (int i = 0; i < report.length; i++) {
    // orderReport = report[i].sId;
    // print("================================" + orderReport);
    /*var jsonData = jsonEncode({
      'reportData': orderDataModel,
      'reportSummary': report,
      'restDetails': resDetails
    });
    print("JSonData " + jsonData.toString());*/
    /*   SunmiPrinter.text(
      jsonData.toString(),
      styles: SunmiStyles(bold: true, underline: false, align: SunmiAlign.left),
    );
    SunmiPrinter.hr();
    SunmiPrinter.emptyLines(3);*/
    // }
    for (int i = 0; i < 1; i++) {
      SunmiPrinter.text(
        report[0].sId.toString(),
        styles:
            const SunmiStyles(bold: true, underline: false, align: SunmiAlign.right),
      );
    }
    print("PrintData " + report[0].sId.toString());

    if (type == "X") {
      SunmiPrinter.text(
        "X-Report",
        styles: const SunmiStyles(
            bold: true,
            underline: false,
            align: SunmiAlign.center,
            size: SunmiSize.lg),
      );
    } else {
      SunmiPrinter.text(
        "Y-Report",
        styles: const SunmiStyles(
            bold: true,
            underline: false,
            align: SunmiAlign.center,
            size: SunmiSize.lg),
      );
    }

    SunmiPrinter.text(
      resDetails.restaurantName,
      styles:
          const SunmiStyles(bold: true, underline: false, align: SunmiAlign.center),
    );
    SunmiPrinter.text(
      resDetails.location,
      styles:
          const SunmiStyles(bold: true, underline: false, align: SunmiAlign.center),
    );

    SunmiPrinter.hr();

    for (int j = 0; j < orderDataModel.length; j++) {
      SunmiPrinter.row(
          cols: [
        SunmiCol(
            text: orderDataModel[j].orderNumber.toString(),
            width: 8,
            align: SunmiAlign.left),
        SunmiCol(
            text: " ",
            width: 1,
            align: SunmiAlign.center),
        SunmiCol(
            text: orderDataModel[j].totalAmount.toString() + " €",
            width: 3,
            align: SunmiAlign.right),
      ],
        bold: true,
        underline: false,
      );

      String payMode = orderDataModel[j].paymentMode.toString();
      String outputTime = orderDataModel[j].orderDateTime.toString().substring(10, 22);
      SunmiPrinter.row(
          cols: [
            SunmiCol(
                text: outputTime + " - " + orderDataModel[j].deliveryType.toString(),
                width: 9,
                align: SunmiAlign.left),
            SunmiCol(
                text: payMode.toString() == 'Online' ? 'ONLINE' : 'CASH',
                width: 3,
                align: SunmiAlign.right),
          ],
          bold: true,
          underline: false,
      );

      SunmiPrinter.emptyLines(1);
    }

    SunmiPrinter.hr();

    SunmiPrinter.text(
      "Summary",
      styles: const SunmiStyles(bold: true, underline: false, align: SunmiAlign.left),
    );

    SunmiPrinter.hr();

    for (int k = 0; k < report.length; k++) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "Total Pickup Orders", width: 9, align: SunmiAlign.left),
        SunmiCol(text: '', width: 1, align: SunmiAlign.center),
        SunmiCol(
            text: report[k].pickupOrders, width: 2, align: SunmiAlign.right),
      ], bold: true);

      SunmiPrinter.row(cols: [
        SunmiCol(
            text: "Total Delivery Orders", width: 9, align: SunmiAlign.left),
        SunmiCol(text: '', width: 1, align: SunmiAlign.center),
        SunmiCol(
            text: report[k].deliveryOrders, width: 2, align: SunmiAlign.right),
      ], bold: true);

      SunmiPrinter.row(cols: [
        SunmiCol(text: "Total Pickup Sales", width: 8, align: SunmiAlign.left),
        SunmiCol(text: '', width: 1, align: SunmiAlign.center),
        SunmiCol(
            text: report[k].totalPickupSales.toString() + " € ",
            width: 3,
            align: SunmiAlign.right),
      ], bold: true);

      SunmiPrinter.row(cols: [
        SunmiCol(
            text: "Total Delivery Sales", width: 8, align: SunmiAlign.left),
        SunmiCol(text: '', width: 1, align: SunmiAlign.center),
        SunmiCol(
            text: report[k].totalDeliverySales.toString() + " € ",
            width: 3,
            align: SunmiAlign.right),
      ], bold: true);
    }

    SunmiPrinter.hr();

    SunmiPrinter.text(
      "Net Total",
      styles: const SunmiStyles(bold: true, underline: false, align: SunmiAlign.left),
    );

    SunmiPrinter.hr();
    for (int l = 0; l < report.length; l++) {
      SunmiPrinter.row(cols: [
        SunmiCol(text: "Total Orders", width: 9, align: SunmiAlign.left),
        SunmiCol(text: '', width: 1, align: SunmiAlign.center),
        SunmiCol(
            text: report[l].totalOrders.toString(),
            width: 2,
            align: SunmiAlign.right),
      ], bold: true);

      SunmiPrinter.row(cols: [
        SunmiCol(
            text: "Total Online Payments", width: 9, align: SunmiAlign.left),
        SunmiCol(
            text: report[l].totalOnlinePayment.toString() + " €",
            width: 3,
            align: SunmiAlign.right),
      ], bold: true);

      SunmiPrinter.row(cols: [
        SunmiCol(text: "Total Cash Payments", width: 8, align: SunmiAlign.left),
        SunmiCol(text: '', width: 1, align: SunmiAlign.center),
        SunmiCol(
            text: report[l].totalCashPayment.toString() + " €",
            width: 3,
            align: SunmiAlign.right),
      ], bold: true);

      SunmiPrinter.row(cols: [
        SunmiCol(text: "Total Sales", width: 7, align: SunmiAlign.left),
        SunmiCol(text: '', width: 1, align: SunmiAlign.center),
        SunmiCol(
            text: report[l].totalSales.toString() + " €",
            width: 4,
            align: SunmiAlign.right),
      ], bold: true);
    }
    SunmiPrinter.hr();

    SunmiPrinter.emptyLines(3);
  }
}

Future<void> _printOrderReportY(List<ReportData> orderDataModel,
    List<ReportSummary> report, RestDetails resDetails, type) async {
  print("sunmiXY======================================");
  // for (int i = 0; i < report.length; i++) {
  // orderReport = report[i].sId;
  // print("================================" + orderReport);
  /*var jsonData = jsonEncode({
      'reportData': orderDataModel,
      'reportSummary': report,
      'restDetails': resDetails
    });
    print("JSonData " + jsonData.toString());*/
  /*   SunmiPrinter.text(
      jsonData.toString(),
      styles: SunmiStyles(bold: true, underline: false, align: SunmiAlign.left),
    );
    SunmiPrinter.hr();
    SunmiPrinter.emptyLines(3);*/
  // }
  print("PrintData " + report[0].sId.toString());
  var totalPickOrder = 0;
  var totalDeliveryOrder = 0;
  var totalPickupSales = 0.0;
  var totalDeliverySales = 0.0;
  for (int ord = 0; ord < report.length; ord++) {
    totalPickOrder += int.parse(report[ord].pickupOrders.toString());
    totalDeliveryOrder += int.parse(report[ord].deliveryOrders.toString());
    totalPickupSales += double.parse(report[ord].totalPickupSales.toString());
    totalDeliverySales +=
        double.parse(report[ord].totalDeliverySales.toString());
  }

  print("OrderDetailCount " +
      totalPickOrder.toString() +
      " " +
      totalDeliveryOrder.toString() +
      " " +
      totalPickupSales.toString() +
      " " +
      totalDeliverySales.toString());

  if (type == "X") {
    SunmiPrinter.text(
      "X-Report",
      styles: const SunmiStyles(
          bold: true,
          underline: false,
          align: SunmiAlign.center,
          size: SunmiSize.lg),
    );
  } else {
    SunmiPrinter.text(
      "Y-Report",
      styles: const SunmiStyles(
          bold: true,
          underline: false,
          align: SunmiAlign.center,
          size: SunmiSize.lg),
    );
  }

  SunmiPrinter.text(
    resDetails.restaurantName,
    styles: const SunmiStyles(bold: true, underline: false, align: SunmiAlign.center),
  );
  SunmiPrinter.text(
    resDetails.location,
    styles: const SunmiStyles(bold: true, underline: false, align: SunmiAlign.center),
  );

  SunmiPrinter.hr();

  /*for (int j = 0; j < orderDataModel.length; j++) {
    SunmiPrinter.row(cols: [
      SunmiCol(
          text: orderDataModel[j].orderNumber.toString(),
          width: 7,
          align: SunmiAlign.left),
      SunmiCol(
          text: orderDataModel[j].isPaid == false ? "Cash" : "Online",
          width: 2,
          align: SunmiAlign.center),
      SunmiCol(
          text: orderDataModel[j].totalAmount.toString() + " €",
          width: 3,
          align: SunmiAlign.right),
    ], bold: true);
    String outputTime =
    orderDataModel[j].orderDateTime.toString().substring(10, 22);
    SunmiPrinter.text(
      outputTime + " --- " + orderDataModel[j].deliveryType.toString(),
      styles:
      SunmiStyles(bold: true, underline: false, align: SunmiAlign.left),
    );

    SunmiPrinter.emptyLines(1);
  }*/

  for (int l = 0; l < report.length; l++) {
    var inputFormat = DateFormat('dddd.MM.yyyy HH:mm:ss');
    var inputDate = inputFormat.parse(report[l].sId.toString());
    var outputFormat = DateFormat('dd-MM-yyyy');

    print("Date Format  " + outputFormat.format(inputDate));
    SunmiPrinter.text(
      outputFormat.format(inputDate).toString(),
      styles: const SunmiStyles(bold: true, underline: false, align: SunmiAlign.left),
    );

    SunmiPrinter.row(cols: [
      SunmiCol(text: "Pickup Orders", width: 6, align: SunmiAlign.left),
      SunmiCol(
          text: report[l].pickupOrders.toString(),
          width: 2,
          align: SunmiAlign.center),
      SunmiCol(
          text: report[l].totalPickupSales.toString() + " €",
          width: 4,
          align: SunmiAlign.right),
    ], bold: true);

    SunmiPrinter.row(cols: [
      SunmiCol(text: "Delivery Orders", width: 6, align: SunmiAlign.left),
      SunmiCol(
          text: report[l].deliveryOrders.toString(),
          width: 2,
          align: SunmiAlign.center),
      SunmiCol(
          text: report[l].totalDeliverySales.toString() + " €",
          width: 4,
          align: SunmiAlign.right),
    ], bold: true);

    SunmiPrinter.row(cols: [
      SunmiCol(text: "Total Online", width: 6, align: SunmiAlign.left),
      SunmiCol(
          text: report[l].totalOnlineCount.toString(),
          width: 2,
          align: SunmiAlign.center),
      SunmiCol(
          text: report[l].totalOnlinePayment.toString() + " €",
          width: 4,
          align: SunmiAlign.right),
    ], bold: true);

    SunmiPrinter.row(cols: [
      SunmiCol(text: "Total Cash", width: 6, align: SunmiAlign.left),
      SunmiCol(
          text: report[l].totalCashCount.toString(),
          width: 2,
          align: SunmiAlign.center),
      SunmiCol(
          text: report[l].totalCashPayment.toString() + " €",
          width: 4,
          align: SunmiAlign.right),
    ], bold: true);

    SunmiPrinter.row(cols: [
      SunmiCol(text: "Total Sales", width: 7, align: SunmiAlign.left),
      SunmiCol(text: '', width: 1, align: SunmiAlign.center),
      SunmiCol(
          text: report[l].totalSales.toString() + " €",
          width: 4,
          align: SunmiAlign.right),
    ], bold: true);
  }
  SunmiPrinter.hr();

  SunmiPrinter.text(
    "Summary",
    styles: const SunmiStyles(bold: true, underline: false, align: SunmiAlign.left),
  );

  SunmiPrinter.hr();

  SunmiPrinter.row(cols: [
    SunmiCol(text: "Total Pickup Orders", width: 9, align: SunmiAlign.left),
    SunmiCol(text: ' ', width: 1, align: SunmiAlign.center),
    SunmiCol(
        text: totalPickOrder.toString(), width: 2, align: SunmiAlign.right),
  ], bold: true);

  SunmiPrinter.row(cols: [
    SunmiCol(text: "Total Delivery Orders", width: 9, align: SunmiAlign.left),
    SunmiCol(text: ' ', width: 1, align: SunmiAlign.center),
    SunmiCol(
        text: totalDeliveryOrder.toString(), width: 2, align: SunmiAlign.right),
  ], bold: true);

  SunmiPrinter.row(cols: [
    SunmiCol(text: "Total Pickup Sales", width: 8, align: SunmiAlign.left),
    SunmiCol(text: ' ', width: 1, align: SunmiAlign.center),
    SunmiCol(
        text: totalPickupSales.toString() + " € ",
        width: 3,
        align: SunmiAlign.right),
  ], bold: true);

  SunmiPrinter.row(cols: [
    SunmiCol(text: "Total Delivery Sales", width: 8, align: SunmiAlign.left),
    SunmiCol(text: ' ', width: 1, align: SunmiAlign.center),
    SunmiCol(
        text: totalDeliverySales.toString() + " € ",
        width: 3,
        align: SunmiAlign.right),
  ], bold: true);

  SunmiPrinter.hr();

  /* SunmiPrinter.text(
    "Net Total",
    styles: SunmiStyles(bold: true, underline: false, align: SunmiAlign.left),
  );

  SunmiPrinter.hr();*/

  SunmiPrinter.emptyLines(3);
}
