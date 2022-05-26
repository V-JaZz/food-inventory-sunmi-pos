import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/DeliverySettings/repository/delivery_repository.dart';
import 'package:food_inventory/UI/DeliverySettings/repository/models/delivery_data_model.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';

// ignore: must_be_immutable
class DialogDeliverySetting extends StatefulWidget {
  DistanceDetail itemList;
  VoidCallback onDialogClose;

  DialogDeliverySetting({required this.itemList, required this.onDialogClose});

  @override
  _DialogDeliverySettingState createState() => _DialogDeliverySettingState();
}

class _DialogDeliverySettingState extends State<DialogDeliverySetting> {
  TextEditingController _deliveryMinRadiusController = TextEditingController();
  TextEditingController _deliveryMaxRadiusController = TextEditingController();
  TextEditingController _deliveryChargeController = TextEditingController();
  TextEditingController _minimumOrderController = TextEditingController();
  TextEditingController _deliveryTimeController = TextEditingController();
  late EditDeliveryRepository _addDelCharges;

  @override
  void initState() {
    super.initState();
    _addDelCharges = new EditDeliveryRepository(context, widget);
    _deliveryMinRadiusController =
        new TextEditingController(text: widget.itemList.minDistance);
    _deliveryMaxRadiusController =
        new TextEditingController(text: widget.itemList.maxDistance);
    _deliveryChargeController =
        new TextEditingController(text: widget.itemList.deliveryCharge);
    _minimumOrderController =
        new TextEditingController(text: widget.itemList.minOrder);
    _deliveryTimeController =
        new TextEditingController(text: widget.itemList.deliveryTime);
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
                  children: [
                    Text(
                      "Edit Delivery",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        controller: _deliveryMinRadiusController,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: colorTextBlack),
                        cursorColor: colorTextBlack,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            hintText: "Min. Delivery Radius",
                            // hintText: widget.itemList.minDistance.toString(),
                            hintStyle:
                                TextStyle(color: colorTextHint, fontSize: 16),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(height: 15),
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
                    ),
                    SizedBox(height: 15),
                    Divider(color: colorButtonBlue),
                    SizedBox(height: 15),
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
                              contentPadding: EdgeInsets.all(0),
                              isDense: true,
                              hintText: "Delivery Charge",
                              // hintText: widget.itemList.deliveryCharge
                              // .toString(),
                              hintStyle:
                                  TextStyle(color: colorTextHint, fontSize: 16),
                              border: InputBorder.none),
                        )),
                    SizedBox(height: 15),
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
                              contentPadding: EdgeInsets.all(0),
                              isDense: true,
                              hintText: "Minimum Order",
                              // widget.itemList.minOrder.toString(),
                              hintStyle:
                                  TextStyle(color: colorTextHint, fontSize: 16),
                              border: InputBorder.none),
                        )),
                    SizedBox(height: 15),
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
                        controller: _deliveryTimeController,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: colorTextBlack),
                        cursorColor: colorTextBlack,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: "Delivery Time",
                          //  widget.itemList.deliveryTime.toString(),
                          hintStyle:
                              TextStyle(color: colorTextHint, fontSize: 16),
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
                              "Save",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            _addDelCharges.updateDelivery(
                                _deliveryMinRadiusController.text.toString(),
                                _deliveryMaxRadiusController.text.toString(),
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
                            child: Text(
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
