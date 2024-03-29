// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/dashboard/dialog_menu_data_selection.dart';
import 'package:food_inventory/UI/dashboard/forms/Allergy/repository/allergy_repository.dart';
import 'package:food_inventory/UI/dashboard/forms/Allergy/see_all.dart';
import 'package:food_inventory/UI/dashboard/forms/Varient/see_all.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'edit_varient.dart';
import 'repository/veriant_repository.dart';

// ignore: must_be_immutable
class AddNewVarient extends StatefulWidget {
  VoidCallback onDialogClose;
  late String delId;

  AddNewVarient({Key? key, required this.onDialogClose}) : super(key: key);
  @override
  State<AddNewVarient> createState() => _AddNewVarientState();
}

class _AddNewVarientState extends State<AddNewVarient> {
  late VariantRepository _varientRepository;
  late SelectionMenuDataList _varientData;

  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _varientRepository = VariantRepository(context);
    _nameController = TextEditingController();
    _varientData = SelectionMenuDataList(
        "", "Default Veriant Group", "", 0.0, 0.0, "", "", false);
  }

  callAddAllergyApi() async {
    if (_varientData.name == 'Default Veriant Group') {
      _varientRepository.addVarient(_nameController.text, null);
    } else {
      _varientRepository.addVarient(_nameController.text, _varientData.id);
    }
    // imageupload(selectedBanner!);
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
                  children: [
                    const Text(
                      "Add New Varient",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        varientList("See All Varient");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: colorButtonYellow,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: const Text("See All",
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
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: colorTextBlack),
                      cursorColor: colorTextBlack,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: "Varient Name",
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
                    selectTypeData(TYPE_VARIANT_GROUP, -1, _varientData);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),
                    child: Text(
                      _varientData.name.isEmpty
                          ? "Select Varient Group"
                          : _varientData.name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: _varientData.name.isEmpty
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
                            // if (_nameController.text.isEmpty) {
                            //   showMessage("Enter Allergy Name", context);
                            // } else if (_selectVarientController.text.isEmpty) {
                            //   showMessage("Enter Discription Name", context);
                            // } else if (_discountController.text.isEmpty) {
                            //   showMessage("Enter Discount Name", context);
                            // } else {
                            //   callAddAllergyApi();
                            // }
                            callAddAllergyApi();
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

  void varientList(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return VarientList(
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
              _varientData = dataModel;
            });
          },
          optionListSize: 10,
          variantListSize: 10,
        );
      },
    );
  }
}
