import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constant/app_util.dart';
import '../../constant/colors.dart';
import '../../constant/image.dart';
import '../../constant/validation_util.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  bool showReport = false;
  bool isDataLoad = false;
  DateTime _focusedDay = DateTime.now();
  String day = "", month = "", year = "";
  @override
  Widget build(BuildContext context) {
    return historyCalender();
  }

  Widget historyCalender() {
    return Scaffold(
        backgroundColor: colorBackgroundyellow,
        body: SafeArea(
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
                      child: Container(
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
                    ),
                  )),
                  // GestureDetector(
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         child: Text(
                  //           // day.isEmpty ? "DD" : day,
                  //           "DD",
                  //           style: TextStyle(color: colorTextWhite, fontSize: 16),
                  //         ),
                  //       ),
                  //       Container(
                  //         margin: EdgeInsets.only(right: 22, left: 22),
                  //         child: Text(
                  //           // month.isEmpty ? "MM" : month,
                  //           "MM",
                  //           style: TextStyle(color: colorTextWhite, fontSize: 16),
                  //         ),
                  //       ),
                  //       Container(
                  //         margin: EdgeInsets.only(right: 22),
                  //         child: Text(
                  //           // year.isEmpty ? "YYYY" : year,
                  //           "YYYY",
                  //           style: TextStyle(color: colorTextWhite, fontSize: 16),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  //   behavior: HitTestBehavior.opaque,
                  //   onTap: () {
                  //     // _selectDate(context);
                  //   },
                  // ),
                  // GestureDetector(
                  //   child: Container(
                  //     width: 40,
                  //     height: 40,
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //         shape: BoxShape.circle, color: colorGreen),
                  //     child: Text(
                  //       "Go!",
                  //       style: TextStyle(color: colorTextWhite, fontSize: 16),
                  //     ),
                  //   ),
                  //   behavior: HitTestBehavior.opaque,
                  //   onTap: () {
                  //     setState(() {
                  //       //   day = "";
                  //       //   month = "";
                  //       //   year = "";
                  //       //   // _focusedDay = selectedHistoryDate;
                  //       //   isToday = true;
                  //       //   isHistory = false;
                  //       //   var now = new DateTime.now();
                  //       //   if (_focusedDay.difference(now).inDays == 0) {
                  //       //     selectedDate = "";
                  //       //   } else {
                  //       //     selectedDate = getSendableDate(_focusedDay);
                  //       //   }
                  //     });
                  //     // getOrderList(true);
                  //   },
                  // )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                shrinkWrap: true,
                // padding: EdgeInsets.only(left: 38, right: 35, bottom: 29, top: 29),
                children: [
                  Container(
                      // margin: EdgeInsets.only(top: 29),
                      child: TableCalendar(
                    availableGestures: AvailableGestures.horizontalSwipe,
                    calendarStyle: const CalendarStyle(isTodayHighlighted: false),
                    daysOfWeekHeight: 30,
                    rowHeight: 59,
                    calendarBuilders: CalendarBuilders(
                      dowBuilder: (context, day) {
                        final text = DateFormat.E().format(day);
                        //TODO : Set Day TOP UI
                        return Container(
                          height: 100,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                            top: 3,
                            bottom: 3,
                          ),
                          margin: const EdgeInsets.only(right: 1, left: 1, bottom: 1),
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
                        //TODO : Dates of Month UI
                        final text = DateFormat("d").format(day);
                        String totalAmountOnDay = "";
                        final stCheckDay = DateFormat("yyyy-MM-dd").format(day);
                        // if (_historyList.isNotEmpty) {
                        //   for (OrderHistoryData history in _historyList) {
                        //     if (history.sId == stCheckDay) {
                        //       totalAmountOnDay =
                        //           defaultValue(history.totalOrderAmount, "");
                        //     }
                        //   }
                        // }
                        var now = new DateTime.now();
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
                                      color:
                                          selectedDate == getSendableDate(day)
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
                                      getAmountWithCurrency(totalAmountOnDay),
                                      style: TextStyle(
                                          color: selectedDate ==
                                                  getSendableDate(day)
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
                        var now = new DateTime.now();
                        // if (selectedDay.difference(now).inDays == 0) {
                        if (getSendableDate(selectedDay) ==
                            getSendableDate(now)) {
                          selectedDate = "";
                        } else {
                          selectedDate = getSendableDate(selectedDay);
                        }
                      });
                      // getOrderList(true);
                    },
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.22,
                    margin: const EdgeInsets.only(top: 20),
                    // padding: EdgeInsets.all(15.0),
                    // decoration: BoxDecoration(
                    //     color: Color(0xffFCAE03),
                    //     borderRadius:
                    //         BorderRadius.only(topLeft: Radius.circular(30.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Text(
                        //   _historyHeader + "’s Status",
                        //   style: TextStyle(
                        //       fontSize: 30,
                        //       fontWeight: FontWeight.bold,
                        //       color: colorTextBlack),
                        // ),
                        const Text(
                          "Today's Status",
                          style: TextStyle(
                              color: colorTextBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                            text: const TextSpan(
                                text: "Accepted Order :- ",
                                style: TextStyle(
                                    color: colorTextBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                children: [
                              TextSpan(
                                  text: "\$6000",
                                  style: TextStyle(
                                      color: colorButtonYellow,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ])),
                        const SizedBox(height: 8),
                        RichText(
                            text: const TextSpan(
                                text: "Declined Order :- ",
                                style: TextStyle(
                                    color: colorTextBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                children: [
                              TextSpan(
                                  text: "\$6000",
                                  style: TextStyle(
                                      color: colorButtonYellow,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ])),
                        const SizedBox(height: 8),
                        RichText(
                            text: const TextSpan(
                                text: "Order Received :- ",
                                style: TextStyle(
                                    color: colorTextBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                children: [
                              TextSpan(
                                  text: "\$6000",
                                  style: TextStyle(
                                      color: colorButtonYellow,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ])),
                        const SizedBox(height: 8),
                        RichText(
                            text: const TextSpan(
                                text: "Cash :- ",
                                style: TextStyle(
                                    color: colorTextBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                children: [
                              TextSpan(
                                  text: "\$6000",
                                  style: TextStyle(
                                      color: colorButtonYellow,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ])),
                        const SizedBox(height: 8),
                        RichText(
                            text: const TextSpan(
                                text: "Online :- ",
                                style: TextStyle(
                                    color: colorTextBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                children: [
                              TextSpan(
                                  text: "\$6000",
                                  style: TextStyle(
                                      color: colorButtonYellow,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ])),
                        const SizedBox(height: 8),
                        RichText(
                            text: const TextSpan(
                                text: "Total :- ",
                                style: TextStyle(
                                    color: colorTextBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                children: [
                              TextSpan(
                                  text: "\$6000",
                                  style: TextStyle(
                                      color: colorButtonYellow,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ])),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: colorButtonYellow,
                              borderRadius: BorderRadius.circular(30.0)),
                          padding: const EdgeInsets.all(10.0),
                          child: const Text("Full Details",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        )));
  }
}
