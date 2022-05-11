import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_inventory/UI/dashboard/DashBoard%20Data/Allergy/repository/allergy_repository.dart';
import 'package:food_inventory/UI/dashboard/DashBoard%20Data/Option/repository/option_repository.dart';
import 'package:food_inventory/UI/dashboard/DashBoard%20Data/Toppings/repository/topping_repository.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/validation_util.dart';

class EditToppings extends StatefulWidget {
  VoidCallback onDialogClose;
  String id;
  String name;
  String price;

  EditToppings({
    Key? key,
    required this.onDialogClose,
    required this.id,
    required this.name,
    required this.price,
  }) : super(key: key);
  @override
  State<EditToppings> createState() => _EditToppingsState();
}

class _EditToppingsState extends State<EditToppings> {
  late ToppingsRepository _toppingRepository;
  String id = "";
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    _toppingRepository = ToppingsRepository(context);
    _nameController = TextEditingController(text: widget.name);
    _priceController = TextEditingController(text: widget.price);
  }

  callEditToppingsApi() async {
    _toppingRepository.editTopping(
        widget.id,
        _nameController.text.toString().trim(),
        _priceController.text.toString().trim());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(11, 4, 58, 0.7)),
      child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          insetPadding: const EdgeInsets.all(15.0),
          elevation: 0,
          // backgroundColor: Colors.transparent,
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.65,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: colorTextWhite, borderRadius: BorderRadius.circular(13)),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      "Edit Toppings",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.12,
                  height: MediaQuery.of(context).size.height * 0.065,
                  // margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: colorFieldBG,
                    border: Border.all(color: colorFieldBorder, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            // color: Colors.red,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            // margin: EdgeInsets.all(18),
                            child: TextField(
                              maxLines: 1,
                              controller: _nameController,
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: colorTextBlack),
                              cursorColor: colorTextBlack,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  isDense: true,
                                  hintText: "Enter Topping Name",
                                  hintStyle: TextStyle(
                                      color: colorTextHint, fontSize: 16),
                                  border: InputBorder.none),
                            )),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          height: MediaQuery.of(context).size.height * 0.065,
                          alignment: Alignment.center,
                          // padding: EdgeInsets.all(19),
                          decoration: BoxDecoration(color: colorGreyDF),
                          child: Text("€",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ))),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            maxLines: 1,
                            controller: _priceController,
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
                                hintText: "0,00",
                                hintStyle: TextStyle(
                                    color: colorTextHint, fontSize: 16),
                                border: InputBorder.none),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
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
                            // if (_nameController.text.isEmpty) {
                            //   showMessage("Enter Category Name", context);
                            // } else if (_priceController.text.isEmpty) {
                            //   showMessage("Enter Discription Name", context);
                            // } else if (_discountController.text.isEmpty) {
                            //   showMessage("Enter Discount Name", context);
                            // } else {
                            //   callAddCategoryApi();
                            // }
                            callEditToppingsApi();
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
                            Navigator.of(context).pop();
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
