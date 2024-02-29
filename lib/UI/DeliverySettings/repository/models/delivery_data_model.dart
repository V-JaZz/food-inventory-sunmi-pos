class DeliveryListResponseModel {
  bool? success;
  DeliveryItemData? data;

  DeliveryListResponseModel({this.success, this.data});

  DeliveryListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = json['data'] != null
          ? DeliveryItemData.fromJson(json['data'])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
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
        distanceDetail!.add(DistanceDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (distanceDetail != null) {
      data['distanceDetails'] = distanceDetail!.map((v) => v.toJson()).toList();
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
  String? postcode;


  DistanceDetail({this.deliveryCharge, this.deliveryTime, this.maxDistance, this.minDistance,this.id});

  DistanceDetail.fromJson(Map<String, dynamic> json) {
    deliveryCharge = json['deliveryCharge'];
    deliveryTime = json['deliveryTime'];
    maxDistance = json['maxDistance'];
    minDistance = json['minDistance'].toString();
    minOrder = json['minOrder'].toString();
    id = json['id'].toString();
    postcode = json['postcode'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deliveryCharge'] = deliveryCharge;
    data['deliveryTime'] = deliveryTime;
    data['maxDistance'] = maxDistance;
    data['minDistance'] = minDistance;
    data['minOrder'] = minOrder;
    data['id'] = id;
    data['postcode'] = postcode;
    return data;
  }
}


