import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_inventory/UI/DeliverySettings/repository/add_delivery_respository.dart';
import 'package:food_inventory/constant/colors.dart';

// ignore: must_be_immutable
class DialogDeliveryCreate extends StatefulWidget {
  dynamic type;
  VoidCallback onDialogClose;

  DialogDeliveryCreate({Key? key, this.type, required this.onDialogClose}) : super(key: key);

  @override
  _DialogDeliveryCreateState createState() => _DialogDeliveryCreateState();
}

class _DialogDeliveryCreateState extends State<DialogDeliveryCreate> {
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _deliveryChargeController = TextEditingController();
  final TextEditingController _minimumOrderController = TextEditingController();
  final TextEditingController _deliveryTimeController = TextEditingController();
  final TextEditingController _cityCodeController = TextEditingController();

  late FocusNode _focusNode;

  late AddDeliveryRepository _addDelCharges;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _addDelCharges = AddDeliveryRepository(context, widget);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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
                const Text(
                  "Add Delivery",
                  style: TextStyle(
                      color: colorTextBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextField(
                            maxLines: 1,
                            controller: _postCodeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              // for below version 2 use this
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
// for version 2 and greater you can also use this
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: colorTextHint)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: colorTextHint)),
                                // contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: "Post Code",
                                labelText: "Post Code",
                                labelStyle: TextStyle(
                                    color: colorTextHint, fontSize: 16),
                                hintStyle: TextStyle(
                                    color: colorTextHint, fontSize: 16),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: colorTextHint))),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            maxLines: 1,
                            controller: _cityCodeController,
                            keyboardType: TextInputType.text,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: colorTextHint)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: colorTextHint)),
                                // contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                hintText: "Post City",
                                labelText: "Post City",
                                labelStyle: TextStyle(
                                    color: colorTextHint, fontSize: 16),
                                hintStyle: TextStyle(
                                    color: colorTextHint, fontSize: 16),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: colorTextHint))),
                          ),
                        )
                      ],
                    ),

                    /*    SizedBox(height: 15),
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
                    ),*/
                    const SizedBox(height: 15),
                    const Divider(color: colorButtonBlue),
                    const SizedBox(height: 15),
                    TextField(
                      maxLines: 1,
                      controller: _deliveryChargeController,
//                         inputFormatters: <TextInputFormatter>[
//                           // for below version 2 use this
//                           FilteringTextInputFormatter.allow(RegExp(r'[0-9]',dotAll: true)),
// // for version 2 and greater youcan also use this
// //                           FilteringTextInputFormatter.digitsOnly
//                         ],
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: colorTextBlack),
                      cursorColor: colorTextBlack,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 15),
                    Focus(
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
                        inputFormatters: <TextInputFormatter>[
                          // for below version 2 use this
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: colorTextBlack),
                        cursorColor: colorTextBlack,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextHint)),
                            // contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            hintText: "Min. Order",
                            labelText: "Min. Order",
                            labelStyle: TextStyle(color: _colorText),
                            hintStyle:
                                const TextStyle(color: colorTextHint, fontSize: 16),
                            border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: colorTextHint))),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      maxLines: 1,
                      controller: _deliveryTimeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        // for below version 2 use this
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: colorTextBlack),
                      cursorColor: colorTextBlack,
                      decoration: const InputDecoration(
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
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 30, right: 10),
                            decoration: BoxDecoration(
                                color: colorButtonYellow,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            _addDelCharges.addDelivery(
                                _postCodeController.text.toString() +
                                    " , " +
                                    _cityCodeController.text.toString(),
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
                            child: const Text(
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
