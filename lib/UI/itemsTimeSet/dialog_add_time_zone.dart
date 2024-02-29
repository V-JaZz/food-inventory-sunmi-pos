// ignore_for_file: unused_field, must_be_immutable

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/dashboard/forms/Category/repository/category_repository.dart';
import 'package:food_inventory/UI/dashboard/forms/Option/repository/option_repository.dart';
import 'package:food_inventory/UI/dashboard/forms/Toppings/repository/topping_repository.dart';
import 'package:food_inventory/UI/itemsTimeSet/dialog_schedule_product.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/validation_util.dart';

class DialogAddNewType extends StatefulWidget {
  dynamic type;
  VoidCallback onDialogClose;

  DialogAddNewType({Key? key, this.type, required this.onDialogClose}) : super(key: key);

  @override
  _DialogAddNewTypeState createState() => _DialogAddNewTypeState();
}

class _DialogAddNewTypeState extends State<DialogAddNewType> {
  late CategoryRepository _categoryRepository;
  late OptionRepository _optionRepository;
  late ToppingsRepository _addTypeRepository;
  // List<AddTypeModel> _typeModel = [];
  var _dropDownValue = "";
  var _dropDownData = "";
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    _categoryRepository = CategoryRepository(context);
    _optionRepository = OptionRepository(context);
    _addTypeRepository = ToppingsRepository(context);
  }

  callAddCategoryApi() async {
    // _categoryRepository.addCategory(_typeModel,);
  }

  callAddOptionsApi() async {
    _optionRepository.addOption("", "", null, null);
  }

  callAddToppingApi() async {
    _addTypeRepository.addToppingData("", "");
  }

  callAddTypeData() {
    if (widget.type == TYPE_CATEGORY) {
      callAddCategoryApi();
    } else if (widget.type == TYPE_OPTION) {
      callAddOptionsApi();
    } else if (widget.type == TYPE_TOPPINGS) {
      callAddToppingApi();
    } else {
      Navigator.pop(context);
    }
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.type == TYPE_CATEGORY
                          ? "Add New ${widget.type}"
                          : "Add New Time",
                      style: const TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(223, 221, 239, 1),
                          borderRadius: BorderRadius.circular(05)),
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
                            hintText: "Enter New Time Offer Name",
                            hintStyle:
                                TextStyle(color: colorTextHint, fontSize: 16),
                            border: InputBorder.none),
                      )),
                  const SizedBox(height: 10),
                  Container(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(223, 221, 239, 1),
                          borderRadius: BorderRadius.circular(05)),
                      child: DropdownButton(
                        hint: _dropDownValue.isEmpty
                            ? const Text('--select--')
                            : Text(
                                _dropDownValue,
                              ),
                        isExpanded: true,
                        underline: const SizedBox(),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          height: 1.5,
                        ),
                        iconSize: 18.0,
                        items: ['Product', 'Category'].map(
                          (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          setState(
                            () {
                              _dropDownValue = val.toString();
                              _dropDownData = val.toString();
                            },
                          );
                        },
                      )),
                ]),
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
                            child: Text(
                              widget.type == TYPE_TOPPINGS ? "Next" : "Add",
                              style: const TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            if (widget.type == TYPE_TOPPINGS) {
                              if (_dropDownData.isEmpty) {
                                showMessage("Select product/category", context);
                              } else {
                                dialogToppingSelection(
                                    _nameController.text, false, context);
                              }
                            } else {
                              callAddTypeData();
                            }
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

  // void dialogTypeListView(String type, BuildContext mainDialogContext) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (dialogListContext) {
  //       return DialogTypeListView(
  //         type: type,
  //         onDialogClose: () {
  //           Navigator.pop(context);
  //         },
  //       );
  //     },
  //   );
  // }

  void dialogToppingSelection(
      String addData, bool isEdit, BuildContext mainContext) {
    if (addData.toString().trim().isEmpty) {
      showMessage("Enter Time Offer Name", context);
    } else {
      // Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (
          dialogListContext,
        ) {
          return DialogScheduleProduct(
            onDialogClose: () {
              widget.onDialogClose();
            },
            name: addData.toString(),
            category: _dropDownData,
          );
        },
      );
    }
  }
}
