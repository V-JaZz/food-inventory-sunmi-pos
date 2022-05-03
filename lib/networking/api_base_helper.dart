import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'app_exception.dart';
import 'package:http_parser/http_parser.dart';

class ApiBaseHelper {
  static final String baseURL =
      "https://demo-foodinventoryde.herokuapp.com/v1/";
  static final String login = "ownerService/login";
  static final String logout = "ownerService/logout";
  static final String editProfile = "ownerService/editProfile";
  static final String resetPassword = "ownerService/resetPassword";
  static final String instanceAction = "restaurantService/instanceAction";
  static final String restaurantSetting = "restaurantService/restaurantSetting";
  static final String addRestaurantImage =
      "restaurantService/addRestaurantImage";
  static final String profile = "restaurantService/profile";
  static final String updateDiscount = "restaurantService/updateDiscount";
  static final String downloadRestaurantImage =
      "restaurantService/downloadRestaurantImage";
  static final String addToppings = "menuService/addToppings";
  static final String getToppings = "menuService/getToppings";
  static final String deleteTopping = "menuService/deleteTopping";
  static final String updateTopping = "menuService/updateTopping";
  static final String addCategories = "menuService/addCategories";
  static final String getCategories = "menuService/getCategories";
  static final String deletecategory = "menuService/deletecategory";
  static final String updatecategory = "menuService/updatecategory";
  static final String addOptions = "menuService/addOptions";
  static final String getOptions = "menuService/getOptions";
  static final String deleteOption = "menuService/deleteOption";
  static final String updateoption = "menuService/updateoption";
  static final String addToppingGroups = "menuService/addToppingGroups";
  static final String getToppingGroups = "menuService/getToppingGroups";
  static final String deleteToppingGroup = "menuService/deleteToppingGroup";
  static final String updateToppingGroup = "menuService/updateToppingGroup";
  static final String additems = "menuService/additems";
  static final String updateitem = "menuService/updateitem";
  static final String getItems = "menuService/getItems";
  static final String deleteitem = "menuService/deleteitem";
  static final String getTimeZone = "RestaurantService/getTimeZones";
  static final String getItemsTimeZone = "MenuService/getItems";
  static final String addItemsTimeZone = "RestaurantService/addTimeZone";
  static final String getCategoriesTimeZone = "MenuService/getCategories";
  static final String deleteTimeZone = "RestaurantService/deleteTimeZone";
  static final String updateTimeZone = "RestaurantService/updateTimeZone";
  static final String statusTimeZone = "RestaurantService/updateTimeZoneStatus";
  static final String getRestaurantTimeSlot = "restaurantService/getTimeSlots";
  static final String addRestaurantTimeSlot = "restaurantService/addTimeSlot";
  static final String updateRestaurantTimeSlot =
      "restaurantService/updateTimeSlot";
  static final String updateStatusRestaurantTimeSlot =
      "restaurantService/updateTimeSlotStatus";
  static final String deleteRestaurantTimeSlot =
      "restaurantService/deleteTimeSlot";
  static final String updateItemPosition = "menuService/updateItemPosition";
  static final String updateCategoryPosition =
      "menuService/updateCategoryPosition";
  static final String getAllergies = "menuService/getAllergies";
  static final String updateAllergies = "menuService/updateAllergy";
  static final String deleteAllergies = "menuService/deleteAllergy";
  static final String addAllergies = "menuService/addAllergy";
  static final String getAllergiesGroup = "menuService/getAllergyGroups";
  static final String addAllergiesGroup = "menuService/addAllergyGroup";
  static final String updateAllergiesGroup = "menuService/updateAllergyGroup";
  static final String deleteAllergiesGroup = "menuService/deleteAllergyGroup";
  static final String getOrders = "orderService/getOrders";
  static final String orderHistory = "orderService/orderHistory";
  static final String updateorderstatus = "orderService/updateorderstatus";
  static final String getDeliveryData = "restaurantService/profile";
  static final String addDeliveryData = "restaurantService/addRestDistance";
  static final String updateDeliveryData =
      "restaurantService/updateRestDistance";
  static final String deleteDeliveryData =
      "restaurantService/deleteRestDistance";
  static final String updateItemDiscountStatus =
      "menuService/updateItemDiscountStatus";
  static final String getVariantsList = "menuService/getVariants";
  static final String addVariants = "menuService/addVariants";
  static final String getVariantGroups = "menuService/getVariantGroups";
  static final String addVariantGroups = "menuService/addVariantGroups";
  static final String updateVariantGroup = "menuService/updateVariantGroup";
  static final String deleteVariantGroup = "menuService/deleteVariantGroup";
  static final String deleteVariant = "menuService/deleteVariant";
  static final String updateVariant = "menuService/updateVariant";
  static final String downloadMenuImage = "menuService/downloadMenuImage";
  static final String updateOnlineOrdering =
      "restaurantService/updateOnlineOrdering";

