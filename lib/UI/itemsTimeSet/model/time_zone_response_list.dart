class TimeListResponseModel {
  bool? success;
  List<TimeZoneItemData>? data;

  TimeListResponseModel({this.success, this.data});

  TimeListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['timeZones'] != null) {
      data = <TimeZoneItemData>[];
      json['timeZones'].forEach((v) {
        data!.add(TimeZoneItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['timeZones'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeZoneItemData {
  String? sId;
  List<OptionsData>? options;
  String? name;
  String? startTime;
  String? endTime;
  String? zoneGroup;
  CategoryData? category;
  ToppingGroupData? toppingGroups;
  bool? isActive;
  List<dynamic>? days;

  // String? categoryName;
  // String? toppingGrpName;

  TimeZoneItemData(
      {this.sId,
      this.options,
      this.name,
      this.startTime,
      this.endTime,
        this.zoneGroup,
      // this.categoryName,
      // this.toppingGrpName
      this.category,
      this.toppingGroups,
      this.isActive,
      this.days});

  TimeZoneItemData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['items'] != null) {
      options = <OptionsData>[];
      json['items'].forEach((v) {
        options!.add(OptionsData.fromJson(v));
      });
    }
    name = json['name'];
    startTime = json['startTime'].toString();
    endTime = json['endTime'];
    zoneGroup = json['zoneGroup'];
    // categoryName = json['category'];
    // toppingGrpName = json['toppingGroups'];
    isActive = json['isActive'];
    days = json['days'] ?? [];
    category = json['category'] != null
        ? CategoryData.fromJson(json['category'])
        : null;
    toppingGroups = json['toppingGroups'] != null
        ? ToppingGroupData.fromJson(json['toppingGroups'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    data['startTime'] = startTime;
    /* if (this.toppings != null) {
      data['toppings'] = this.toppings!.map((v) => v.toJson()).toList();
    }*/
    // data['category'] = this.categoryName;
    // data['toppingGroups'] = this.toppingGrpName;
    data['endTime'] = endTime;
    data['zoneGroup'] = zoneGroup;

    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (toppingGroups != null) {
      data['toppingGroups'] = toppingGroups!.toJson();
    }
    return data;
  }
}

class OptionsData {
  String? sId;
  String? name;
  String? categoryId;

  OptionsData({ this.sId, this.name, this.categoryId});

  OptionsData.fromJson(Map<String, dynamic> json) {

    sId = json['id'];
    name = json['name'];
    categoryId = json['categoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = sId;
    data['name'] = name;
    data['categoryId'] = categoryId;
    return data;
  }
}

class DaysData {
  String? sId;
  String? createdOn;
  bool? isDeleted;
  String? name;
  String? price;
  String? iV;

  DaysData(
      {this.sId,
      this.createdOn,
      this.isDeleted,
      this.name,
      this.price,
      this.iV});

  DaysData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    name = json['name'];
    price = json['price'].toString();
    iV = json['__v'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['createdOn'] = createdOn;
    data['isDeleted'] = isDeleted;
    data['name'] = name;
    data['price'] = price;
    data['__v'] = iV;
    return data;
  }
}

class CategoryData {
  String? sId;
  String? name;

  CategoryData({this.sId, this.name});

  CategoryData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}

class ToppingGroupData {
  String? sId;
  String? name;
  String? price;

  ToppingGroupData({this.sId, this.name, this.price});

  ToppingGroupData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}
