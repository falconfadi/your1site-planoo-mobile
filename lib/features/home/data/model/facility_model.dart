import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';

class FacilityResponse extends ApiResponse<FacilityModel> {
  FacilityResponse({required super.errors, required super.message, required super.data});

  factory FacilityResponse.fromJson(Map<String, dynamic> json) {
    return FacilityResponse(
      errors: json["payload"]["errors"] != null
          ? FacilityModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: FacilityModel.fromJson(json["payload"]),
    );
  }
}

class FacilityModel extends BaseModel {

  List<FacilityInfoModel>? facilitiesList;

  FacilityModel({this.facilitiesList});

  FacilityModel.fromJson(Map<String, dynamic> json) {
    if (json['tags'] != null) {
      facilitiesList = <FacilityInfoModel>[];
      json['tags'].forEach((v) {
        facilitiesList!.add(FacilityInfoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.facilitiesList != null) {
      data['tags'] = this.facilitiesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FacilityInfoModel extends BaseModel {
  int? ID;
  String? name;
  String? icon;

  FacilityInfoModel({this.ID, this.name,this.icon});

  FacilityInfoModel.fromJson(Map<String, dynamic> json) {
    ID = json['id'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': ID,
      'name': name,
      'icon': icon,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FacilityInfoModel && runtimeType == other.runtimeType && ID == other.ID;

  @override
  int get hashCode => ID.hashCode;
}

