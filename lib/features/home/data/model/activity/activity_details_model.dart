import 'package:centro_partner/features/home/data/model/category_model.dart';
import 'package:centro_partner/features/home/data/model/workday/workday_details_model.dart';
import 'package:centro_partner/features/home/data/model/facility_model.dart';
import 'package:centro_partner/features/home/data/model/location_model.dart';
import 'package:centro_partner/features/profile/data/model/profile_image_model.dart';

class ActivityDetailsModel {
  int? iD;
  String? name;
  String? description;
  CategoryInfoModel? category;
  bool? isActive;
  int? price;
  int? sessionDuration;
  int? rate;
  List<WorkdayDetailsModel>? workdaysList;
  List<FacilityInfoModel>? facilitiesList;
  LocationModel? location;
  List<ImageModel>? mediaList;

  ActivityDetailsModel({
    this.iD,
    this.name,
    this.description,
    this.category,
    this.isActive,
    this.price,
    this.sessionDuration,
    this.rate,
    this.workdaysList,
    this.facilitiesList,
    this.location,
    this.mediaList
  });

  ActivityDetailsModel.fromJson(Map<String, dynamic> json) {
    iD = json['id'];
    name = json['name'];
    description = json['description'];
    category = json['category'] != null ? CategoryInfoModel.fromJson(json['category']) : null;
    isActive = json['is_active'];
    price = json['price'];
    sessionDuration = json['session_duration'];
    rate = json['rate'];
    if (json['days'] != null) {
      workdaysList = <WorkdayDetailsModel>[];
      json['days'].forEach((v) {
        workdaysList!.add(WorkdayDetailsModel.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      facilitiesList = <FacilityInfoModel>[];
      json['tags'].forEach((v) {
        facilitiesList!.add(FacilityInfoModel.fromJson(v));
      });
    }
    location = json['location'] != null ? LocationModel.fromJson(json['location']) : null;
    if (json['medias'] != null) {
      mediaList = <ImageModel>[];
      json['medias'].forEach((v) {
        mediaList!.add(ImageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = iD;
    data['name'] = name;
    data['description'] = description;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['is_active'] = isActive;
    data['price'] = price;
    data['session_duration'] = sessionDuration;
    data['rate'] = rate;
    if (facilitiesList != null) {
      data['tags'] = facilitiesList!.map((v) => v.toJson()).toList();
    }
    if(workdaysList != null) {
      data["days"] = workdaysList!.map((e) => e.toJson()).toList();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (mediaList != null) {
      data['medias'] = mediaList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
