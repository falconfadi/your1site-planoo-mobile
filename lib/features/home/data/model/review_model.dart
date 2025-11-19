import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/home/data/model/customer_model.dart';

class ReviewResponse extends ApiResponse<ReviewModel> {
  ReviewResponse({required super.errors, required super.message, required super.data});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      errors: json["payload"]["errors"] != null
          ? ReviewModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: ReviewModel.fromJson(json["payload"]),
    );
  }
}

class ReviewModel extends BaseModel {

  List<ReviewInfoModel>? reviewsList;

  ReviewModel({this.reviewsList});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    if (json['reviews'] != null) {
      reviewsList = <ReviewInfoModel>[];
      json['reviews'].forEach((v) {
        reviewsList!.add(ReviewInfoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.reviewsList != null) {
      data['reviews'] = this.reviewsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReviewInfoModel {
  int? id;
  int? rate;
  String? content;
  String? createdAt;
  CustomerModel? customer;

  ReviewInfoModel({
    this.id,
    this.rate,
    this.content,
    this.createdAt,
    this.customer
  });

  ReviewInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rate = json['rate'];
    content = json['content'];
    createdAt = json['created_at'];
    customer = json['customer'] != null ? CustomerModel.fromJson(json['customer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rate'] = rate;
    data['content'] = content;
    data['created_at'] = createdAt;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

