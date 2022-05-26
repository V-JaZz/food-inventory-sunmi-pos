import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_inventory/UI/DeliverySettings/repository/add_delivery_respository.dart';
import 'package:food_inventory/constant/colors.dart';

// ignore: must_be_immutable
class DialogDeliveryCreate extends StatefulWidget {
  var type;
  VoidCallback onDialogClose;

  DialogDeliveryCreate({this.type, required this.onDialogClose});

  @override
  _DialogDeliveryCreateState createState() => _DialogDeliveryCreateState();
}

class _DialogDeliveryCreateState extends State<DialogDeliveryCreate> {
  TextEditingController _deliveryMinRadiusController = TextEditingController();
  TextEditingController _deliveryMaxRadiusController = TextEditingController();
  TextEditingController _deliveryChargeController = TextEditingController();
  TextEditingController _minimumOrderController = TextEditingController();
  TextEditingController _deliveryTimeController = TextEditingController();
  late FocusNode _focusNode;

  late AddDeliveryRepository _addDelCharges;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _addDelCharges = new AddDeliveryRepository(context, widget);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  Color _colorText = colorTextHint;

  @override
  Widget build(BuildContext context) {
    const _defaultColor = colorTextHint;
    const _focusColor = colorButtonYellow;
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(11, 4, 58, 0.7)),
      child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          insetPadding: const EdgeInsets.all(15.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: colorTextWhite, borderRadius: BorderRadius.circular(13)),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  "Add Delivery",
                  style: TextStyle(
                      color: colorTextBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // color: colorFieldBorder,
                      child: TextField(
                        maxLines: 1,
                        controller: _deliveryMinRadiusController,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: colorTextBlack),
                        cursorColor: colorTextBlack,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint)),
                            // contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            hintText: "Min. Delivery Radius",
                            labelText: "Min. Delivery Radius",
                            labelStyle:
                                TextStyle(color: colorTextHint, fontSize: 16),
                            hintStyle:
                                TextStyle(color: colorTextHint, fontSize: 16),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint))),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      // color: colorFieldBorder,
                      child: TextField(
                        maxLines: 1,
                        controller: _deliveryMaxRadiusController,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: colorTextBlack),
                        cursorColor: colorTextBlack,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint)),
                            // contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            hintText: "Max. Delivery Radius",
                            labelText: "Max. Delivery Radius",
                            labelStyle:
                                TextStyle(color: colorTextHint, fontSize: 16),
                            hintStyle:
                                TextStyle(color: colorTextHint, fontSize: 16),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint))),
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(color: colorButtonBlue),
                    SizedBox(height: 15),
                    Container(
                      // color: colorFieldBorder,
                      child: TextField(
                        maxLines: 1,
                        controller: _deliveryChargeController,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: colorTextBlack),
                        cursorColor: colorTextBlack,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint)),
                            // contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            hintText: "Delivery Charge",
                            labelText: "Delivery Charge",
                            labelStyle:
                                TextStyle(color: colorTextHint, fontSize: 16),
                            hintStyle:
                                TextStyle(color: colorTextHint, fontSize: 16),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint))),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      // color: colorFieldBorder,
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          // When you focus on input email, you need to notify the color change into the widget.
                          setState(() => _colorText =
                              hasFocus ? _focusColor : _defaultColor);
                        },
                        child: TextField(
                          maxLines: 1,
                          // focusNode: _focusNode,
                          // onTap: _requestFocus,
                          controller: _minimumOrderController,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: colorTextBlack),
                          cursorColor: colorTextBlack,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorTextHint)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorTextHint)),
                              // contentPadding: EdgeInsets.all(0),
                              isDense: true,
                              hintText: "Min. Order",
                              labelText: "Min. Order",
                              labelStyle: TextStyle(color: _colorText),
                              hintStyle:
                                  TextStyle(color: colorTextHint, fontSize: 16),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: colorTextHint))),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      // color: colorFieldBorder,
                      child: TextField(
                        maxLines: 1,
                        controller: _deliveryTimeController,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: colorTextBlack),
                        cursorColor: colorTextBlack,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint)),
                            isDense: true,
                            hintText: "Delivery Time",
                            labelText: "Delivery Time",
                            labelStyle:
                                TextStyle(color: colorTextHint, fontSize: 16),
                            hintStyle:
                                TextStyle(color: colorTextHint, fontSize: 16),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint))),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 30, right: 10),
                            decoration: BoxDecoration(
                                color: colorGreen,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Add",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            _addDelCharges.addDelivery(
                                _deliveryMinRadiusController.text.toString(),
                                _deliveryMaxRadiusController.text.toString(),
                                _deliveryChargeController.text.toString(),
                                _minimumOrderController.text.toString(),
                                _deliveryTimeController.text.toString());
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 8, right: 30),
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
  }
}
