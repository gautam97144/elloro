class FavouriteAudio {
  int? success;
  Data? data;
  String? message;

  FavouriteAudio({this.success, this.data, this.message});

  FavouriteAudio.fromJson(Map<String, dynamic> json) {
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
  int? favourite;

  Data({this.favourite});

  Data.fromJson(Map<String, dynamic> json) {
    favourite = json['favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['favourite'] = this.favourite;
    return data;
  }
}