  static bool autoAccept = false;
  static bool autoPrint = false;
  static bool? allowOnlineDelivery = false;
  static bool? allowOnlinePickup = false;
  Future<dynamic> get(String url, String token) async {
    print('Api Post, url $url');
    print('Api PUT, Token $token');
    var response;
    try {
      Map<String, String> header;
      if (token.isEmpty) {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
      } else {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        };
      }

      response = await http.get(Uri.parse(baseURL + url), headers: header);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return response;
  }

  Future<dynamic> getwith(String url, String token, String restaurantid) async {
    print('Api Post, url $url');
    print('Api PUT, Token $token');
    var response;
    try {
      Map<String, String> header;
      if (token.isEmpty) {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
      } else {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer " + '$token',
          'restaurant': '$restaurantid'
        };
      }

      response = await http.get(Uri.parse(baseURL + url), headers: header);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return response;
  }

  Future<dynamic> post(String url, dynamic body, String token) async {
    print('Api Post, url $url');
    print('Api POST, Token $token');
    print('Api Post, body : $body');
    var response;
    try {
      Map<String, String> header;
      if (token.isEmpty) {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
      } else {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        };
      }

      response = await http.post(Uri.parse(baseURL + url),
          body: body, headers: header);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return response;
  }

  Future<dynamic> postwithid(
      String url, dynamic body, String token, String restorantid) async {
    print('Api Post, url $url');
    print('Api POST, Token $token');
    print('Api Post, body : $body');
    var response;
    try {
      Map<String, String> header;
      if (token.isEmpty) {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
      } else {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'restaurantId': '$restorantid'
        };
      }

      response = await http.post(Uri.parse(baseURL + url),
          body: body, headers: header);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return response;
  }

  Future<dynamic> put(
      String url, dynamic body, String token, String restorantid) async {
    print('Api PUT, url $url');
    print('Api PUT, Token $token');
    print('Api Post, body : $body');
    var response;
    try {
      Map<String, String> header;
      if (token.isEmpty) {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
      } else {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'restaurantId': '$restorantid'
        };
      }

      response =
          await http.put(Uri.parse(baseURL + url), body: body, headers: header);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api PUT.');
    return response;
  }

  Future<dynamic> putwith(String url, dynamic body, String token) async {
    print('Api PUT, url $url');
    print('Api PUT, Token $token');
    print('Api Post, body : $body');
    var response;
    try {
      Map<String, String> header;
      if (token.isEmpty) {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
      } else {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        };
      }

      response =
          await http.put(Uri.parse(baseURL + url), body: body, headers: header);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api PUT.');
    return response;
  }

