class LoginModel {
  bool? success;
  LoginData? data;
  String? message;

  LoginModel({this.success, this.data, this.message});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
    // ignore: prefer_if_null_operators
    message = json['message'] == null ? "" : json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (message != null) {
      data['message'] = message!;
    }
    return data;
  }
}

class LoginData {
  bool? isActive;
  String? deviceToken;
  String? appVersion;
  String? deviceType;
  String? userType;
  String? sId;
  String? email;
  String? iV;
  String? updatedAt;
  String? createdOn;
  bool? isOnline;
  String? discount;
  String? restaurantName;
  String? location;
  String? shortDescription;
  String? image;
  String? phoneNumber;
  String? openTime;
  String? closeTime;
  String? openDay;
  String? closeDay;
  String? token;
  String? wifiPrinterIP;
  String? wifiPrinterPort;
  int? deliveryDiscount;
  int? collectionDiscount;
  String? deliveryTime;
  String? collectionTime;
  String? deliveryRadius;
  String? minimumOrder;
  String? restaurantId;
  List<String>? passcode;
  String? vatNumber;
  String? restEmail;
  String? websiteURL;
  bool? autoAccept;
  bool? autoPrint;
  bool? allowOnlineDelivery;
  bool? allowOnlinePickup;
  bool? isReservationActive;

  LoginData(
      {this.isActive,
      this.deviceToken,
      this.appVersion,
      this.deviceType,
      this.userType,
      this.sId,
      this.email,
      this.iV,
      this.updatedAt,
      this.createdOn,
      this.isOnline,
      this.discount,
      this.restaurantName,
      this.location,
      this.shortDescription,
      this.image,
      this.phoneNumber,
      this.openTime,
      this.closeTime,
      this.openDay,
      this.closeDay,
      this.token,
      this.wifiPrinterIP,
      this.wifiPrinterPort,
      this.deliveryDiscount,
      this.collectionDiscount,
      this.deliveryRadius,
      this.minimumOrder,
      this.passcode,
      this.restaurantId,
      this.vatNumber,
      this.restEmail,
      this.websiteURL,
      this.autoAccept,
      this.autoPrint,
      this.allowOnlineDelivery,
      this.allowOnlinePickup,
      this.isReservationActive});

  LoginData.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    deviceToken = json['deviceToken'];
    appVersion = json['appVersion'];
    deviceType = json['deviceType'];
    userType = json['userType'].toString();
    sId = json['_id'];
    email = json['email'];
    iV = json['__v'].toString();
    updatedAt = json['updatedAt'];
    createdOn = json['createdOn'];
    isOnline = json['isOnline'];
    discount = json['discount'].toString();
    restaurantName = json['restaurantName'];
    location = json['location'];
    shortDescription = json['shortDescription'];
    image = json['image'];
    phoneNumber = json['phoneNumber'];
    openTime = json['openTime'];
    closeTime = json['closeTime'];
    openDay = json['openDay'];
    closeDay = json['closeDay'];
    token = json['token'];
    wifiPrinterIP = json['wifiPrinterIP'];
    wifiPrinterPort = json['wifiPrinterPort'];
    deliveryDiscount = json['deliveryDiscount'];
    collectionDiscount = json['collectionDiscount'];
    deliveryTime = json['deliveryTime'];
    collectionTime = json['collectionTime'];
    deliveryRadius = json['deliveryRadius'].toString();
    minimumOrder = json['minimumOrder'].toString();
    passcode = json['passcode'].cast<String>();
    restaurantId = json['restaurantId'];
    vatNumber = json['vatNumber'];
    restEmail = json['restEmail'];
    websiteURL = json['websiteURL'];
    autoAccept = json["autoAccept"];
    autoPrint = json["autoPrint"];
    allowOnlineDelivery = json["allowOnlineDelivery"];
    allowOnlinePickup = json["allowOnlinePickup"];
    isReservationActive = json["isReservationActive"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isActive'] = isActive;
    data['deviceToken'] = deviceToken;
    data['appVersion'] = appVersion;
    data['deviceType'] = deviceType;
    data['userType'] = userType;
    data['_id'] = sId;
    data['email'] = email;
    data['__v'] = iV;
    data['updatedAt'] = updatedAt;
    data['createdOn'] = createdOn;
    data['isOnline'] = isOnline;
    data['discount'] = discount;
    data['restaurantName'] = restaurantName;
    data['location'] = location;
    data['shortDescription'] = shortDescription;
    data['image'] = image;
    data['phoneNumber'] = phoneNumber;
    data['openTime'] = openTime;
    data['closeTime'] = closeTime;
    data['openDay'] = openDay;
    data['closeDay'] = closeDay;
    data['token'] = token;
    data['wifiPrinterIP'] = wifiPrinterIP;
    data['wifiPrinterPort'] = wifiPrinterPort;
    data['deliveryDiscount'] = deliveryDiscount;
    data['collectionDiscount'] = collectionDiscount;
    data['deliveryTime'] = deliveryTime;
    data['collectionTime'] = collectionTime;
    data['deliveryRadius'] = deliveryRadius;
    data['minimumOrder'] = minimumOrder;
    data['passcode'] = passcode;
    data['restaurantId'] = restaurantId;
    data['vatNumber'] = vatNumber;
    data['restEmail'] = restEmail;
    data['websiteURL'] = websiteURL;
    data['autoAccept'] = autoAccept;
    data['autoPrint'] = autoPrint;
    data['allowOnlineDelivery'] = allowOnlineDelivery;
    data['allowOnlinePickup'] = allowOnlinePickup;
    data['isReservationActive'] = isReservationActive;
    return data;
  }
}
