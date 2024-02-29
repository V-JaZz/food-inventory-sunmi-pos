class OrderReport {
  bool? success;
  RestDetails? restDetails;
  List<ReportData>? reportData;
  List<ReportSummary>? reportSummary;

  OrderReport(
      {this.success, this.restDetails, this.reportData, this.reportSummary});

  OrderReport.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    restDetails = json['restDetails'] != null
        ? new RestDetails.fromJson(json['restDetails'])
        : null;
    if (json['reportData'] != null) {
      reportData = <ReportData>[];
      json['reportData'].forEach((v) {
        reportData!.add(new ReportData.fromJson(v));
      });
    }
    if (json['reportSummary'] != null) {
      reportSummary = <ReportSummary>[];
      json['reportSummary'].forEach((v) {
        reportSummary!.add(new ReportSummary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.restDetails != null) {
      data['restDetails'] = this.restDetails!.toJson();
    }
    if (this.reportData != null) {
      data['reportData'] = this.reportData!.map((v) => v.toJson()).toList();
    }
    if (this.reportSummary != null) {
      data['reportSummary'] =
          this.reportSummary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RestDetails {
  String? restaurantName;
  String? location;
  String? wifiPrinterIP;

  RestDetails({this.restaurantName, this.location, this.wifiPrinterIP});

  RestDetails.fromJson(Map<String, dynamic> json) {
    restaurantName = json['restaurantName'];
    location = json['location'];
    wifiPrinterIP = json['wifiPrinterIP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurantName'] = this.restaurantName;
    data['location'] = this.location;
    data['wifiPrinterIP'] = this.wifiPrinterIP;
    return data;
  }
}

class ReportData {
  String? sId;
  List<ItemData>? itemDetails;
  String? tip;
  String? deliveryCharge;
  String? discount;
  String? orderStatus;
  String? note;
  bool? isDeleted;
  bool? isPaid;
  String? restaurantId;
  String? deliveryType;
  String? paymentMode;
  String? orderTime;
  String? subTotal;
  String? totalAmount;
  String? orderNumber;
  UserDetails? userDetails;
  String? orderDateTime;
  String? createdOn;
  int? iV;
  String? createdAt;
  String? updatedAt;
  String? deliveryAddress;

  ReportData(
      {this.sId,
      this.itemDetails,
      this.tip,
      this.deliveryCharge,
      this.discount,
      this.orderStatus,
      this.note,
      this.isDeleted,
      this.isPaid,
      this.restaurantId,
      this.deliveryType,
      this.paymentMode,
      this.orderTime,
      this.subTotal,
      this.totalAmount,
      this.orderNumber,
      this.userDetails,
      this.orderDateTime,
      this.createdOn,
      this.iV,
      this.createdAt,
      this.updatedAt,
      this.deliveryAddress});

  ReportData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['itemDetails'] != null) {
      itemDetails = <ItemData>[];
      json['itemDetails'].forEach((v) {
        itemDetails!.add(new ItemData.fromJson(v));
      });
    }
    tip = json['tip'];
    deliveryCharge = json['deliveryCharge'].toString();
    discount = json['discount'].toString();
    orderStatus = json['orderStatus'];
    note = json['note'];
    isDeleted = json['isDeleted'];
    isPaid = json['isPaid'];
    restaurantId = json['restaurantId'];
    deliveryType = json['deliveryType'];
    paymentMode = json['paymentMode'];
    orderTime = json['orderTime'];
    subTotal = json['subTotal'].toString();
    totalAmount = json['totalAmount'].toString();
    orderNumber = json['orderNumber'];
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
    orderDateTime = json['orderDateTime'];
    createdOn = json['createdOn'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deliveryAddress = json['deliveryAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.itemDetails != null) {
      data['itemDetails'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    data['tip'] = this.tip;
    data['deliveryCharge'] = this.deliveryCharge.toString();
    data['discount'] = this.discount.toString();
    data['orderStatus'] = this.orderStatus;
    data['note'] = this.note;
    data['isDeleted'] = this.isDeleted;
    data['isPaid'] = this.isPaid;
    data['restaurantId'] = this.restaurantId;
    data['deliveryType'] = this.deliveryType;
    data['paymentMode'] = this.paymentMode;
    data['orderTime'] = this.orderTime;
    data['subTotal'] = this.subTotal.toString();
    data['totalAmount'] = this.totalAmount.toString();
    data['orderNumber'] = this.orderNumber;
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    data['orderDateTime'] = this.orderDateTime;
    data['createdOn'] = this.createdOn;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deliveryAddress'] = this.deliveryAddress;
    return data;
  }
}

class ItemData {
  String? sId;
  String? name;
  String? option;
  String? price;
  String? note;
  List<Toppings>? toppings;
  String? discount;
  String? catDiscount;
  String? overallDiscount;
  bool? excludeDiscount;
  String? variant;
  String? variantPrice;
  String? subVariant;
  String? subVariantPrice;
  String? quantity;

  ItemData(
      {this.sId,
      this.name,
      this.option,
      this.price,
      this.note,
      this.toppings,
      this.discount,
      this.catDiscount,
      this.overallDiscount,
      this.excludeDiscount,
      this.variant,
      this.variantPrice,
      this.subVariant,
      this.subVariantPrice,
      this.quantity});

  ItemData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'].toString();
    name = json['name'];
    option = json['option'];
    price = json['price'].toString();
    note = json['note'];
    if (json['toppings'] != null) {
      toppings = <Toppings>[];
      json['toppings'].forEach((v) {
        toppings!.add(new Toppings.fromJson(v));
      });
    }
    discount = json['discount'].toString();
    catDiscount = json['catDiscount'].toString();
    overallDiscount = json['overallDiscount'].toString();
    excludeDiscount = json['excludeDiscount'];
    variant = json['variant'].toString();
    variantPrice = json['variantPrice'].toString();
    subVariant = json['subVariant'].toString();
    subVariantPrice = json['subVariantPrice'].toString();
    quantity = json['quantity'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId.toString();
    data['name'] = this.name;
    data['option'] = this.option;
    data['price'] = this.price.toString();
    data['note'] = this.note;
    if (this.toppings != null) {
      data['toppings'] = this.toppings!.map((v) => v.toJson()).toList();
    }
    data['discount'] = this.discount.toString();
    data['catDiscount'] = this.catDiscount.toString();
    data['overallDiscount'] = this.overallDiscount.toString();
    data['excludeDiscount'] = this.excludeDiscount.toString();
    data['variant'] = this.variant.toString();
    data['variantPrice'] = this.variantPrice.toString();
    data['subVariant'] = this.subVariant.toString();
    data['subVariantPrice'] = this.subVariantPrice.toString();
    data['quantity'] = this.quantity.toString();
    return data;
  }
}

class Toppings {
  String? sId;
  String? createdOn;
  bool? isDeleted;
  String? restaurantId;
  String? name;
  int? price;
  int? iV;
  String? createdAt;
  String? updatedAt;

  Toppings(
      {this.sId,
      this.createdOn,
      this.isDeleted,
      this.restaurantId,
      this.name,
      this.price,
      this.iV,
      this.createdAt,
      this.updatedAt});

  Toppings.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    restaurantId = json['restaurantId'];
    name = json['name'];
    price = json['price'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['createdOn'] = this.createdOn;
    data['isDeleted'] = this.isDeleted;
    data['restaurantId'] = this.restaurantId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class UserDetails {
  bool? isDelete;
  String? firstName;
  String? lastName;
  String? email;
  String? houseNumber;
  String? street;
  String? city;
  String? contact;
  String? address;
  String? createdAt;
  String? updatedAt;
  String? postcode;

  UserDetails(
      {this.isDelete,
      this.firstName,
      this.lastName,
      this.email,
      this.houseNumber,
      this.street,
      this.city,
      this.contact,
      this.address,
      this.createdAt,
      this.updatedAt,
      this.postcode});

  UserDetails.fromJson(Map<String, dynamic> json) {
    isDelete = json['isDelete'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    houseNumber = json['houseNumber'];
    street = json['street'];
    city = json['city'];
    contact = json['contact'];
    address = json['address'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    postcode = json['postcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isDelete'] = this.isDelete;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['houseNumber'] = this.houseNumber;
    data['street'] = this.street;
    data['city'] = this.city;
    data['contact'] = this.contact;
    data['address'] = this.address;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['postcode'] = this.postcode;
    return data;
  }
}

class ReportSummary {
  String? sId;
  String? pickupOrders;
  String? deliveryOrders;
  String? totalPickupSales;
  String? totalDeliverySales;
  String? totalOnlinePayment;
  String? totalCashPayment;
  String? totalOrders;
  String? totalOnlineCount;
  String? totalCashCount;
  String? totalSales;

  ReportSummary(
      {this.sId,
      this.pickupOrders,
      this.deliveryOrders,
      this.totalPickupSales,
      this.totalDeliverySales,
      this.totalOnlinePayment,
      this.totalCashPayment,
      this.totalOrders,
      this.totalOnlineCount,
      this.totalCashCount,
      this.totalSales});

  ReportSummary.fromJson(Map<String, dynamic> json) {
    sId = json['_id'].toString();
    pickupOrders = json['pickupOrders'].toString();
    deliveryOrders = json['deliveryOrders'].toString();
    totalPickupSales = json['totalPickupSales'].toString();
    totalDeliverySales = json['totalDeliverySales'].toString();
    totalOnlinePayment = json['totalOnlinePayment'].toString();
    totalCashPayment = json['totalCashPayment'].toString();
    totalOrders = json['totalOrders'].toString();
    totalOnlineCount = json['totalOnlineCount'].toString();
    totalCashCount = json['totalCashCount'].toString();
    totalSales = json['totalSales'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId.toString();
    data['pickupOrders'] = this.pickupOrders.toString();
    data['deliveryOrders'] = this.deliveryOrders.toString();
    data['totalPickupSales'] = this.totalPickupSales.toString();
    data['totalDeliverySales'] = this.totalDeliverySales.toString();
    data['totalOnlinePayment'] = this.totalOnlinePayment.toString();
    data['totalCashPayment'] = this.totalCashPayment.toString();
    data['totalOrders'] = this.totalOrders.toString();
    data['totalOnlineCount'] = this.totalOnlineCount.toString();
    data['totalCashCount'] = this.totalCashCount.toString();
    data['totalSales'] = this.totalSales.toString();
    return data;
  }
}
