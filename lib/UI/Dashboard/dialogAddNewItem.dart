import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_inventory/constant/image.dart';

import '../../constant/colors.dart';

class DialogAddNewItems extends StatefulWidget {
  VoidCallback onDialogClose;
  late String delId;

  DialogAddNewItems({required this.onDialogClose});

  @override
  _DialogAddNewItemsState createState() => _DialogAddNewItemsState();
}

class _DialogAddNewItemsState extends State<DialogAddNewItems> {
  late TextEditingController _addNewController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addNewController = new TextEditingController();

    /* _deleteDataRepository =
        new DeleteDataRepository(context,delId);*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(color: Color.fromRGBO(11, 4, 58, 0.7)),
      child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          insetPadding: EdgeInsets.all(15.0),
          elevation: 0,
          // backgroundColor: Colors.transparent,
          child: Container(
            // decoration: new BoxDecoration(color: Color.fromRGBO(11, 4, 58, 0.7)),
            // padding: EdgeInsets.only(
            //     left: 10.0, right: 10.0, top: 100.0, bottom: 50.0),
            height: MediaQuery.of(context).size.height * 0.80,
            // margin: EdgeInsets.only(top: -20, right: -20),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
                color: colorTextWhite, borderRadius: BorderRadius.circular(13)),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add New Item",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 120,
                    ),
                    Icon(Icons.add_circle, size: 32, color: colorButtonYellow)
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: TextField(
                      maxLines: 1,
                      controller: _addNewController,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: colorTextBlack),
                      cursorColor: colorTextBlack,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: "New Item",
                          hintStyle: TextStyle(
                              color: colorTextHint,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none),
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 1,
                            controller: _addNewController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              isDense: true,
                              hintText: "Select Category",
                              hintStyle: TextStyle(
                                  color: colorTextHint,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          icDropDown,
                          color: colorButtonYellow,
                          height: 10.26,
                          width: 18,
                        ),
                      ],
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 1,
                            controller: _addNewController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: "Select Allergy Group",
                                hintStyle: TextStyle(
                                    color: colorTextHint,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                                border: InputBorder.none),
                          ),
                        ),
                        SvgPicture.asset(
                          icDropDown,
                          color: colorButtonYellow,
                          height: 10.26,
                          width: 18,
                        ),
                      ],
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: TextField(
                      maxLines: 1,
                      controller: _addNewController,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: colorTextBlack),
                      cursorColor: colorTextBlack,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: "Add Discription",
                          hintStyle: TextStyle(
                              color: colorTextHint,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none),
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: TextField(
                      maxLines: 1,
                      controller: _addNewController,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: colorTextBlack),
                      cursorColor: colorTextBlack,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: "Add Discount",
                          hintStyle: TextStyle(
                              color: colorTextHint,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none),
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.only(
                      left: 15.0,
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 1,
                            controller: _addNewController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: "Select Variant",
                                hintStyle: TextStyle(
                                    color: colorTextHint,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                                border: InputBorder.none),
                          ),
                        ),
                        SvgPicture.asset(
                          icDropDown,
                          color: colorButtonYellow,
                          height: 10.26,
                          width: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            alignment: Alignment.center,
                            width: 60,
                            color: Color.fromRGBO(213, 210, 234, 1),
                            height: MediaQuery.of(context).size.width * 0.14,
                            child: Text("0.00",
                                style: TextStyle(
                                    color: colorTextWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400))),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: colorButtonYellow,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(05),
                                bottomRight: Radius.circular(05)),
                          ),
                          child: SvgPicture.asset(
                            icCurrency,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 05),
                GestureDetector(
                  child: Text(
                    "+ Add More",
                    style: TextStyle(
                        color: colorButtonYellow,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.only(
                      left: 15.0,
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 1,
                            controller: _addNewController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: "Select Option",
                                hintStyle: TextStyle(
                                    color: colorTextHint,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                                border: InputBorder.none),
                          ),
                        ),
                        SvgPicture.asset(
                          icDropDown,
                          color: colorButtonYellow,
                          height: 10.26,
                          width: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            alignment: Alignment.center,
                            width: 60,
                            color: Color.fromRGBO(213, 210, 234, 1),
                            height: MediaQuery.of(context).size.width * 0.14,
                            child: Text("0.00",
                                style: TextStyle(
                                    color: colorTextWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400))),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: colorButtonYellow,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(05),
                                bottomRight: Radius.circular(05)),
                          ),
                          child: SvgPicture.asset(
                            icCurrency,
                            color: Colors.white,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 05),
                GestureDetector(
                  child: Text(
                    "+ Add More",
                    style: TextStyle(
                        color: colorButtonYellow,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 20),
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
                                color: colorButtonYellow,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Add",
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
          )),
    );
    ;
  }
}
