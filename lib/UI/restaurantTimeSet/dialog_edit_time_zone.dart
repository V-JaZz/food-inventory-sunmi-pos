// ignore_for_file: must_be_immutable, unused_field, unused_local_variable, unnecessary_null_comparison, must_call_super

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/restaurentTimeSet/repository/editTimeRepository.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import 'model/restaurantTimeSlotResponseModel.dart';

class DialogEditTimeSlot extends StatefulWidget {
  // var type, name;
  var data;
  VoidCallback onDialogClose;
  TimeSlotItemData itemList;

  DialogEditTimeSlot(
      {required this.onDialogClose,
      required this.itemList,
      required this.data});

  @override
  _DialogScheduleProductState createState() => _DialogScheduleProductState();
}

class _DialogScheduleProductState extends State<DialogEditTimeSlot> {
  var _dropDownValue = "";

  String timeStart = "";
  String timeEnd = "";
  late String dateTime;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  var Color1 = Colors.grey;
  var Color2 = Colors.grey;
  var Color3 = Colors.grey;
  var Color4 = Colors.grey;
  var Color5 = Colors.grey;
  var Color6 = Colors.grey;
  var Color7 = Colors.grey;

  var ColorGrey = Colors.grey;
  var ColorGreen = Colors.green;

  bool valuesecond = false;

  bool isDataLoad = false;
  bool isDataLoaded = false;
  var _valueC = false;
  late DateRangePickerController _multipleDatePicker =
      DateRangePickerController();

  List<DateTime> _specialDates = [];
  List<String> data = [];
  List<String> days = [];
  List<String> items = [];
  List<DateTime> _selectedDate = [];
  List<DateTime> _selected = [];
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  late EditTimeZoneRepository _addItemsRepository;
  late TimeOfDay selectedStartTime, selectedEndTime;
  TextEditingController slotController = TextEditingController();

