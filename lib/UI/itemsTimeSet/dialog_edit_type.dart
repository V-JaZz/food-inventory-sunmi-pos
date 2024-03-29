// ignore_for_file: unused_field, must_be_immutable

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/itemsTimeSet/edit_schedule_zone.dart';
import 'package:food_inventory/constant/app_util.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/ui/menu/model/add_type_model.dart';
import 'model/time_zone_response_list.dart';

class DialogEditTimeZone extends StatefulWidget {
  dynamic type;
  TimeZoneItemData itemList;
  VoidCallback onDialogClose;

  DialogEditTimeZone(
      {Key? key, this.type, required this.onDialogClose, required this.itemList}) : super(key: key);

  @override
  _DialogAddNewTypeState createState() => _DialogAddNewTypeState();
}

class _DialogAddNewTypeState extends State<DialogEditTimeZone> {
  final List<AddTypeModel> _typeModel = [];
  final _dropDownValue = "";
  final _dropDownData = "";
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _typeModel.add(AddTypeModel(
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        TextEditingController()));
  }

  // callAddCategoryApi() async {
  //   _categoryRepository.addCategory(_typeModel,);
  // }

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
                          : "Edit Time",
                      style: const TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: _typeModel.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (listContext, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffDFDDEF),
                                    border: Border.all(
                                        color: colorFieldBorder, width: 1),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                            margin: const EdgeInsets.all(18),
                                            child: TextField(
                                              maxLines: 1,
                                              controller: _textController,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  color: colorTextBlack),
                                              cursorColor: colorTextBlack,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  isDense: true,
                                                  hintText:
                                                      "${widget.itemList.name}",
                                                  hintStyle: const TextStyle(
                                                      color: colorTextHint,
                                                      fontSize: 18),
                                                  border: InputBorder.none),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(
                                      // top: 3,
                                      ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffDFDDEF),
                                    border: Border.all(
                                        color: colorFieldBorder, width: 1),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            // height: 20,
                                            margin: const EdgeInsets.all(15),
                                            child: widget.itemList.zoneGroup ==
                                                    null
                                                ? const Text('Not Found')
                                                : Text(
                                                    widget.itemList.zoneGroup
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: colorTextHint,
                                                        fontSize: 18),
                                                  )),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                      height: 1,
                      color: colorTextHint, // Custom style
                    );
                  },
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
                              dialogToppingSelection(
                                  _textController.text.toString(),
                                  widget.itemList.zoneGroup.toString(),
                                  false,
                                  context,
                                  widget.itemList);
                            } else {}
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

  void dialogToppingSelection(String name, String addData, bool isEdit,
      BuildContext mainContext, itemList) {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (
        dialogListContext,
      ) {
        return DialogEditScheduleProduct(
          onDialogClose: () {
            widget.onDialogClose();
          },
          name: addData,
          nameEdit: name,
          itemList: widget.itemList,
          category: widget.itemList.zoneGroup.toString(),
        );
      },
    );
  }
}
