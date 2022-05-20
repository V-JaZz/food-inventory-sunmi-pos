// ignore_for_file: prefer_collection_literals

class MenuItems {
  bool? success;
  List<Data>? data;

  MenuItems({this.success, this.data});

  MenuItems.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? name;
  List<Items>? items;

  Data({this.name, this.items});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? sId;
  List<Options>? options;
  List<Variants>? variants;
  int? discount;
  String? description;
  bool? excludeDiscount;
  String? name;
  Category? category;
  String? price;
  int? position;
  AllergyGroups? allergyGroups;
  List<Allergies>? allergies;
  String? imageName;

  Items(
      {this.sId,
      this.options,
      this.variants,
      this.discount,
      this.description,
      this.excludeDiscount,
      this.name,
      this.category,
      this.price,
      this.position,
      this.allergyGroups,
      this.allergies,
      this.imageName});

  Items.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
    discount = json['discount'];
    description = json['description'];
    excludeDiscount = json['excludeDiscount'];
    name = json['name'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    price = json['price'].toString();
    position = json['position'];
    allergyGroups = json['allergyGroups'] != null
        ? AllergyGroups.fromJson(json['allergyGroups'])
        : null;
    if (json['allergies'] != null) {
      allergies = <Allergies>[];
      json['allergies'].forEach((v) {
        allergies!.add(Allergies.fromJson(v));
      });
    }
    imageName = json['imageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    data['discount'] = discount;
    data['description'] = description;
    data['excludeDiscount'] = excludeDiscount;
    data['name'] = name;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['price'] = price.toString();
    data['position'] = position;
    if (allergyGroups != null) {
      data['allergyGroups'] = allergyGroups!.toJson();
    }
    if (allergies != null) {
      data['allergies'] = allergies!.map((v) => v.toJson()).toList();
    }
    data['imageName'] = imageName;
    return data;
  }
}

class Options {
  String? minToppings;
  String? maxToppings;
  String? createdOn;
  String? restaurantId;
  String? sId;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? price;
  List<Toppings>? toppings;
  String? toppingGroup;

  Options(
      {this.minToppings,
      this.maxToppings,
      this.createdOn,
      this.restaurantId,
      this.sId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.price,
      this.toppings,
      this.toppingGroup});

  Options.fromJson(Map<String, dynamic> json) {
    minToppings = json['minToppings'].toString();
    maxToppings = json['maxToppings'].toString();
    createdOn = json['createdOn'];
    restaurantId = json['restaurantId'];
    sId = json['_id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    price = json['price'];
    if (json['toppings'] != null) {
      toppings = <Toppings>[];
      json['toppings'].forEach((v) {
        toppings!.add(Toppings.fromJson(v));
      });
    }
    toppingGroup = json['toppingGroup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['minToppings'] = minToppings.toString();
    data['maxToppings'] = maxToppings.toString();
    data['createdOn'] = createdOn;
    data['restaurantId'] = restaurantId;
    data['_id'] = sId;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['price'] = price;
    if (toppings != null) {
      data['toppings'] = toppings!.map((v) => v.toJson()).toList();
    }
    data['toppingGroup'] = toppingGroup;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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

class Variants {
  String? sId;
  String? variantGroup;
  String? createdOn;
  String? restaurantId;
  String? name;
  int? iV;
  String? createdAt;
  String? updatedAt;
  String? price;
  List<SubVariants>? subVariants;

  Variants(
      {this.sId,
      this.variantGroup,
      this.createdOn,
      this.restaurantId,
      this.name,
      this.iV,
      this.createdAt,
      this.updatedAt,
      this.price,
      this.subVariants});

  Variants.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    variantGroup = json['variantGroup'];
    createdOn = json['createdOn'];
    restaurantId = json['restaurantId'];
    name = json['name'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    price = json['price'].toString();
    if (json['subVariants'] != null) {
      subVariants = <SubVariants>[];
      json['subVariants'].forEach((v) {
        subVariants!.add(SubVariants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['variantGroup'] = variantGroup;
    data['createdOn'] = createdOn;
    data['restaurantId'] = restaurantId;
    data['name'] = name;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['price'] = price.toString();
    if (subVariants != null) {
      data['subVariants'] = subVariants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubVariants {
  String? sId;
  String? variantGroup;
  String? createdOn;
  bool? isDeleted;
  String? restaurantId;
  String? name;
  int? price;
  int? iV;
  String? createdAt;
  String? updatedAt;

  SubVariants(
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

  SubVariants.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    variantGroup = json['variantGroup'];
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['variantGroup'] = variantGroup;
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

class Category {
  String? sId;
  String? name;
  int? position;
  String? description;
  int? discount;
  bool? excludeDiscount;

  Category(
      {this.sId,
      this.name,
      this.position,
      this.description,
      this.discount,
      this.excludeDiscount});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    position = json['position'];
    description = json['description'];
    discount = json['discount'];
    excludeDiscount = json['excludeDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['name'] = name;
    data['position'] = position;
    data['description'] = description;
    data['discount'] = discount;
    data['excludeDiscount'] = excludeDiscount;
    return data;
  }
}

class AllergyGroups {
  String? sId;
  String? name;

  AllergyGroups({this.sId, this.name});

  AllergyGroups.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}

class Allergies {
  String? sId;
  String? createdOn;
  bool? isDeleted;
  String? restaurantId;
  String? name;
  String? description;
  int? iV;
  String? createdAt;
  String? updatedAt;

  Allergies(
      {this.sId,
      this.createdOn,
      this.isDeleted,
      this.restaurantId,
      this.name,
      this.description,
      this.iV,
      this.createdAt,
      this.updatedAt});

  Allergies.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdOn = json['createdOn'];
    isDeleted = json['isDeleted'];
    restaurantId = json['restaurantId'];
    name = json['name'];
    description = json['description'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['createdOn'] = createdOn;
    data['isDeleted'] = isDeleted;
    data['restaurantId'] = restaurantId;
    data['name'] = name;
    data['description'] = description;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
