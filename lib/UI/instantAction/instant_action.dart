import 'package:flutter/material.dart';

import '../../constant/colors.dart';

class InstantAction extends StatefulWidget {
  const InstantAction({Key? key}) : super(key: key);

  @override
  State<InstantAction> createState() => _InstantActionState();
}

class _InstantActionState extends State<InstantAction> {
  bool isOpen = true, isClose = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          "Select Instant Action",
          style: TextStyle(
            color: colorTextBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          height: 57,
          width: 280,
          margin: EdgeInsets.only(top: 20, right: 50),
          decoration: BoxDecoration(
              color: colorTextWhite,
              borderRadius: BorderRadius.circular(46),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 1.0), //(x,y)
                  blurRadius: 1.0,
                ),
              ]),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isOpen ? colorGreen : colorTextWhite,
                      borderRadius: BorderRadius.circular(46)),
                  child: Text(
                    "Open",
                    style: TextStyle(
                      color: isOpen ? colorTextWhite : colorGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  if (!isOpen) {
                    setState(() {
                      isOpen = true;
                      isClose = false;
                    });

                    // callApi("1");
                  }
                },
                behavior: HitTestBehavior.opaque,
              )),
              Expanded(
                  child: GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isClose ? colorButtonYellow : colorTextWhite,
                      borderRadius: BorderRadius.circular(46)),
                  child: Text(
                    "Close",
                    style: TextStyle(
                      color: isClose ? colorTextWhite : colorButtonYellow,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  if (!isClose) {
                    setState(() {
                      isOpen = false;
                      isClose = true;
                    });
                    // callApi("0");
                  }
                },
                behavior: HitTestBehavior.opaque,
              )),
            ],
          ),
        )
      ],
    );
  }
}