  @override
  void initState() {
    _addItemsRepository = new EditTimeZoneRepository(context, widget);
    selectedStartTime = new TimeOfDay.now();
    selectedEndTime = new TimeOfDay.now();
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
        print("Time Data" + data.toString());
      });
      print("SPECIAL DATE: " + _specialDates.toString());
      print("SPECIAL DATES: " + _selectedDate.toString());
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
                    Text(
                      "Update Restaurant Time Zone",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(223, 221, 239, 1),
                          border: Border.all(color: colorFieldBorder, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Container(
                            margin: EdgeInsets.all(18),
                            child: TextField(
                              maxLines: 1,
                              controller: slotController,
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: colorTextBlack),
                              cursorColor: colorTextBlack,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  isDense: true,
                                  hintText: widget.itemList.name,
                                  hintStyle: TextStyle(
                                      color: colorTextHint, fontSize: 16),
                                  border: InputBorder.none),
                            ))),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 19),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(18),
                                decoration: BoxDecoration(
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
                                        controller: new TextEditingController(
                                            text: timeStart.isEmpty
                                                ? widget.itemList.startTime
                                                : formatTimeOfDay(
                                                    selectedStartTime,
                                                    'hh:mm a')),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: colorTextBlack),
                                        decoration: InputDecoration(
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
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "To",
                            style: TextStyle(
                                color: colorTextBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(18),
                                decoration: BoxDecoration(
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
                                        controller: new TextEditingController(
                                            text: timeEnd.isEmpty
                                                ? widget.itemList.endTime
                                                : formatTimeOfDay(
                                                    selectedEndTime,
                                                    'hh:mm a')),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: colorTextBlack),
                                        decoration: InputDecoration(
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
                        Text(
                          "Select Days ",
                          style: TextStyle(
                              color: colorTextBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              "Select All",
                              style: TextStyle(
                                  color: colorTextBlack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                            new Checkbox(
                              value: _valueC,
                              checkColor: Colors.grey,
                              onChanged: (bool? value) {
                                setState(() {
                                  _valueC = value!;
                                  if (value) {
                                    if (days.length != 0) {
                                      days.clear();
                                    }
                                    if (widget.itemList.days! != 0) {
                                      widget.itemList.days!.clear();
                                    }
                                    Color1 = Colors.green;
                                    Color2 = Colors.green;
                                    Color3 = Colors.green;
                                    Color4 = Colors.green;
                                    Color5 = Colors.green;
                                    Color6 = Colors.green;
                                    Color7 = Colors.green;
                                    days.add("Sunday");
                                    days.add("Monday");
                                    days.add("Tuesday");
                                    days.add("Wednesday");
                                    days.add("Thursday");
                                    days.add("Friday");
                                    days.add("Saturday");
                                  } else {
                                    Color1 = Colors.grey;
                                    Color2 = Colors.grey;
                                    Color3 = Colors.grey;
                                    Color4 = Colors.grey;
                                    Color5 = Colors.grey;
                                    Color6 = Colors.grey;
                                    Color7 = Colors.grey;
                                    if (days.length != 0) {
                                      days.clear();
                                    }

                                    if (widget.itemList.days! != 0) {
                                      widget.itemList.days!.clear();
                                    }
                                  }
                                  print('value: $value');
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                        child: Row(children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Sunday")) {
                                  widget.itemList.days!.remove("Sunday");
                                }
                                if (Color1 == Colors.grey) {
                                  Color1 = Colors.green;

                                  days.add("Sunday");
                                } else if (Color1 == Colors.green) {
                                  Color1 = Colors.grey;
                                  if (days.contains("Sunday")) {
                                    days.remove("Sunday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Sunday")
                                      ? (Color1 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color1,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "S",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Monday")) {
                                  widget.itemList.days!.remove("Monday");
                                }
                                if (Color2 == Colors.grey) {
                                  Color2 = Colors.green;
                                  days.add("Monday");
                                } else if (Color2 == Colors.green) {
                                  Color2 = Colors.grey;
                                  if (days.contains("Monday")) {
                                    days.remove("Monday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Monday")
                                      ? (Color2 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color2,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "M",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Tuesday")) {
                                  widget.itemList.days!.remove("Tuesday");
                                }
                                if (Color3 == Colors.grey) {
                                  Color3 = Colors.green;
                                  days.add("Tuesday");
                                } else if (Color3 == Colors.green) {
                                  Color3 = Colors.grey;
                                  days.remove("Tuesday");
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Tuesday")
                                      ? (Color3 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color3,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "T",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!
                                    .contains("Wednesday")) {
                                  widget.itemList.days!.remove("Wednesday");
                                }
                                if (Color4 == Colors.grey) {
                                  Color4 = Colors.green;

                                  days.add("Wednesday");
                                } else if (Color4 == Colors.green) {
                                  Color4 = Colors.grey;
                                  if (days.contains("Wednesday")) {
                                    days.remove("Wednesday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Wednesday")
                                      ? (Color4 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color4,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "W",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!
                                    .contains("Thursday")) {
                                  widget.itemList.days!.remove("Thursday");
                                }
                                if (Color5 == Colors.grey) {
                                  Color5 = Colors.green;
                                  days.add("Thursday");
                                } else if (Color5 == Colors.green) {
                                  Color5 = Colors.grey;
                                  if (days.contains("Thursday")) {
                                    days.remove("Thursday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Thursday")
                                      ? (Color5 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color5,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "T",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!.contains("Friday")) {
                                  widget.itemList.days!.remove("Friday");
                                }
                                if (Color6 == Colors.grey) {
                                  Color6 = Colors.green;
                                  days.add("Friday");
                                } else if (Color6 == Colors.green) {
                                  Color6 = Colors.grey;
                                  if (days.contains("Friday")) {
                                    days.remove("Friday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Friday")
                                      ? (Color6 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color6,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "F",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.itemList.days!
                                    .contains("Saturday")) {
                                  widget.itemList.days!.remove("Saturday");
                                }
                                if (Color7 == Colors.grey) {
                                  Color7 = Colors.green;
                                  days.add("Saturday");
                                } else if (Color7 == Colors.green) {
                                  Color7 = Colors.grey;
                                  if (days.contains("Saturday")) {
                                    days.remove("Saturday");
                                  }
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  widget.itemList.days!.contains("Saturday")
                                      ? (Color7 == Colors.grey
                                          ? Colors.green
                                          : Colors.grey)
                                      : Color7,
                              radius: 17,
                              child: Center(
                                child: Text(
                                  "S",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ])),
                    Text(
                      "Add Holidays",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
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
                            SizedBox(
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
                      margin: EdgeInsets.only(top: 40),
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
                                child: Text(
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
                                var _holidayData;
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
                                child: Text(
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

  Future<Null> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      useRootNavigator: false,
      confirmText: "Set",
      cancelText: "Cancel",
      routeSettings: RouteSettings(),
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
    if (picked != null)
      setState(() {
        selectedStartTime = picked;
        timeStart = formatTimeOfDay(selectedStartTime, 'HH:mm');
        print("$selectedStartTime");
      });
  }

  Future<Null> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      useRootNavigator: false,
      confirmText: "Set",
      cancelText: "Cancel",
      routeSettings: RouteSettings(),
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
    if (picked != null)
      setState(() {
        selectedEndTime = picked;
        timeEnd = formatTimeOfDay(selectedEndTime, 'HH:mm');
        print("$selectedEndTime");
      });
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
                      todayTextStyle: TextStyle(color: colorTextWhite),
                      todayCellDecoration: BoxDecoration(
                          color: Color.fromRGBO(81, 200, 0, 1),
                          borderRadius: BorderRadius.circular(10)),
                      cellDecoration: BoxDecoration(
                          color: Color.fromRGBO(251, 245, 232, 1),
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
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
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
                    selectionTextStyle: TextStyle(
                        color: colorTextWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 12),
                    selectionColor: colorGreen,
                    startRangeSelectionColor: colorGreen,
                    endRangeSelectionColor: colorGreen,
                    rangeSelectionColor: colorGreen,
                    rangeTextStyle:
                        TextStyle(color: Colors.black, fontSize: 15),
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
                            child: Text(
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
      print("Data : " + data.toString());
    });
  }
}
