import 'package:flutter/material.dart';
import 'package:food_inventory/UI/dashboard/dialog_menu_data_selection.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'repository/veriant_repository.dart';

class EditVarient extends StatefulWidget {
  VoidCallback onDialogClose;
  String id;
  String name;
  String varientName;
  String varientId;

  EditVarient(
      {Key? key,
      required this.onDialogClose,
      required this.id,
      required this.name,
      required this.varientName,
      required this.varientId})
      : super(key: key);
  @override
  State<EditVarient> createState() => _EditVarientState();
}

class _EditVarientState extends State<EditVarient> {
  late VariantRepository _varientRepository;
  String id = "";
  late TextEditingController _nameController;
  SelectionMenuDataList? _varientGrpData;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    _varientRepository = VariantRepository(context);
    _nameController = TextEditingController(text: widget.name);
    _varientGrpData = SelectionMenuDataList(
        defaultValue(widget.varientId.toString(), ""),
        defaultValue(widget.varientName.toString(), ""),
        "",
        0.0,
        0.0,
        defaultValue(widget.varientName.toString(), ""),
        defaultValue(widget.varientId.toString(), ""),
        false);
  }

  callEditVarientApi() async {
    _varientRepository.editVarient(
      _nameController.text.toString().trim(),
      _varientGrpData!.id,
      widget.id,
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
                      "Edit Varient",
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
                    selectTypeData(TYPE_VARIANT_GROUP, -1, _varientGrpData);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(223, 221, 239, 1),
                        borderRadius: BorderRadius.circular(05)),
                    child: Text(
                      _varientGrpData == null
                          ? "Select Varient Group"
                          : _varientGrpData!.name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: _varientGrpData == null
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
                            callEditVarientApi();
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
              _varientGrpData = dataModel;
            });
          },
          optionListSize: 10,
          variantListSize: 10,
        );
      },
    );
  }
}
