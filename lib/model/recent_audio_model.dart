class RecentAudio {
  int? success;
  List<RecentAudioData>? data;
  String? message;

  RecentAudio({this.success, this.data, this.message});

  RecentAudio.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <RecentAudioData>[];
      json['data'].forEach((v) {
        data!.add(new RecentAudioData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class RecentAudioData {
  int? catalogueId;
  int? categoryId;
  int? creatorId;
  String? catalogueUniqueId;
  String? title;
  String? subTitle;
  String? description;
  String? duration;
  String? musicFileSize;
  String? image;
  String? musicFile;
  String? tokenPrice;
  int? status;
  String? createdAt;
  Null? updatedAt;
  String? categoryName;
  String? creatorCode;
  String? creatorName;
  String? creatorEmail;
  String? creatorAbout;
  String? creatorImage;
  int? isPurchased;
  int? favourite;
  String? avgRate;
  int? isIndicator;
  bool? isFavouriteIconVisible;

  RecentAudioData(
      {this.catalogueId,
      this.categoryId,
      this.creatorId,
      this.catalogueUniqueId,
      this.title,
      this.subTitle,
      this.description,
      this.duration,
      this.musicFileSize,
      this.image,
      this.musicFile,
      this.tokenPrice,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.categoryName,
      this.creatorCode,
      this.creatorName,
      this.creatorEmail,
      this.creatorAbout,
      this.creatorImage,
      this.isPurchased,
      this.favourite,
      this.avgRate,
      this.isIndicator,
      this.isFavouriteIconVisible});

  RecentAudioData.fromJson(Map<String, dynamic> json) {
    catalogueId = json['catalogue_id'];
    categoryId = json['category_id'];
    creatorId = json['creator_id'];
    catalogueUniqueId = json['catalogue_unique_id'];
    title = json['title'];
    subTitle = json['sub_title'];
    description = json['description'];
    duration = json['duration'];
    musicFileSize = json['music_file_size'];
    image = json['image'];
    musicFile = json['music_file'];
    tokenPrice = json['token_price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryName = json['category_name'];
    creatorCode = json['creator_code'];
    creatorName = json['creator_name'];
    creatorEmail = json['creator_email'];
    creatorAbout = json['creator_about'];
    creatorImage = json['creator_image'];
    isPurchased = json['is_purchased'];
    favourite = json['favourite'];
    avgRate = json['avg_rate'];
    isIndicator = json['isIndicator'];
    isFavouriteIconVisible = json["isFavouriteIconVisible"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catalogue_id'] = this.catalogueId;
    data['category_id'] = this.categoryId;
    data['creator_id'] = this.creatorId;
    data['catalogue_unique_id'] = this.catalogueUniqueId;
    data['title'] = this.title;
    data['sub_title'] = this.subTitle;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['music_file_size'] = this.musicFileSize;
    data['image'] = this.image;
    data['music_file'] = this.musicFile;
    data['token_price'] = this.tokenPrice;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['category_name'] = this.categoryName;
    data['creator_code'] = this.creatorCode;
    data['creator_name'] = this.creatorName;
    data['creator_email'] = this.creatorEmail;
    data['creator_about'] = this.creatorAbout;
    data['creator_image'] = this.creatorImage;
    data['is_purchased'] = this.isPurchased;
    data['favourite'] = this.favourite;
    data['avg_rate'] = this.avgRate;
    data['isIndicator'] = this.isIndicator;
    data['isFavouriteIconVisible'] = this.isFavouriteIconVisible;
    return data;
  }
}
