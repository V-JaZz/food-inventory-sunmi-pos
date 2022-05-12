// ignore_for_file: avoid_print, unnecessary_string_interpolations, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../networking/api_base_helper.dart';

bool checkString(String? value) {
  return value == null || value.isEmpty;
}

String defaultValue(String? value, String def) {
  return value == null || value.isEmpty ? def : value;
}

bool checkEmailValid(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern.toString());
  return !regExp.hasMatch(value);
}

showMessage(String msg, BuildContext _context) {
  ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
    content: Text(msg),
  ));
}

String getAmountWithCurrency(String? price) {
  double priceDouble =
      double.parse((double.parse(defaultValue(price, "0"))).toStringAsFixed(2));
  print("total amount");
  print(priceDouble);
  return "${priceDouble.toString()} €";
}

String getAmountWithCurrencyOrder(String? price) {
  double priceDouble =
      double.parse((double.parse(defaultValue(price, "0"))).toStringAsFixed(2));
  print("total amount");
  print(priceDouble);
  return "${priceDouble.toString()}";
}

String getOrderDate(String createdDate) {
  DateTime dateTime = DateTime.parse(createdDate);
  final DateFormat formatter = DateFormat('HH:mm, dd MMM-yyyy');
  return formatter.format(dateTime);
}

String getOrderDateFormet(String createdDate) {
  DateTime dateTime = DateTime.parse(createdDate);
  final DateFormat formatter = DateFormat('HH:mm:ss, dd MMM-yyyy');
  return formatter.format(dateTime);
}

String getOrderStatusDate(String selectedDate) {
  DateTime dateTime = DateTime.parse(selectedDate);
  final DateFormat formatter = DateFormat('dd MMMM, yyyy');
  return formatter.format(dateTime);
}

String getSendableDate(DateTime selectedDate) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(selectedDate);
}

String getCurrentDateInFormat() {
  final DateFormat formatter = DateFormat('dd MMMM, yyyy');
  return formatter.format(DateTime.now());
}

String formatTimeOfDay(TimeOfDay tod, String stFormat) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  final format = DateFormat(stFormat); //"6:00 AM"
  return format.format(dt);
}

bool checkOpenCloseTime(TimeOfDay openTime, TimeOfDay closTime) {
  final now = DateTime.now();
  final openDate =
      DateTime(now.year, now.month, now.day, openTime.hour, openTime.minute);
  final closeDate =
      DateTime(now.year, now.month, now.day, closTime.hour, closTime.minute);
  return openDate.compareTo(closeDate) > 0;
}

String getImageURL(String type, String id) {
  print("FINAL PRINT URL IMAGE: " +
      '${ApiBaseHelper.baseURL}${ApiBaseHelper.downloadRestaurantImage}?option=$type&id=$id');
  return "${ApiBaseHelper.baseURL}${ApiBaseHelper.downloadRestaurantImage}?option=$type&id=$id";
}

String getImageCatURL(String type, String id) {
  print("FINAL PRINT URL IMAGE: " +
      '${ApiBaseHelper.baseURL}${ApiBaseHelper.downloadMenuImage}?imageType=$type&id=$id');
  return type == "category"
      ? "${ApiBaseHelper.baseURL}${ApiBaseHelper.downloadMenuImage}?imageType=$type&id=$id"
      : "${ApiBaseHelper.baseURL}${ApiBaseHelper.downloadMenuImage}?imageType=$type&id=$id";
}
