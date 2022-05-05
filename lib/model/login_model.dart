class LoginModel {
  bool? success;
  LoginData? data;
  String? message;

  LoginModel({this.success, this.data, this.message});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
    message = json['message'] == null ? "" : json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isActive'] = this.isActive;
    data['deviceToken'] = this.deviceToken;
    data['appVersion'] = this.appVersion;
    data['deviceType'] = this.deviceType;
    data['userType'] = this.userType;
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['__v'] = this.iV;
    data['updatedAt'] = this.updatedAt;
    data['createdOn'] = this.createdOn;
    data['isOnline'] = this.isOnline;
    data['discount'] = this.discount;
    data['restaurantName'] = this.restaurantName;
    data['location'] = this.location;
    data['shortDescription'] = this.shortDescription;
    data['image'] = this.image;
    data['phoneNumber'] = this.phoneNumber;
    data['openTime'] = this.openTime;
    data['closeTime'] = this.closeTime;
    data['openDay'] = this.openDay;
    data['closeDay'] = this.closeDay;
    data['token'] = this.token;
    data['wifiPrinterIP'] = this.wifiPrinterIP;
    data['wifiPrinterPort'] = this.wifiPrinterPort;
    data['deliveryDiscount'] = this.deliveryDiscount;
    data['collectionDiscount'] = this.collectionDiscount;
    data['deliveryTime'] = this.deliveryTime;
    data['collectionTime'] = this.collectionTime;
    data['deliveryRadius'] = this.deliveryRadius;
    data['minimumOrder'] = this.minimumOrder;
    data['passcode'] = this.passcode;
    data['restaurantId'] = this.restaurantId;
    data['vatNumber'] = this.vatNumber;
    data['restEmail'] = this.restEmail;
    data['websiteURL'] = this.websiteURL;
    data['autoAccept'] = this.autoAccept;
    data['autoPrint'] = this.autoPrint;
    data['allowOnlineDelivery'] = this.allowOnlineDelivery;
    data['allowOnlinePickup'] = this.allowOnlinePickup;
    data['isReservationActive'] = this.isReservationActive;
    return data;
  }
}
