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
        ? RestDetails.fromJson(json['restDetails'])
        : null;
    if (json['reportData'] != null) {
      reportData = <ReportData>[];
      json['reportData'].forEach((v) {
        reportData!.add(ReportData.fromJson(v));
      });
    }
    if (json['reportSummary'] != null) {
      reportSummary = <ReportSummary>[];
      json['reportSummary'].forEach((v) {
        reportSummary!.add(ReportSummary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (restDetails != null) {
      data['restDetails'] = restDetails!.toJson();
    }
    if (reportData != null) {
      data['reportData'] = reportData!.map((v) => v.toJson()).toList();
    }
    if (reportSummary != null) {
      data['reportSummary'] =
          reportSummary!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurantName'] = restaurantName;
    data['location'] = location;
    data['wifiPrinterIP'] = wifiPrinterIP;
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
  num? iV;
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
        itemDetails!.add(ItemData.fromJson(v));
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
        ? UserDetails.fromJson(json['userDetails'])
        : null;
    orderDateTime = json['orderDateTime'];
    createdOn = json['createdOn'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deliveryAddress = json['deliveryAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (itemDetails != null) {
      data['itemDetails'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    data['tip'] = tip;
    data['deliveryCharge'] = deliveryCharge.toString();
    data['discount'] = discount.toString();
    data['orderStatus'] = orderStatus;
    data['note'] = note;
    data['isDeleted'] = isDeleted;
    data['isPaid'] = isPaid;
    data['restaurantId'] = restaurantId;
    data['deliveryType'] = deliveryType;
    data['paymentMode'] = paymentMode;
    data['orderTime'] = orderTime;
    data['subTotal'] = subTotal.toString();
    data['totalAmount'] = totalAmount.toString();
    data['orderNumber'] = orderNumber;
    if (userDetails != null) {
      data['userDetails'] = userDetails!.toJson();
    }
    data['orderDateTime'] = orderDateTime;
    data['createdOn'] = createdOn;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deliveryAddress'] = deliveryAddress;
    return data;
  }
}

class ItemData {
  String? sId;
  String? name;
  String? option;
  String? price;
  String? note;
  List<ToppingsReports>? toppings;
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
      toppings = <ToppingsReports>[];
      json['toppings'].forEach((v) {
        toppings!.add(ToppingsReports.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId.toString();
    data['name'] = name;
    data['option'] = option;
    data['price'] = price.toString();
    data['note'] = note;
    if (toppings != null) {
      data['toppings'] = toppings!.map((v) => v.toJson()).toList();
    }
    data['discount'] = discount.toString();
    data['catDiscount'] = catDiscount.toString();
    data['overallDiscount'] = overallDiscount.toString();
    data['excludeDiscount'] = excludeDiscount.toString();
    data['variant'] = variant.toString();
    data['variantPrice'] = variantPrice.toString();
    data['subVariant'] = subVariant.toString();
    data['subVariantPrice'] = subVariantPrice.toString();
    data['quantity'] = quantity.toString();
    return data;
  }
}

class ToppingsReports {
  String? sId;
  String? createdOn;
  bool? isDeleted;
  String? restaurantId;
  String? name;
  num? price;
  num? iV;
  String? createdAt;
  String? updatedAt;

  ToppingsReports(
      {this.sId,
      this.createdOn,
      this.isDeleted,
      this.restaurantId,
      this.name,
      this.price,
      this.iV,
      this.createdAt,
      this.updatedAt});

  ToppingsReports.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['createdOn'] = createdOn;
    data['isDeleted'] = isDeleted;
    data['restaurantId'] = restaurantId;
    data['name'] = name;
    data['price'] = price;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isDelete'] = isDelete;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['houseNumber'] = houseNumber;
    data['street'] = street;
    data['city'] = city;
    data['contact'] = contact;
    data['address'] = address;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['postcode'] = postcode;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId.toString();
    data['pickupOrders'] = pickupOrders.toString();
    data['deliveryOrders'] = deliveryOrders.toString();
    data['totalPickupSales'] = totalPickupSales.toString();
    data['totalDeliverySales'] = totalDeliverySales.toString();
    data['totalOnlinePayment'] = totalOnlinePayment.toString();
    data['totalCashPayment'] = totalCashPayment.toString();
    data['totalOrders'] = totalOrders.toString();
    data['totalOnlineCount'] = totalOnlineCount.toString();
    data['totalCashCount'] = totalCashCount.toString();
    data['totalSales'] = totalSales.toString();
    return data;
  }
}
