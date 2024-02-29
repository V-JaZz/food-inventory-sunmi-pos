// ignore_for_file: must_be_immutable, unused_field, unused_local_variable, unnecessary_null_comparison, must_call_super

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/restaurantTimeSet/repository/editTimeRepository.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import 'model/restaurant_time_slot_response_model.dart';

class DialogEditTimeSlot extends StatefulWidget {
  // var type, name;
  dynamic data;
  VoidCallback onDialogClose;
  TimeSlotItemData itemList;

  DialogEditTimeSlot(
      {Key? key, required this.onDialogClose,
      required this.itemList,
      required this.data}) : super(key: key);

  @override
  _DialogScheduleProductState createState() => _DialogScheduleProductState();
}

class _DialogScheduleProductState extends State<DialogEditTimeSlot> {
  final _dropDownValue = "";

  String timeStart = "";
  String timeEnd = "";
  late String dateTime;
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  var color1 = Colors.grey;
  var color2 = Colors.grey;
  var color3 = Colors.grey;
  var color4 = Colors.grey;
  var color5 = Colors.grey;
  var color6 = Colors.grey;
  var color7 = Colors.grey;

  var colorGrey = Colors.grey;
  var colorGreen = Colors.green;

  bool valueSecond = false;

  bool isDataLoad = false;
  bool isDataLoaded = false;
  var _valueC = false;
  late final DateRangePickerController _multipleDatePicker =
      DateRangePickerController();

  List<DateTime> _specialDates = [];
  List<String> data = [];
  List<String> days = [];
  List<String> items = [];
  final List<DateTime> _selectedDate = [];
  final List<DateTime> _selected = [];
  final String _dateCount = '';
  final String _range = '';
  final String _rangeCount = '';
  late EditTimeZoneRepository _addItemsRepository;
  late TimeOfDay selectedStartTime, selectedEndTime;
  TextEditingController slotController = TextEditingController();

