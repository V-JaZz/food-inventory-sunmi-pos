import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/DeliverySettings/repository/delivery_repository.dart';
import 'package:food_inventory/UI/DeliverySettings/repository/models/delivery_data_model.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';

// ignore: must_be_immutable
class DialogDeliverySetting extends StatefulWidget {
  DistanceDetail itemList;
  VoidCallback onDialogClose;

  DialogDeliverySetting({Key? key, required this.itemList, required this.onDialogClose}) : super(key: key);

  @override
  _DialogDeliverySettingState createState() => _DialogDeliverySettingState();
}

class _DialogDeliverySettingState extends State<DialogDeliverySetting> {
  TextEditingController _postCodeController = TextEditingController();
  TextEditingController _deliveryChargeController = TextEditingController();
  TextEditingController _minimumOrderController = TextEditingController();
  TextEditingController _deliveryTimeController = TextEditingController();
  late EditDeliveryRepository _addDelCharges;

  @override
  void initState() {
    super.initState();
    _addDelCharges = EditDeliveryRepository(context, widget);
    _postCodeController =
        TextEditingController(text: widget.itemList.postcode);
    _deliveryChargeController =
        TextEditingController(text: widget.itemList.deliveryCharge);
    _minimumOrderController =
        TextEditingController(text: widget.itemList.minOrder);
    _deliveryTimeController =
        TextEditingController(text: widget.itemList.deliveryTime);
  }

  @override
  Widget build(BuildContext context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Edit Delivery",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: colorFieldBorder,
                        border: Border.all(color: colorFieldBorder, width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: TextField(
                        maxLines: 1,
                        controller: _postCodeController,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: colorTextBlack),
                        cursorColor: colorTextBlack,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            hintText: "Postcode & City",
                            // hintText: widget.itemList.minDistance.toString(),
                            hintStyle:
                                TextStyle(color: colorTextHint, fontSize: 16),
                            border: InputBorder.none),
                      ),
                    ),
              /*      SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.all(18),
                      margin: EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: colorFieldBorder,
                        border: Border.all(color: colorFieldBorder, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
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
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            hintText: "Max. Delivery Radius",
                            // hintText: widget.itemList.maxDistance.toString(),
                            hintStyle:
                                TextStyle(color: colorTextHint, fontSize: 16),
                            border: InputBorder.none),
                      ),
                    ),*/
                    const SizedBox(height: 15),
                    const Divider(color: colorButtonBlue),
                    const SizedBox(height: 15),
                    Container(
                        padding: const EdgeInsets.all(18),
                        margin: const EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                          color: colorFieldBorder,
                          border: Border.all(color: colorFieldBorder, width: 1),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: TextField(
                          maxLines: 1,
                          controller: _deliveryChargeController,
//                           inputFormatters: <TextInputFormatter>[
//                             // for below version 2 use this
//                             FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// // for version 2 and greater youcan also use this
//                             FilteringTextInputFormatter.digitsOnly
//                           ],
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: colorTextBlack),
                          cursorColor: colorTextBlack,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              isDense: true,
                              hintText: "Delivery Charge",
                              // hintText: widget.itemList.deliveryCharge
                              // .toString(),
                              hintStyle:
                                  TextStyle(color: colorTextHint, fontSize: 16),
                              border: InputBorder.none),
                        )),
                    const SizedBox(height: 15),
                    Container(
                        padding: const EdgeInsets.all(18),
                        margin: const EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                          color: colorFieldBorder,
                          border: Border.all(color: colorFieldBorder, width: 1),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: TextField(
                          maxLines: 1,
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
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              isDense: true,
                              hintText: "Minimum Order",
                              // widget.itemList.minOrder.toString(),
                              hintStyle:
                                  TextStyle(color: colorTextHint, fontSize: 16),
                              border: InputBorder.none),
                        )),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: colorFieldBorder,
                        border: Border.all(color: colorFieldBorder, width: 1),
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: TextField(
                        maxLines: 1,
                        controller: _deliveryTimeController,
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
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          isDense: true,
                          hintText: "Delivery Time",
                          //  widget.itemList.deliveryTime.toString(),
                          hintStyle:
                              const TextStyle(color: colorTextHint, fontSize: 16),
                          border: InputBorder.none,
                          suffix: SvgPicture.asset(
                            icClock2,
                            color: colorButtonYellow,
                            width: 14,
                            height: 14,
                          ),
                        ),
                      ),
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
                                color: colorGreen,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            _addDelCharges.updateDelivery(
                                _postCodeController.text.toString(),
                                _deliveryChargeController.text.toString(),
                                _minimumOrderController.text.toString(),
                                _deliveryTimeController.text.toString(),
                                widget.itemList);
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
                              "Back",
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
