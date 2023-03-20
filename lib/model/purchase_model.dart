class Purchase {
  int? success;
  Data? data;
  String? message;

  Purchase({this.success, this.data, this.message});

  Purchase.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? totalToken;

  Data({this.totalToken});

  Data.fromJson(Map<String, dynamic> json) {
    totalToken = json['total_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_token'] = this.totalToken;
    return data;
  }
}
