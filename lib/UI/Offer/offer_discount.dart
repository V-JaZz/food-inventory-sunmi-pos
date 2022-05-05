import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/constant/colors.dart';

import '../../constant/image.dart';
import '../../constant/validation_util.dart';

class OfferDiscount extends StatefulWidget {
  const OfferDiscount({Key? key}) : super(key: key);

  @override
  State<OfferDiscount> createState() => _OfferDiscountState();
}

class _OfferDiscountState extends State<OfferDiscount> {
  late TextEditingController _offerController;
  late TextEditingController _collectionController;
  bool items = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _offerController = new TextEditingController();
    _collectionController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: colorBackgroundyellow,
      padding: EdgeInsets.only(top: 10, right: 10),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Delivery Discount",
            style: TextStyle(
              color: colorButtonBlue,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.056,
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: colorTextWhite,
                  // border: Border.all(color: colorButtonYellow, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: colorButtonYellow,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                      ),
                      child: SvgPicture.asset(
                        icPercentage,
                        color: Colors.white,
                        width: 12,
                        height: 12,
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 18),
                          child: TextField(
                            maxLines: 1,
                            controller: _offerController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: "0.00",
                                hintStyle: TextStyle(
                                    color: colorTextHint,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                border: InputBorder.none),
                          )),
                    ),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorButtonBlue,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Text(
                          "Exclude",
                          style: TextStyle(
                              color: colorTextWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            "Add Collection Discount",
            style: TextStyle(
                color: colorTextBlack,
                fontSize: 18,
                fontWeight: FontWeight.w400),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.056,
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: colorTextWhite,
                  // border: Border.all(color: colorButtonYellow, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: colorButtonYellow,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                      ),
                      child: SvgPicture.asset(
                        icPercentage,
                        color: Colors.white,
                        width: 12,
                        height: 12,
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 18),
                          child: TextField(
                            maxLines: 1,
                            controller: _collectionController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: "0.00",
                                hintStyle: TextStyle(
                                    color: colorTextHint,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                border: InputBorder.none),
                          )),
                    ),
                    GestureDetector(
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.7,
                        // height: MediaQuery.of(context).size.height * 0.0,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        alignment: Alignment.center,
                        // margin: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          color: colorButtonBlue,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Text(
                          "Exclude",
                          style: TextStyle(
                              color: colorTextWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                      onTap: () {
                        addMoreDialog();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: 480,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 15, left: 25),
                      decoration: BoxDecoration(
                          color: colorGreen,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "Add",
                        style: TextStyle(
                            color: colorTextWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                    onTap: () {
                      if (_offerController.text.isEmpty) {
                        showMessage("Enter Offer/Discount Value", context);
                      } else {
                        FocusScope.of(context).requestFocus(FocusNode());
                        // callAddOfferApi();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 25, left: 15),
                      decoration: BoxDecoration(
                          color: colorGrey,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: colorTextWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _offerController = new TextEditingController();
                        _collectionController = new TextEditingController();
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  addMoreDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0,
          ),
          child: Container(
            decoration:
                new BoxDecoration(color: Color.fromRGBO(11, 4, 58, 0.7)),
            padding: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 230.0, bottom: 248.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          },
                          child: Icon(Icons.arrow_back,
                              size: 25, color: colorButtonYellow)),
                      SizedBox(width: 05),
                      Text(
                        "Select Items",
                        style: TextStyle(
                            color: colorTextBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.22,
                    child: ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      itemBuilder: (listContext, index) {
                        return Container(
                            padding: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? Color.fromRGBO(228, 225, 246, 1)
                                    : colorTextWhite),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Item One",
                                  style: TextStyle(
                                      color: colorTextBlack,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                                Transform.scale(
                                  scale: 0.5,
                                  child: CupertinoSwitch(
                                    value: items,
                                    onChanged: (value) {
                                      setState(() {
                                        items = !items;
                                      });
                                    },
                                    activeColor: colorGreen,
                                    trackColor: colorSwitchColor,
                                  ),
                                )
                              ],
                            ));
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                  color: colorGreen,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    color: colorTextWhite,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                  color: colorGrey,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: colorTextWhite,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            behavior: HitTestBehavior.opaque,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
