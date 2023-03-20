class RecommendationList {
  int? success;
  List<Data>? data;
  String? message;

  RecommendationList({this.success, this.data, this.message});

  RecommendationList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
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
  String? sampleMusicFile;
  String? tokenPrice;
  int? status;
  String? createdAt;
  Null? updatedAt;
  int? isFree;

  String? categoryName;
  String? creatorCode;
  String? creatorName;
  String? creatorEmail;
  String? creatorAbout;
  String? creatorImage;
  int? isPurchased;
  int? favourite;
  String? avgRate;

  Data(
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
      this.sampleMusicFile,
      this.tokenPrice,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.categoryName,
      this.creatorCode,
      this.isFree,
      this.creatorName,
      this.creatorEmail,
      this.creatorAbout,
      this.creatorImage,
      this.isPurchased,
      this.favourite,
      this.avgRate});

  Data.fromJson(Map<String, dynamic> json) {
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
    sampleMusicFile = json['sample_music_file'];
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
    isFree = json['is_free'];

    avgRate = json['avg_rate'];
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
    data['sample_music_file'] = this.sampleMusicFile;
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
    data['is_free'] = this.isFree;

    return data;
  }
}
