// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/dashboard/dialog_menu_data_selection.dart';
import 'package:food_inventory/UI/dashboard/forms/Allergy/repository/allergy_repository.dart';
import 'package:food_inventory/UI/dashboard/forms/Allergy/seeAll.dart';
import 'package:food_inventory/UI/dashboard/forms/Option/repository/option_repository.dart';
import 'package:food_inventory/UI/dashboard/forms/Option/seeAll.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'edit_option.dart';

// ignore: must_be_immutable
class AddOption extends StatefulWidget {
  VoidCallback onDialogClose;
  late String delId;

  AddOption({Key? key, required this.onDialogClose}) : super(key: key);
  @override
  State<AddOption> createState() => _AddOptionState();
}

class _AddOptionState extends State<AddOption> {
  late SelectionMenuDataList _toppingGrpData;

  late OptionRepository _optionRepository;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _optionRepository = OptionRepository(context);
    _nameController = TextEditingController();
    _toppingGrpData = SelectionMenuDataList(
        "", "Default Topping Group", "", 0.0, 0.0, "", "", false);
  }

  callAddOptionApi() async {
    if (_toppingGrpData.name == "Default Topping Group") {
      print("object");
      _optionRepository.addOption(_nameController.text, null, 0.0, 0.0);
    } else {
      print("false");
      _optionRepository.addOption(
          _nameController.text, _toppingGrpData.id, 0.0, 0.0);
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
                      "Add Option",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        OptionListData("See All Option");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: colorButtonYellow,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: const Text("See All Option",
                            style: TextStyle(
                                color: colorTextWhite,
                                fontWeight: FontWeight.w500,
                                fontSize: 13)),
                      ),
                    )
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
                          hintText: "Enter New Option Name",
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
                          : _toppingGrpData.name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: _toppingGrpData == null
                              ? colorTextHint
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
                            callAddOptionApi();
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

  void OptionListData(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return OptionList(
          onDialogClose: () {},
        );
      },
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
