// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:food_inventory/UI/restaurantTimeSet/repository/updateStatusRepository.dart';
import 'package:food_inventory/constant/colors.dart';
import 'model/restaurant_time_slot_response_model.dart';

class DialogEditTimeZoneStatus extends StatefulWidget {
  // var type,name;
  VoidCallback onDialogClose;
  TimeSlotItemData itemList;
  dynamic type;

  DialogEditTimeZoneStatus(
      {Key? key, this.type, required this.onDialogClose, required this.itemList}) : super(key: key);

  @override
  _DialogDeleteTypeState createState() => _DialogDeleteTypeState();
}

class _DialogDeleteTypeState extends State<DialogEditTimeZoneStatus> {
  late UpdateStatusTimeZoneRepository _statusRepository;

  @override
  void initState() {
    super.initState();
    _statusRepository = UpdateStatusTimeZoneRepository(context, widget);
  }

  callStatusType() async {
    if (widget.itemList.isActive!) {
      _statusRepository.updateStatusTimeZone(false, widget.itemList);
    } else {
      _statusRepository.updateStatusTimeZone(true, widget.itemList);
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
                Text(
                  widget.itemList.name.toString(),
                  style: const TextStyle(
                      color: colorButtonYellow,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Are you sure to update the status ?",
                  style: TextStyle(
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
                              "Update",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            callStatusType();
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
