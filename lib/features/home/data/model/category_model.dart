import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';

class CategoryResponse extends ApiResponse<CategoryModel> {
  CategoryResponse({required super.errors, required super.message, required super.data});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      errors: json["payload"]["errors"] != null
          ? CategoryModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: CategoryModel.fromJson(json["payload"]),
    );
  }
}

class CategoryModel extends BaseModel {

  List<CategoryInfoModel>? categoriesList;

  CategoryModel({this.categoriesList});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categoriesList = <CategoryInfoModel>[];
      json['categories'].forEach((v) {
        categoriesList!.add(CategoryInfoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.categoriesList != null) {
      data['categories'] = this.categoriesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryInfoModel extends BaseModel {
  int? ID;
  String? name;

  CategoryInfoModel({this.ID, this.name});

  CategoryInfoModel.fromJson(Map<String, dynamic> json) {
    ID = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': ID,
      'name': name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CategoryInfoModel && runtimeType == other.runtimeType && ID == other.ID;

  @override
  int get hashCode => ID.hashCode;
}

