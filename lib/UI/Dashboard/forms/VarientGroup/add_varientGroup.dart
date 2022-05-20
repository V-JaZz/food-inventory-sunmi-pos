// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/Dashboard/forms/Varient/repository/veriant_repository.dart';
import 'package:food_inventory/UI/dashboard/forms/VarientGroup/repository/variant_group.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/validation_util.dart';
import '../Allergy/repository/allergy_repository.dart';
import 'varientList.dart';
import 'seeAll.dart';

// ignore: must_be_immutable
class AddVarientGroups extends StatefulWidget {
  VoidCallback onDialogClose;
  late String delId;

  AddVarientGroups({Key? key, required this.onDialogClose}) : super(key: key);
  @override
  State<AddVarientGroups> createState() => _AddVarientGroupsState();
}

class _AddVarientGroupsState extends State<AddVarientGroups> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
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
                      "Add Allergy Group",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        allergyListData("See All Groups");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: colorButtonYellow,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: const Text("See All Groups",
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
                          hintText: "Enter New Allergy Group Name",
                          hintStyle: TextStyle(
                              color: colorTextHint,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none),
                    )),
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
                              "Next",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            if (_nameController.text.isEmpty) {
                              showMessage("Enter Topping Group Name", context);
                            } else {
                              Navigator.of(context).pop();
                              allergys(TYPE_ALLERGY_GROUP,
                                  _nameController.text.toString());
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

  void allergyListData(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return VarientListGroup(
          onDialogClose: () {},
        );
      },
    );
  }

  void allergys(String type, String name) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return VarientListPage(
          onDialogClose: () {},
          name: name,
          id: '',
          type: "Add",
          ids: const [],
        );
      },
    );
  }
}
