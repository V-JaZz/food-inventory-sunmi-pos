class OrderListResponseModel {
  bool? success;
  List<OrderDataModel>? data;
  SummaryData? summaryData;

  OrderListResponseModel({this.success, this.data, this.summaryData});

  OrderListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <OrderDataModel>[];
      json['data'].forEach((v) {
        data!.add(OrderDataModel.fromJson(v));
      });
    }
    summaryData = json['summaryData'] != null
        ? SummaryData.fromJson(json['summaryData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (summaryData != null) {
      data['summaryData'] = summaryData!.toJson();
    }
    return data;
  }
}

class OrderDataModel {
  String? sId;
  List<ItemDetails>? itemDetails;
  String? createdOn;
  String? orderStatus;
  String? note;
  bool? isDeleted;
  String? deliveryType;
  String? paymentMode;
  String? deliveryAddress;
  String? totalAmount;
  String? deliveryDatetime;
  String? orderDateTime;
  UserDetails? userDetails;
  String? orderNumber;
  String? iV;
  String? subTotal;
  String? discount;
  String? deliveryCharge;
  String? advanceOrderDate;
  bool? isPaid;
  String? createdAt;
  String? updatedAt;
  String? orderTime;
  String? tip;
  OrderDataModel({
    this.sId,
    this.itemDetails,
    this.createdOn,
    this.orderStatus,
    this.note,
    this.isDeleted,
    this.deliveryType,
    this.paymentMode,
    this.deliveryAddress,
    this.totalAmount,
    this.deliveryDatetime,
    this.orderDateTime,
    this.userDetails,
    this.orderNumber,
    this.iV,
    this.subTotal,
    this.discount,
    this.deliveryCharge,
    this.isPaid,
    this.createdAt,
    this.updatedAt,
    this.orderTime,
    this.tip,
  });

  OrderDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['itemDetails'] != null) {
      itemDetails = <ItemDetails>[];
      json['itemDetails'].forEach((v) {
        itemDetails!.add(ItemDetails.fromJson(v));
      });
    }
    createdOn = json['createdOn'];
    orderStatus = json['orderStatus'];
    note = json['note'];
    isDeleted = json['isDeleted'];
    deliveryType = json['deliveryType'];
    paymentMode = json['paymentMode'];
    advanceOrderDate = json['advanceOrderDate'];
    deliveryAddress = json['deliveryAddress'];
    totalAmount = json['totalAmount'].toString();
    deliveryDatetime = json['deliveryDatetime'];
    orderDateTime = json['orderDateTime'];
    userDetails = (json['userDetails'] != null
        ? UserDetails.fromJson(json['userDetails'])
        : null);
    orderNumber = json['orderNumber'];
    iV = json['__v'].toString();
    subTotal = (json['subTotal'] != null ? json['subTotal'].toString() : "");
    deliveryCharge = (json['deliveryCharge'] != null
        ? json['deliveryCharge'].toString()
        : "");
    discount = (json['discount'] != null ? json['discount'].toString() : "");
    isPaid = json['isPaid'];
    createdAt = json['createdAt'];
    orderTime = json['orderTime'];
    tip = json['tip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (itemDetails != null) {
      data['itemDetails'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    data['createdOn'] = createdOn;
    data['orderStatus'] = orderStatus;
    data['note'] = note;
    data['isDeleted'] = isDeleted;
    data['deliveryType'] = deliveryType;
    data['paymentMode'] = paymentMode;
    data['deliveryAddress'] = deliveryAddress;
    data['advanceOrderDate'] = advanceOrderDate;
    data['totalAmount'] = totalAmount;
    data['deliveryDatetime'] = deliveryDatetime;
    data['orderDateTime'] = orderDateTime;
    if (userDetails != null) {
      data['userDetails'] = userDetails!.toJson();
    }
    data['orderNumber'] = orderNumber;
    data['__v'] = iV;
    data['subTotal'] = subTotal;
    data['discount'] = discount;
    data['deliveryCharge'] = deliveryCharge;
    data['isPaid'] = isPaid;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['orderTime'] = orderTime;
    data['tip'] = tip;
    return data;
  }
}

class AutoPrintOrderModel {
  bool? success;
  OrderDataModel? data;

  AutoPrintOrderModel({this.success, this.data});

  AutoPrintOrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = OrderDataModel.fromJson(json['data']);
    }
  }
}

