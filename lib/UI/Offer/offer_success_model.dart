class OfferSuccessModel{
  bool? success;
  String? data;

  OfferSuccessModel(this.success,this.data, );

  OfferSuccessModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    // ignore: prefer_if_null_operators
    data = json['data'] == null ? "" : json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!;
    }
    return data;
  }
}