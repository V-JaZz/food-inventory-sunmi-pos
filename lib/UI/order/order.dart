import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/constant/colors.dart';
import '../../constant/image.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: c/,
        body: SafeArea(
            child: Column(
      children: [
        // Container(
        //   padding: EdgeInsets.only(left: 15, right: 15),
        //   height: MediaQuery.of(context).size.height * 0.075,
        //   color: colorButtonBlue,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       GestureDetector(
        //         child: SvgPicture.asset(
        //           icMenuHam,
        //         ),
        //       ),
        //       SizedBox(width: 15),
        //       Text(
        //         "Nameste India",
        //         style: TextStyle(
        //             color: colorTextWhite,
        //             fontWeight: FontWeight.bold,
        //             fontSize: 15),
        //       ),
        //       SizedBox(width: 30),
        //       Text(
        //         "14 June, 2021",
        //         style: TextStyle(
        //             color: colorTextWhite,
        //             fontWeight: FontWeight.bold,
        //             fontSize: 15),
        //       ),
        //       SizedBox(width: 15),
        //       GestureDetector(
        //         child: SvgPicture.asset(
        //           icCalendar,
        //           height: MediaQuery.of(context).size.height * 0.021,
        //           width: MediaQuery.of(context).size.width * 0.021,
        //           color: Colors.amber,
        //         ),
        //       ),
        //       SizedBox(width: 15),
        //       GestureDetector(
        //         child: SvgPicture.asset(
        //           icDashRate,
        //           height: MediaQuery.of(context).size.height * 0.021,
        //           width: MediaQuery.of(context).size.width * 0.021,
        //           color: colorTextWhite,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Expanded(
          child: Container(
              // height: MediaQuery.of(context).size.height * 0.87,
              color: Colors.amber.shade50,
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      margin: EdgeInsets.all(10.0),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
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
                                          text: '11456848458',
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
                                    "13:20",
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
                                              text: '16:30, 10Jan,2021',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 05),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Delivery Time: ',
                                        style: TextStyle(
                                            color: colorTextBlack,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: '16:30, 10Jan,2021',
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
                                          color: index == 0
                                              ? colorButtonYellow
                                              : index == 1
                                                  ? colorGreen
                                                  : index == 2
                                                      ? colorButtonYellow
                                                      : colorButtonYellow,
                                        ),
                                        SvgPicture.asset(
                                            index == 0
                                                ? icEye
                                                : index == 1
                                                    ? icCheck
                                                    : index == 2
                                                        ? icCross
                                                        : icEye,
                                            height: 12,
                                            width: 18),
                                      ],
                                    ),
                                    Text(
                                      index == 0
                                          ? "View"
                                          : index == 1
                                              ? "Accepted"
                                              : index == 2
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
                    );
                  })),
        ),
      ],
    )));
  }
}