  @override
  void initState() {
    _addItemsRepository = EditTimeZoneRepository(context, widget);
    selectedStartTime = TimeOfDay.now();
    selectedEndTime = TimeOfDay.now();
    var dateItem = widget.itemList.holidayDates!;
    for (int i = 0; i < widget.itemList.holidayDates!.length; i++) {
      var _time = widget.itemList.holidayDates![i].toString();
      // _time=Color2
      _specialDates = <DateTime>[
        DateTime(
            int.parse(_time.replaceAll('/', '-').split('-')[2]),
            int.parse(_time.replaceAll('/', '-').split('-')[1]),
            int.parse(_time.replaceAll('/', '-').split('-')[0])),
      ];
      setState(() {
        _selectedDate.addAll(_specialDates);
        data.add(_time);
      });
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Update Restaurant Time Zone",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(223, 221, 239, 1),
                          border: Border.all(color: colorFieldBorder, width: 1),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Container(
                            margin: const EdgeInsets.all(18),
                            child: TextField(
                              maxLines: 1,
                              controller: slotController,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: colorTextBlack),
                              cursorColor: colorTextBlack,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  isDense: true,
                                  hintText: widget.itemList.name,
                                  hintStyle: const TextStyle(
                                      color: colorTextHint, fontSize: 16),
                                  border: InputBorder.none),
                            ))),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 19),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: const BoxDecoration(
                                  color: Color(0xffDFDDEF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        maxLines: 1,
                                        enabled: false,
                                        controller: TextEditingController(
                                            text: timeStart.isEmpty
                                                ? widget.itemList.startTime
                                                : formatTimeOfDay(
                                                    selectedStartTime,
                                                    'hh:mm a')),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: colorTextBlack),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          isDense: true,
                                          hintText: "Start Time",
                                          hintStyle: TextStyle(
                                              color: colorLightGrey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                          border: InputBorder.none,
                                        ),
                                        cursorColor: colorTextBlack,
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      icClock2,
                                      color: colorButtonYellow,
                                      width: 14,
                                      height: 14,
                                    ),
                                  ],
                                ),
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _selectStartTime();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "To",
                            style: TextStyle(
                                color: colorTextBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: const BoxDecoration(
                                  color: Color(0xffDFDDEF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        maxLines: 1,
                                        enabled: false,
                                        controller: TextEditingController(
                                            text: timeEnd.isEmpty
                                                ? widget.itemList.endTime
                                                : formatTimeOfDay(
                                                    selectedEndTime,
                                                    'hh:mm a')),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: colorTextBlack),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          isDense: true,
                                          hintText: "End Time",
                                          hintStyle: TextStyle(
                                              color: colorLightGrey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                          border: InputBorder.none,
                                        ),
                                        cursorColor: colorTextBlack,
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                    GestureDetector(
                                      child: SvgPicture.asset(
                                        icClock2,
                                        color: colorButtonYellow,
                                        width: 14,
                                        height: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _selectEndTime();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Select Days ",
                          style: TextStyle(
                              color: colorTextBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            const Text(
                              "Select All",
                              style: TextStyle(
                                  color: colorTextBlack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                            Checkbox(
                              value: _valueC,
                              checkColor: Colors.grey,
                              onChanged: (bool? value) {
                                setState(() {
                                  _valueC = value!;
                                  if (value) {
                                    if (days.isNotEmpty) {
                                      days.clear();
                                    }
                                    if (widget.itemList.days!.isNotEmpty) {
                                      widget.itemList.days!.clear();
                                    }
                                    color1 = Colors.green;
                                    color2 = Colors.green;
                                    color3 = Colors.green;
                                    color4 = Colors.green;
                                    color5 = Colors.green;
                                    color6 = Colors.green;
                                    color7 = Colors.green;
                                    days.add("Sunday");
                                    days.add("Monday");
                                    days.add("Tuesday");
                                    days.add("Wednesday");
                                    days.add("Thursday");
                                    days.add("Friday");
                                    days.add("Saturday");
                                  } else {
                                    color1 = Colors.grey;
                                    color2 = Colors.grey;
                                    color3 = Colors.grey;
                                    color4 = Colors.grey;
                                    color5 = Colors.grey;
                                    color6 = Colors.grey;
                                    color7 = Colors.grey;
                                    if (days.isNotEmpty) {
                                      days.clear();
                                    }

                                    if (widget.itemList.days!.isNotEmpty) {
                                      widget.itemList.days!.clear();
                                    }
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                        child: Row(children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Sunday")) {
                                  widget.itemList.days!.remove("Sunday");
                                }
                                if (color1 == Colors.grey) {
                                  color1 = Colors.green;

                                  days.add("Sunday");
                                } else if (color1 == Colors.green) {
                                  color1 = Colors.grey;
                                  if (days.contains("Sunday")) {
                                    days.remove("Sunday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Sunday")
                                      ? (color1 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color1,
                              radius: 17,
                              child: const Center(
                                child: Text(
                                  "S",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Monday")) {
                                  widget.itemList.days!.remove("Monday");
                                }
                                if (color2 == Colors.grey) {
                                  color2 = Colors.green;
                                  days.add("Monday");
                                } else if (color2 == Colors.green) {
                                  color2 = Colors.grey;
                                  if (days.contains("Monday")) {
                                    days.remove("Monday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Monday")
                                      ? (color2 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color2,
                              radius: 17,
                              child: const Center(
                                child: Text(
                                  "M",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Tuesday")) {
                                  widget.itemList.days!.remove("Tuesday");
                                }
                                if (color3 == Colors.grey) {
                                  color3 = Colors.green;
                                  days.add("Tuesday");
                                } else if (color3 == Colors.green) {
                                  color3 = Colors.grey;
                                  days.remove("Tuesday");
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Tuesday")
                                      ? (color3 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color3,
                              radius: 17,
                              child: const Center(
                                child: Text(
                                  "T",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!
                                    .contains("Wednesday")) {
                                  widget.itemList.days!.remove("Wednesday");
                                }
                                if (color4 == Colors.grey) {
                                  color4 = Colors.green;

                                  days.add("Wednesday");
                                } else if (color4 == Colors.green) {
                                  color4 = Colors.grey;
                                  if (days.contains("Wednesday")) {
                                    days.remove("Wednesday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Wednesday")
                                      ? (color4 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color4,
                              radius: 17,
                              child: const Center(
                                child: Text(
                                  "W",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!
                                    .contains("Thursday")) {
                                  widget.itemList.days!.remove("Thursday");
                                }
                                if (color5 == Colors.grey) {
                                  color5 = Colors.green;
                                  days.add("Thursday");
                                } else if (color5 == Colors.green) {
                                  color5 = Colors.grey;
                                  if (days.contains("Thursday")) {
                                    days.remove("Thursday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Thursday")
                                      ? (color5 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color5,
                              radius: 17,
                              child: const Center(
                                child: Text(
                                  "T",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Friday")) {
                                  widget.itemList.days!.remove("Friday");
                                }
                                if (color6 == Colors.grey) {
                                  color6 = Colors.green;
                                  days.add("Friday");
                                } else if (color6 == Colors.green) {
                                  color6 = Colors.grey;
                                  if (days.contains("Friday")) {
                                    days.remove("Friday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Friday")
                                      ? (color6 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color6,
                              radius: 17,
                              child: const Center(
                                child: Text(
                                  "F",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!
                                    .contains("Saturday")) {
                                  widget.itemList.days!.remove("Saturday");
                                }
                                if (color7 == Colors.grey) {
                                  color7 = Colors.green;
                                  days.add("Saturday");
                                } else if (color7 == Colors.green) {
                                  color7 = Colors.grey;
                                  if (days.contains("Saturday")) {
                                    days.remove("Saturday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Saturday")
                                      ? (color7 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : color7,
                              radius: 17,
                              child: const Center(
                                child: Text(
                                  "S",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ])),
                    const Text(
                      "Add Holidays",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width * 0.35,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: colorButtonYellow,
                          borderRadius: BorderRadius.circular(30)),
                      child: GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              icCalendar,
                              color: colorTextWhite,
                              width: 14,
                              height: 14,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Add Holidays",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          // _selectDate(context);
                          dialogDateType();
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.only(left: 30, right: 10),
                                decoration: BoxDecoration(
                                    color: colorGreen,
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
                                if (widget.itemList.days!.length != null) {
                                  for (String dataDays
                                      in widget.itemList.days!) {
                                    days.add(dataDays);
                                  }
                                }
                                dynamic _holidayData;
                                setState(() {
                                  _holidayData = data.toSet().toList();
                                });
                                _addItemsRepository.editTimeZone(
                                    timeStart,
                                    timeEnd,
                                    days,
                                    widget.itemList,
                                    slotController.text.toString(),
                                    _holidayData);
                              },
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.only(left: 8, right: 30),
                                decoration: BoxDecoration(
                                    color: colorGrey,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Back",
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
              ],
            ),
          )),
    );
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      useRootNavigator: false,
      confirmText: "Set",
      cancelText: "Cancel",
      routeSettings: const RouteSettings(),
      initialTime: selectedStartTime,
      builder: (BuildContext _context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(_context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedStartTime = picked;
        timeStart = formatTimeOfDay(selectedStartTime, 'HH:mm');
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      useRootNavigator: false,
      confirmText: "Set",
      cancelText: "Cancel",
      routeSettings: const RouteSettings(),
      initialTime: selectedEndTime,
      builder: (BuildContext _context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(_context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedEndTime = picked;
        timeEnd = formatTimeOfDay(selectedEndTime, 'HH:mm');
      });
    }
  }

  void dialogDateType() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
            backgroundColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            insetPadding: const EdgeInsets.all(15.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.46,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                  color: colorTextWhite,
                  borderRadius: BorderRadius.circular(13)),
              child: Column(
                children: [
                  SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    controller: _multipleDatePicker,
                    viewSpacing: 10,
                    headerHeight: 40,
                    showActionButtons: false,
                    showNavigationArrow: true,
                    selectionShape: DateRangePickerSelectionShape.rectangle,
                    selectionRadius: 10,
                    todayHighlightColor: colorTextWhite,
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      todayTextStyle: const TextStyle(color: colorTextWhite),
                      todayCellDecoration: BoxDecoration(
                          color: const Color.fromRGBO(81, 200, 0, 1),
                          borderRadius: BorderRadius.circular(10)),
                      cellDecoration: BoxDecoration(
                          color: const Color.fromRGBO(251, 245, 232, 1),
                          borderRadius: BorderRadius.circular(10)),
                      specialDatesDecoration: BoxDecoration(
                          color: colorLightRed,
                          borderRadius: BorderRadius.circular(10)),
                      specialDatesTextStyle:
                          const TextStyle(color: Colors.white),
                    ),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        dayFormat: 'EEE',
                        enableSwipeSelection: false,
                        specialDates: _selectedDate,
                        viewHeaderStyle: const DateRangePickerViewHeaderStyle(
                          textStyle: TextStyle(
                              color: colorTextWhite,
                              fontWeight: FontWeight.w700,
                              fontSize: 12),
                          backgroundColor: colorButtonBlue,
                        )),
                    headerStyle: DateRangePickerHeaderStyle(
                      backgroundColor: colorTextWhite,
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                          color: colorGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                    selectionTextStyle: const TextStyle(
                        color: colorTextWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 12),
                    selectionColor: colorGreen,
                    startRangeSelectionColor: colorGreen,
                    endRangeSelectionColor: colorGreen,
                    rangeSelectionColor: colorGreen,
                    rangeTextStyle:
                        const TextStyle(color: Colors.black, fontSize: 15),
                    view: DateRangePickerView.month,
                    selectionMode: DateRangePickerSelectionMode.multiple,
                    enablePastDates: false,
                    onSubmit: (val) {
                      Navigator.of(context).pop();
                    },
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 30, right: 10),
                            decoration: BoxDecoration(
                                color: colorGreen,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                  color: colorTextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
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
                              "Back",
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
                  )
                ],
              ),
            ));
      },
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      final List<DateTime> selectedDates = args.value;
      var formattedDate = '';
      var remove = '';
      for (int i = 0; selectedDates.length > i; i++) {
        formattedDate = DateFormat('dd/MM/yyyy').format(selectedDates[i]);
      }
      for (String datatype in data) {
        if (datatype == formattedDate) {
          remove = formattedDate;
        } else {
          formattedDate = formattedDate;
        }
      }
      data.add(formattedDate);

      //=============================================need to work here ===========================================================
      data.remove(remove);
      data.remove(remove);
      //=============================================need to work here ===========================================================
    });
  }
}