class ItemDetails {
  String? sId;
  String? name;
  String? price;
  String? option;
  String? note;
  List<Toppings>? toppings;
  String? quantity;
  int? catDiscount;
  int? discount;
  bool? excludeDiscount;
  int? overallDiscount;
  String? variant;
  String? variantPrice;
  String? subVariant;
  int? subVariantPrice;
  ItemDetails(
      {this.sId,
      this.name,
      this.price,
      this.note,
      this.option,
      this.quantity,
      this.toppings,
      this.catDiscount,
      this.discount,
      this.excludeDiscount,
      this.overallDiscount,
      this.variant,
      this.variantPrice,
      this.subVariant,
      this.subVariantPrice}
      );

  ItemDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    option = json['option'];
    price = json['price'].toString();
    note = json['note'];
    if (json['toppings'] != null) {
      toppings = [];
      json['toppings'].forEach((v) {
        toppings!.add(Toppings.fromJson(v));
      });
    }
    quantity = json['quantity'].toString();
    catDiscount = json['catDiscount'];
    discount = json['discount'];
    excludeDiscount = json['excludeDiscount'];
    overallDiscount = json['overallDiscount'];
    variant = json['variant'];
    variantPrice = json['variantPrice'].toString();
    subVariant = json['subVariant'];
    subVariantPrice = json['subVariantPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['option'] = option;
    data['price'] = price;
    data['note'] = note;
    if (toppings != null) {
      data['toppings'] = toppings!.map((v) => v.toJson()).toList();
    }
    data['quantity'] = quantity;
    data['catDiscount'] = catDiscount;
    data['discount'] = discount;
    data['excludeDiscount'] = excludeDiscount;
    data['overallDiscount'] = overallDiscount;
    data['variant'] = variant;
    data['variantPrice'] = variantPrice.toString();
    data['subVariant'] = subVariant;
    data['subVariantPrice'] = subVariantPrice;
    return data;
  }
}

class Toppings {
  String? sId;
  String? createdOn;
  bool? isDeleted;
  String? name;
  String? price;
  String? iV;
  String? createdAt;
  String? updatedAt;
  int? toppingCount;

  Toppings(
      {this.sId,
      this.createdOn,
      this.isDeleted,
      this.name,
      this.price,
      this.iV,
      this.createdAt,
      this.updatedAt,
      this.toppingCount});

  Toppings.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    name = json['name'];
    price = json['price'].toString();
    iV = json['__v'].toString();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    toppingCount = json['toppingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['createdOn'] = createdOn;
    data['isDeleted'] = isDeleted;
    data['name'] = name;
    data['price'] = price;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['toppingCount'] = toppingCount;
    return data;
  }
}

class UserDetails {
  bool? isDelete;
  String? firstName;
  String? lastName;
  String? email;
  String? address;
  String? city;
  String? postcode;
  String? contact;

  UserDetails(
      {this.isDelete,
      this.firstName,
      this.lastName,
      this.email,
      this.address,
      this.city,
      this.postcode,
      this.contact});

  UserDetails.fromJson(Map<String, dynamic> json) {
    isDelete = json['isDelete'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    address = json['address'];
    city = json['city'];
    postcode = json['postcode'];
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isDelete'] = isDelete;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['address'] = address;
    data['city'] = city;
    data['postcode'] = postcode;
    data['contact'] = contact;
    return data;
  }
}

class SummaryData {
  String? sId;
  String? acceptedOrder;
  String? declinedOrder;
  String? pendingOrder;
  String? orderReceived;
  String? onlineOrderAmount;
  String? cashOrderAmount;
  String? totalOrderAmount;

  SummaryData(
      {this.sId,
      this.acceptedOrder,
      this.declinedOrder,
      this.pendingOrder,
      this.orderReceived,
      this.onlineOrderAmount,
      this.cashOrderAmount,
      this.totalOrderAmount});

  SummaryData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'].toString();
    acceptedOrder = json['acceptedOrder'].toString();
    declinedOrder = json['declinedOrder'].toString();
    pendingOrder = json['pendingOrder'].toString();
    orderReceived = json['orderReceived'].toString();
    onlineOrderAmount = json['onlineOrderAmount'].toString();
    cashOrderAmount = json['cashOrderAmount'].toString();
    totalOrderAmount = json['totalOrderAmount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['acceptedOrder'] = acceptedOrder;
    data['declinedOrder'] = declinedOrder;
    data['pendingOrder'] = pendingOrder;
    data['orderReceived'] = orderReceived;
    data['onlineOrderAmount'] = onlineOrderAmount;
    data['cashOrderAmount'] = cashOrderAmount;
    data['totalOrderAmount'] = totalOrderAmount;
    return data;
  }
}
