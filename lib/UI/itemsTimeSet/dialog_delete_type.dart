// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/itemsTimeSet/repository/delete_data_repository.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/UI/menu/dialog_type_list_view.dart';

class DialogDeleteType extends StatefulWidget {
  TypeListDataModel model;
  VoidCallback onDialogClose;
  late String delId;

  DialogDeleteType({Key? key, required this.model, required this.onDialogClose}) : super(key: key);

  @override
  _DialogDeleteTypeState createState() => _DialogDeleteTypeState();
}

class _DialogDeleteTypeState extends State<DialogDeleteType> {
  late DeleteDataRepository _deleteDataRepository;

  @override
  void initState() {
    super.initState();
    _deleteDataRepository = DeleteDataRepository(context, widget);
  }

  callDeleteType() async {
    _deleteDataRepository.deleteMenuItemData(widget.model.id);
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
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            decoration: BoxDecoration(
                color: colorTextWhite, borderRadius: BorderRadius.circular(13)),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  widget.model.name,
                  style: const TextStyle(
                      color: colorButtonYellow,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Are you sure Delete this ${widget.model.type}?",
                  style: const TextStyle(
                      color: colorTextBlack,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 30, right: 10),
                            decoration: BoxDecoration(
                                color: colorLightRed,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            callDeleteType();
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
}
