// ignore_for_file: unused_import, unnecessary_const

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/dashboard/forms/Allergy/repository/allergy_repository.dart';
import 'package:food_inventory/UI/dashboard/forms/Allergy/seeAll.dart';
import 'package:food_inventory/UI/dashboard/forms/Toppings/seeAll.dart';
import 'package:food_inventory/UI/dashboard/forms/Toppings/repository/topping_repository.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'edit_topping.dart';

// ignore: must_be_immutable
class AddToppings extends StatefulWidget {
  VoidCallback onDialogClose;
  late String delId;

  AddToppings({Key? key, required this.onDialogClose}) : super(key: key);
  @override
  State<AddToppings> createState() => _AddToppingsState();
}

class _AddToppingsState extends State<AddToppings> {
  late ToppingsRepository _toppingRepository;
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _toppingRepository = ToppingsRepository(context);
    _nameController = TextEditingController();
    _priceController = TextEditingController();
  }

  callAddToppingsApi() async {
    _toppingRepository.addToppingData(
      _nameController.text,
      _priceController.text,
    );
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
                    const Text(
                      "Add Toppings",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        ToppingsListData("See All Toppings");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: colorButtonYellow,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: const Text("See All Toppings",
                            style: TextStyle(
                                color: colorTextWhite,
                                fontWeight: FontWeight.w500,
                                fontSize: 10)),
                      ),
                    )
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
                    borderRadius: const BorderRadius.all(const Radius.circular(5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              maxLines: 1,
                              controller: _nameController,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: colorTextBlack),
                              cursorColor: colorTextBlack,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  isDense: true,
                                  hintText: "Enter Topping Name",
                                  hintStyle: const TextStyle(
                                      color: colorTextHint, fontSize: 16),
                                  border: InputBorder.none),
                            )),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          height: MediaQuery.of(context).size.height * 0.065,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: colorGreyDF),
                          child: const Text("€",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ))),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            maxLines: 1,
                            controller: _priceController,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: colorTextBlack),
                            cursorColor: colorTextBlack,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                            decoration: const InputDecoration(
                                contentPadding: const EdgeInsets.all(0),
                                isDense: true,
                                hintText: "0,00",
                                hintStyle: const TextStyle(
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
                            //   showMessage("Enter Allergy Name", context);
                            // } else if (_descriptionController.text.isEmpty) {
                            //   showMessage("Enter Discription Name", context);
                            // } else if (_discountController.text.isEmpty) {
                            //   showMessage("Enter Discount Name", context);
                            // } else {
                            //   callAddAllergyApi();
                            // }
                            callAddToppingsApi();
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

  void ToppingsListData(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return ToppingsList(
          onDialogClose: () {},
        );
      },
    );
  }
}
