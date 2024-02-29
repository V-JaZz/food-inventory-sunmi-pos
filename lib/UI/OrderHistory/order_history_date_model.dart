class OrderHistoryDateModel {
  bool? success;
  List<OrderHistoryData>? data;

  OrderHistoryDateModel({this.success, this.data});

  OrderHistoryDateModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <OrderHistoryData>[];
      json['data'].forEach((v) {
        data!.add(OrderHistoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderHistoryData {
  String? sId;
  String? acceptedOrder;
  String? declinedOrder;
  String? pendingOrder;
  String? orderReceived;
  String? onlineOrderAmount;
  String? cashOrderAmount;
  String? totalOrderAmount;

  OrderHistoryData(
      {this.sId,
      this.acceptedOrder,
      this.declinedOrder,
      this.pendingOrder,
      this.orderReceived,
      this.onlineOrderAmount,
      this.cashOrderAmount,
      this.totalOrderAmount});

  OrderHistoryData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
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
