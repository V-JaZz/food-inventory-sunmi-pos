class DeliveryListResponseModel {
  bool? success;
  DeliveryItemData? data;

  DeliveryListResponseModel({this.success, this.data});

  DeliveryListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = json['data'] != null
          ? new DeliveryItemData.fromJson(json['data'])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DeliveryItemData {
  List<DistanceDetail>? distanceDetail;
  // String? categoryName;
  // String? toppingGrpName;

  DeliveryItemData(
      {
        this.distanceDetail,
      });

  DeliveryItemData.fromJson(Map<String, dynamic> json) {
    if (json['distanceDetails'] != null) {
      distanceDetail = <DistanceDetail>[];
      json['distanceDetails'].forEach((v) {
        distanceDetail!.add(new DistanceDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.distanceDetail != null) {
      data['distanceDetails'] = this.distanceDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DistanceDetail {
  String? deliveryCharge;
  String? deliveryTime;
  String? maxDistance;
  String? minDistance;
  String? minOrder;
  String? id;

  DistanceDetail({this.deliveryCharge, this.deliveryTime, this.maxDistance, this.minDistance,this.id});

  DistanceDetail.fromJson(Map<String, dynamic> json) {
    print("DistanceDetail  $json");
    deliveryCharge = json['deliveryCharge'];
    deliveryTime = json['deliveryTime'];
    maxDistance = json['maxDistance'];
    minDistance = json['minDistance'].toString();
    minOrder = json['minOrder'].toString();
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deliveryCharge'] = this.deliveryCharge;
    data['deliveryTime'] = this.deliveryTime;
    data['maxDistance'] = this.maxDistance;
    data['minDistance'] = this.minDistance;
    data['minOrder'] = this.minOrder;
    data['id'] = this.id;
    return data;
  }
}


