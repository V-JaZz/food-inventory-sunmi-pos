class VarantListData {
  bool? success;
  List<VariantsList>? data;

  VarantListData({this.success, this.data});

  VarantListData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <VariantsList>[];
      json['data'].forEach((v) {
        data!.add(new VariantsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariantsList {
  String? sId;
  String? createdOn;
  bool? isDeleted;
  String? restaurantId;
  String? name;
  String? price;
  String? createdAt;
  String? updatedAt;
  VariantGroups? variantGroups;
  List<Variants>? variants;

  VariantsList(
      {this.sId,
      this.createdOn,
      this.isDeleted,
      this.restaurantId,
      this.name,
      this.price,
      this.createdAt,
      this.updatedAt,
      this.variantGroups,
      this.variants});

  VariantsList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    restaurantId = json['restaurantId'];
    name = json['name'];
    price = json['price'].toString();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    variantGroups = json['variantGroups'] != null
        ? new VariantGroups.fromJson(json['variantGroups'])
        : null;
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(new Variants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['createdOn'] = this.createdOn;
    data['isDeleted'] = this.isDeleted;
    data['restaurantId'] = this.restaurantId;
    data['name'] = this.name;
    data['price'] = this.price.toString();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.variantGroups != null) {
      data['variantGroups'] = this.variantGroups!.toJson();
    }
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariantGroups {
  String? sId;
  String? name;

  VariantGroups({this.sId, this.name});

  VariantGroups.fromJson(Map<String, dynamic> json) {
    sId = json['_id'].toString();
    name = json['name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId.toString();
    data['name'] = this.name.toString();
    return data;
  }
}

class Variants {
  String? sId;
  String? variantGroup;
  String? createdOn;
  bool? isDeleted;
  String? restaurantId;
  String? name;
  String? price;
  int? iV;
  String? createdAt;
  String? updatedAt;

  Variants(
      {this.sId,
      this.variantGroup,
      this.createdOn,
      this.isDeleted,
      this.restaurantId,
      this.name,
      this.price,
      this.iV,
      this.createdAt,
      this.updatedAt});

  Variants.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    variantGroup = json['variantGroup'];
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    restaurantId = json['restaurantId'];
    name = json['name'];
    price = json['price'].toString();
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['variantGroup'] = this.variantGroup;
    data['createdOn'] = this.createdOn;
    data['isDeleted'] = this.isDeleted;
    data['restaurantId'] = this.restaurantId;
    data['name'] = this.name;
    data['price'] = this.price.toString();
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
