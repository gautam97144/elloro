class CatalogDetail {
  int? success;
  Null? data;
  String? message;

  CatalogDetail({this.success, this.data, this.message});

  CatalogDetail.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    data['message'] = this.message;
    return data;
  }
}
