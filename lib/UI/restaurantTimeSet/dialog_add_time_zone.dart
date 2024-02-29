// ignore_for_file: unused_field, must_be_immutable, must_call_super

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_inventory/UI/restaurantTimeSet/repository/addTimeZoneItem.dart';
import 'package:food_inventory/constant/colors.dart';
import 'package:food_inventory/constant/image.dart';
import 'package:food_inventory/constant/validation_util.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DialogAddTimeSlot extends StatefulWidget {
  // var type, name;
  VoidCallback onDialogClose;
  DialogAddTimeSlot({Key? key, required this.onDialogClose}) : super(key: key);

  @override
  _DialogScheduleProductState createState() => _DialogScheduleProductState();
}

class _DialogScheduleProductState extends State<DialogAddTimeSlot> {
  final _dropDownValue = "";
  late final DateRangePickerController _multipleDatePicker =
      DateRangePickerController();
  final List<DateTime> _specialDates = [];
  List<String> data = [];
  List<String> days = [];
  List<String> items = [];
  final List<DateTime> _selectedDate = [];
  final List<DateTime> _selected = [];
  final String _dateCount = '';
  final String _range = '';
  final String _rangeCount = '';
  String timeRest = "Select Time";
  String timeRest2 = "Select Time";

  String timeStart = "";
  String timeEnd = "";

  late String dateTime;
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  var color1 = const Color(0xff5E5887);
  var color2 = const Color(0xff5E5887);
  var color3 = const Color(0xff5E5887);
  var color4 = const Color(0xff5E5887);
  var color5 = const Color(0xff5E5887);
  var color6 = const Color(0xff5E5887);
  var color7 = const Color(0xff5E5887);

  bool valueSecond = false;

  bool isDataLoad = false;
  bool isDataLoaded = false;
  var _valueC = false;

  late AddTimeZoneRepository _addItemsRepository;

  late TimeOfDay selectedStartTime, selectedEndTime;
  List<String> isChecked = [];
  TextEditingController slotController = TextEditingController();

  @override
  void initState() {
    _addItemsRepository = AddTimeZoneRepository(context, widget);
    selectedStartTime = TimeOfDay.now();
    selectedEndTime = TimeOfDay.now();
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
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Restaurant Time Zone",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xffDFDDEF),
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
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  isDense: true,
                                  hintText: "Zone Name",
                                  hintStyle: TextStyle(
                                      color: colorTextHint, fontSize: 16),
                                  border: InputBorder.none),
                            ))),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Opening Closing Schedule",
                      style: TextStyle(
                          color: colorTextBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                // width: 160,
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
                                                ? timeRest
                                                : formatTimeOfDay(
                                                    selectedStartTime,
                                                    'hh:mm a')),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: colorTextHint),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          isDense: true,
                                          hintText: "Start Time",
                                          hintStyle: TextStyle(
                                              color: colorTextHint,
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
                                // width: 160,
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
                                                ? timeRest2
                                                : formatTimeOfDay(
                                                    selectedEndTime,
                                                    'hh:mm a')),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: colorTextHint),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          isDense: true,
                                          hintText: "End Time",
                                          hintStyle: TextStyle(
                                              color: colorTextHint,
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
                              checkColor: colorGrey,
                              onChanged: (bool? value) {
                                setState(() {
                                  _valueC = value!;
                                  if (value) {
                                    if (days.isNotEmpty) {
                                      days.clear();
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
                                    color1 = const Color(0xff5E5887);
                                    color2 = const Color(0xff5E5887);
                                    color3 = const Color(0xff5E5887);
                                    color4 = const Color(0xff5E5887);
                                    color5 = const Color(0xff5E5887);
                                    color6 = const Color(0xff5E5887);
                                    color7 = const Color(0xff5E5887);
                                    if (days.isNotEmpty) {
                                      days.clear();
                                    }
                                  }
                                });
                              },
                            ),
                          ],
                        ),

                        /*Expanded(child:  Row( mainAxisAlignment: MainAxisAlignment.end,children: [ Expanded(child: CheckboxListTile(
                  title: Text("Select All",style: TextStyle(
                      color: colorTextBlack,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),),
                  activeColor: Color(0xff5E5887),
                  checkColor: Colors.black,
                  value: valueSecond,
                  onChanged: (newValue) {
                    setState(() {
                      valueSecond = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                ))],)) ,*/
                      ],
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 13),
                        child: Row(children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (color1 == const Color(0xff5E5887)) {
                                  color1 = Colors.green;
                                  days.add("Sunday");
                                } else if (color1 == Colors.green) {
                                  color1 = const Color(0xff5E5887);
                                  days.remove("Sunday");
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: color1,
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
                                if (color2 == const Color(0xff5E5887)) {
                                  color2 = Colors.green;
                                  days.add("Monday");
                                } else if (color2 == Colors.green) {
                                  color2 = const Color(0xff5E5887);
                                  days.remove("Monday");
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: color2,
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
                                if (color3 == const Color(0xff5E5887)) {
                                  color3 = Colors.green;
                                  days.add("Tuesday");
                                } else if (color3 == Colors.green) {
                                  color3 = const Color(0xff5E5887);
                                  days.remove("Tuesday");
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: color3,
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
                                if (color4 == const Color(0xff5E5887)) {
                                  color4 = Colors.green;
                                  days.add("Wednesday");
                                } else if (color4 == Colors.green) {
                                  color4 = const Color(0xff5E5887);
                                  days.remove("Wednesday");
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: color4,
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
                                if (color5 == const Color(0xff5E5887)) {
                                  color5 = Colors.green;
                                  days.add("Thursday");
                                } else if (color5 == Colors.green) {
                                  color5 = const Color(0xff5E5887);
                                  days.remove("Thursday");
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: color5,
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
                                if (color6 == const Color(0xff5E5887)) {
                                  color6 = Colors.green;
                                  days.add("Friday");
                                } else if (color6 == Colors.green) {
                                  color6 = const Color(0xff5E5887);
                                  days.remove("Friday");
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: color6,
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
                                if (color7 == const Color(0xff5E5887)) {
                                  color7 = Colors.green;
                                  days.add("Saturday");
                                } else if (color7 == Colors.green) {
                                  color7 = const Color(0xff5E5887);
                                  days.remove("Saturday");
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: color7,
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
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
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
                                  "Save",
                                  style: TextStyle(
                                      color: colorTextWhite,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ),
                              onTap: () {
                                var _holidayData = [];
                                setState(() {
                                  _holidayData = data.toSet().toList();
                                });
                                _addItemsRepository.addTimeZone(
                                    timeStart,
                                    timeEnd,
                                    days,
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
                    headerStyle: const DateRangePickerHeaderStyle(
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
}
