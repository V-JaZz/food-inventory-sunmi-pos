

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/dashboard/dialog_menu_data_selection.dart';
import 'package:food_inventory/UI/dashboard/forms/Option/repository/option_repository.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/validation_util.dart';

// ignore: must_be_immutable
class EditOption extends StatefulWidget {
  VoidCallback onDialogClose;
  String id;
  String name;
  String toppingName;
  String toppingId;

  EditOption({
    Key? key,
    required this.onDialogClose,
    required this.id,
    required this.name,
    required this.toppingName,
    required this.toppingId,
  }) : super(key: key);
  @override
  State<EditOption> createState() => _EditOptionState();
}

class _EditOptionState extends State<EditOption> {
  SelectionMenuDataList? _toppingGrpData;
  late OptionRepository _optionRepository;
  String id = "";
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    _toppingGrpData = SelectionMenuDataList(
        defaultValue(widget.toppingId.toString(), ""),
        defaultValue(widget.toppingName.toString(), ""),
        "",
        0.0,
        0.0,
        defaultValue(widget.toppingName.toString(), ""),
        defaultValue(widget.toppingId.toString(), ""),
        false);
    _optionRepository = OptionRepository(context);
    _nameController = TextEditingController(text: widget.name);
  }

  callEditOptionApi() async {
    _optionRepository.editOption(widget.id,
        _nameController.text.toString().trim(), _toppingGrpData!.id, 0.0, 0.0);
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
                      "Edit Option",
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
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),

                    // margin: EdgeInsets.only(left: 18),
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
                          hintText: "Option Name",
                          hintStyle: TextStyle(
                              color: colorTextHint,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none),
                    )),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    selectTypeData(TYPE_GROUP_TOPPINGS, -1, _toppingGrpData);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),
                    child: Text(
                      _toppingGrpData == null
                          ? "Select Topping Group"
                          : _toppingGrpData!.name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: _toppingGrpData == null
                              ? colorTextBlack
                              : colorTextBlack),
                    ),
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
                            // } else if (_descriptionController.text.isEmpty) {
                            //   showMessage("Enter Discription Name", context);
                            // } else if (_discountController.text.isEmpty) {
                            //   showMessage("Enter Discount Name", context);
                            // } else {
                            //   callAddCategoryApi();
                            // }
                            callEditOptionApi();
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

  void selectTypeData(
      String type, int index, SelectionMenuDataList? selectedData) {
    showDialog(
      context: context,
      builder: (selectDataDialogContext) {
        return DialogMenuDataSelection(
          type: type,
          selectedData: selectedData,
          onSelectData: (SelectionMenuDataList dataModel) {
            setState(() {
              _toppingGrpData = dataModel;
            });
          },
          optionListSize: 10,
          variantListSize: 10,
        );
      },
    );
  }
}