  // For restaurant image Cover and Logo
  Future<dynamic> putMultiPart(String url, File pickedImage, String fileName,
      String fileType, String imageType, String token) async {
    print('Api PUT, url $url');
    print('Api PUT, FilePath ${pickedImage.path.split(".").last}');
    print('Api PUT, Token $token');
    print('Api PUT, ImageType $imageType');
    var respStr;
    try {
      var request = http.MultipartRequest(
          "PUT",
          Uri.parse(baseURL +
              url)); //Ye kyu kia POST kisne bola ?phle se ase hai nhi bhai suresh wala hai jo
      if (token.isNotEmpty) {}
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['option'] = imageType;
      request.fields['pratyush'] = 'this is image test';
      request.files.add(await http.MultipartFile.fromPath(
          'file', pickedImage.path,
          filename: fileName, contentType: new MediaType('image', fileType)));

      var response = await request.send();
      respStr = await response.stream.bytesToString();
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api PUT.');
    return respStr;
  }

  Future<dynamic> postMultiPartCategorywithoutimage(String url, String name,
      String description, String discount, String token) async {
    print('Api PUT, url $url');
    print('Api PUT, Token $token');
    print('Api PUT, ImageType $name');
    var respStr;
    try {
      var request = http.MultipartRequest("POST", Uri.parse(baseURL + url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['discount'] = discount;
      // request.files.add(await http.MultipartFile.fromPath(
      //     'file', pickedImage.path,
      //     filename: fileName, contentType: new MediaType('image', fileType)));
      var response = await request.send();
      respStr = await await http.Response.fromStream(response);
    } on SocketException {
      print('No net');
      // print(respStr);
      throw FetchDataException('No Internet connection');
    }
    print('api PUT.');
    return respStr;
  }

//this is for category image upload
  Future<dynamic> postMultiPartCategory(
      String url,
      File pickedImage,
      String fileName,
      String fileType,
      String name,
      String description,
      String discount,
      String token) async {
    print('Api PUT, url $url');
    print('Api PUT, FilePath ${pickedImage}');
    print('Api PUT, Token $token');
    print('Api PUT, ImageType $name');
    var respStr;
    try {
      var request = http.MultipartRequest("POST", Uri.parse(baseURL + url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['discount'] = discount;
      request.files.add(await http.MultipartFile.fromPath(
          'file', pickedImage.path,
          filename: fileName, contentType: new MediaType('image', fileType)));
      var response = await request.send();
      respStr = await await http.Response.fromStream(response);
    } on SocketException {
      print('No net');
      // print(respStr);
      throw FetchDataException('No Internet connection');
    }
    print('api PUT.');
    return respStr;
  }

  Future<dynamic> postMultiPartItems(
    String url,
    File pickedImage,
    String fileName,
    String fileType,
    String name,
    String category,
    String description,
    String discount,
    String price,
    variants,
    options,
    allergyGroup,
    String token,
  ) async {
    print('Api PUT, url $url');
    print('Api PUT, FilePath ${pickedImage}');
    print('Api PUT, Token $token');
    print('Api PUT, ImageType}' + variants.toString());

    var respStr;
    try {
      var request = http.MultipartRequest("POST", Uri.parse(baseURL + url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['name'] = name;
      request.fields['category'] = category;
      request.fields['description'] = description;
      request.fields['discount'] = discount;
      request.fields['price'] = price;
      request.fields['variants'] = '$variants';
      request.fields['options'] = '$options';
      request.fields['allergyGroup'] = allergyGroup;
      request.files.add(await http.MultipartFile.fromPath(
          'file', pickedImage.path,
          filename: fileName, contentType: new MediaType('image', fileType)));
      var response = await request.send();
      respStr = await await http.Response.fromStream(response);
    } on SocketException {
      print('No net');
      // print(respStr);
      throw FetchDataException('No Internet connection');
    }
    print('api PUT.');
    return respStr;
  }

  Future<dynamic> postMultiPartItemswithoutImage(
      String url,
      // String fileName,
      // String fileType,
      String name,
      String category,
      String description,
      String discount,
      String price,
      var variants,
      var options,
      allergyGroup,
      String token) async {
    print('Api PUT, url $url');
    print('Api PUT, Token $token');
    print('Api PUT, ImageType $name');
    print('Api PUT, varient $price');

    var respStr;
    try {
      var request = http.MultipartRequest("POST", Uri.parse(baseURL + url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['name'] = name;
      request.fields['category'] = category;
      request.fields['description'] = description;
      request.fields['discount'] = discount;
      request.fields['price'] = price;
      request.fields['variants'] = '$variants';
      request.fields['options'] = '$options';
      request.fields['allergyGroup'] = allergyGroup;

      // request.files.add(await http.MultipartFile.fromPath(
      //     'file', pickedImage.path,
      //     filename: fileName, contentType: new MediaType('image', fileType)));
      var response = await request.send();
      respStr = await await http.Response.fromStream(response);
    } on SocketException {
      print('No net');
      // print(respStr);
      throw FetchDataException('No Internet connection');
    }
    print('api PUT.');
    return respStr;
  }

//this is for category image upload
  Future<dynamic> putMultiPartCategory(
      String url,
      File pickedImage,
      String fileName,
      String fileType,
      String name,
      String description,
      String discount,
      String token) async {
    print('Api PUT, url $url');
    print('Api PUT, FilePath ${pickedImage}');
    print('Api PUT, Token $token');
    print('Api PUT, ImageType $name');
    var respStr;
    try {
      var request = http.MultipartRequest("PUT", Uri.parse(baseURL + url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['discount'] = discount;
      request.fields["imageType"] = "category";
      request.files.add(await http.MultipartFile.fromPath(
          'file', pickedImage.path,
          filename: fileName, contentType: new MediaType('image', fileType)));
      var response = await request.send();
      respStr = await await http.Response.fromStream(response);
    } on SocketException {
      print('No net');
      // print(respStr);
      throw FetchDataException('No Internet connection');
    }
    print('api PUT.');
    return respStr;
  }

//without Image
  Future<dynamic> putMultiPartCategorywithoutImage(String url, String name,
      String description, String discount, String token) async {
    print('Api PUT, url $url');

    print('Api PUT, Token $token');
    print('Api PUT, ImageType $name');
    var respStr;
    try {
      var request = http.MultipartRequest("PUT", Uri.parse(baseURL + url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['discount'] = discount;
      request.fields["imageType"] = "category";

      var response = await request.send();
      respStr = await await http.Response.fromStream(response);
    } on SocketException {
      print('No net');
      // print(respStr);
      throw FetchDataException('No Internet connection');
    }
    print('api PUT.');
    return respStr;
  }

//this is for category image upload
  Future<dynamic> putMultiPartItem(
      String url,
      File pickedImage,
      String fileName,
      String fileType,
      String name,
      String category,
      String description,
      String discount,
      String price,
      variants,
      options,
      String allergyGroup,
      String token,
      restorantid) async {
    print('Api PUT, url $url');
    print('Api PUT, FilePath ${pickedImage}');
    print('Api PUT, Token $token');
    print('Api PUT, ImageType $name');
    var respStr;
    try {
      var request = http.MultipartRequest("PUT", Uri.parse(baseURL + url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['restaurantId'] = '$restorantid';
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['discount'] = discount;
      request.fields['category'] = category;
      request.fields['price'] = price;
      request.fields['variants'] = '$variants';
      request.fields['options'] = '$options';
      request.fields['allergyGroup'] = allergyGroup;
      request.fields["imageType"] = "item";
      request.files.add(await http.MultipartFile.fromPath(
          'file', pickedImage.path,
          filename: fileName, contentType: new MediaType('image', fileType)));
      var response = await request.send();
      respStr = await await http.Response.fromStream(response);
    } on SocketException {
      print('No net');
      // print(respStr);
      throw FetchDataException('No Internet connection');
    }
    print('api PUT.');
    return respStr;
  }

//without Image
  Future<dynamic> putMultiPartItemwithoutImage(
      String url,
      String name,
      String category,
      String description,
      String discount,
      String price,
      variants,
      options,
      String allergyGroup,
      String token,
      restorantid) async {
    print('Api PUT, url $url');

    print('Api PUT, Token $token');
    print('Api PUT, ImageType $name');
    var respStr;
    try {
      var request = http.MultipartRequest("PUT", Uri.parse(baseURL + url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['restaurantId'] = '$restorantid';
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['discount'] = discount;
      request.fields['category'] = category;
      request.fields['price'] = price;
      request.fields['variants'] = '$variants';
      request.fields['options'] = '$options';
      request.fields['allergyGroup'] = allergyGroup;
      request.fields["imageType"] = "item";

      var response = await request.send();
      respStr = await await http.Response.fromStream(response);
    } on SocketException {
      print('No net');
      // print(respStr);
      throw FetchDataException('No Internet connection');
    }
    print('api PUT.');
    return respStr;
  }

  Future<dynamic> delete(String url, String token) async {
    print('Api delete, url $url');
    print('Api delete, Token $token');
    var response;
    try {
      Map<String, String> header;
      if (token.isEmpty) {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };
      } else {
        header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        };
      }

      response = await http.delete(Uri.parse(baseURL + url), headers: header);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return response;
  }

  dynamic _returnResponse(http.Response response) {
    print(response.statusCode.toString());
    print(response.body.toString());
    var responseJson = json.decode(response.body.toString());
    switch (response.statusCode) {
      case 101:
      case 200:
      case 404:
        // var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        return responseJson;
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        return responseJson;
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        return responseJson;
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  dynamic returnResponse(BuildContext context, http.Response response) {
    print(response.statusCode.toString());
    print(response.body.toString());
    var responseJson = json.decode(response.body.toString());
    switch (response.statusCode) {
      case 101:
      case 200:
      case 401:
      case 404:
      case 422:
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Something wants wrong!"),
        ));
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
