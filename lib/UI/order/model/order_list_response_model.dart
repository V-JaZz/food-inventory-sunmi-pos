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
        data!.add(new OrderDataModel.fromJson(v));
      });
    }
    summaryData = json['summaryData'] != null
        ? new SummaryData.fromJson(json['summaryData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.summaryData != null) {
      data['summaryData'] = this.summaryData!.toJson();
    }
    return data;
  }
}

//ase hogaa
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
        itemDetails!.add(new ItemDetails.fromJson(v));
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
        ? new UserDetails.fromJson(json['userDetails'])
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.itemDetails != null) {
      data['itemDetails'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    data['createdOn'] = this.createdOn;
    data['orderStatus'] = this.orderStatus;
    data['note'] = this.note;
    data['isDeleted'] = this.isDeleted;
    data['deliveryType'] = this.deliveryType;
    data['paymentMode'] = this.paymentMode;
    data['deliveryAddress'] = this.deliveryAddress;
    data['advanceOrderDate'] = this.advanceOrderDate;
    data['totalAmount'] = this.totalAmount;
    data['deliveryDatetime'] = this.deliveryDatetime;
    data['orderDateTime'] = this.orderDateTime;
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    data['orderNumber'] = this.orderNumber;
    data['__v'] = this.iV;
    data['subTotal'] = this.subTotal;
    data['discount'] = this.discount;
    data['deliveryCharge'] = this.deliveryCharge;
    data['isPaid'] = this.isPaid;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['orderTime'] = this.orderTime;
    data['tip'] = this.tip;
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
      data = new OrderDataModel.fromJson(json['data']);
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
      this.subVariantPrice});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    option = json['option'];
    price = json['price'].toString();
    note = json['note'];
    if (json['toppings'] != null) {
      toppings = [];
      json['toppings'].forEach((v) {
        toppings!.add(new Toppings.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['option'] = this.option;
    data['price'] = this.price;
    data['note'] = this.note;
    if (this.toppings != null) {
      data['toppings'] = this.toppings!.map((v) => v.toJson()).toList();
    }
    data['quantity'] = this.quantity;
    data['catDiscount'] = this.catDiscount;
    data['discount'] = this.discount;
    data['excludeDiscount'] = this.excludeDiscount;
    data['overallDiscount'] = this.overallDiscount;
    data['variant'] = this.variant;
    data['variantPrice'] = this.variantPrice.toString();
    data['subVariant'] = this.subVariant;
    data['subVariantPrice'] = this.subVariantPrice;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['createdOn'] = this.createdOn;
    data['isDeleted'] = this.isDeleted;
    data['name'] = this.name;
    data['price'] = this.price;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['toppingCount'] = this.toppingCount;
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
  String? passcode;
  String? contact;

  UserDetails(
      {this.isDelete,
      this.firstName,
      this.lastName,
      this.email,
      this.address,
      this.city,
      this.passcode,
      this.contact});

  UserDetails.fromJson(Map<String, dynamic> json) {
    isDelete = json['isDelete'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    address = json['address'];
    city = json['city'];
    passcode = json['passcode'];
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isDelete'] = this.isDelete;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['address'] = this.address;
    data['city'] = this.city;
    data['passcode'] = this.passcode;
    data['contact'] = this.contact;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['acceptedOrder'] = this.acceptedOrder;
    data['declinedOrder'] = this.declinedOrder;
    data['pendingOrder'] = this.pendingOrder;
    data['orderReceived'] = this.orderReceived;
    data['onlineOrderAmount'] = this.onlineOrderAmount;
    data['cashOrderAmount'] = this.cashOrderAmount;
    data['totalOrderAmount'] = this.totalOrderAmount;
    return data;
  }
}
