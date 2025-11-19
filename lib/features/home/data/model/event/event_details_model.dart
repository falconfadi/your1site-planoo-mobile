import 'package:centro_partner/features/home/data/model/category_model.dart';
import 'package:centro_partner/features/home/data/model/customer_model.dart';
import 'package:centro_partner/features/home/data/model/workday/workday_details_model.dart';
import 'package:centro_partner/features/home/data/model/facility_model.dart';
import 'package:centro_partner/features/home/data/model/location_model.dart';
import 'package:centro_partner/features/profile/data/model/profile_image_model.dart';

class EventDetailsModel {
  int? iD;
  String? name;
  String? description;
  CategoryInfoModel? category;
  bool? isActive;
  bool? isFull;
  int? eventDuration;
  int? capacity;
  int? admissionFee;
  int? withdrawalFee;
  String? startDate;
  String? endDate;
  int? rate;
  String? status;
  List<WorkdayDetailsModel>? workdaysList;
  List<FacilityInfoModel>? facilitiesList;
  LocationModel? location;
  List<ImageModel>? mediaList;
  List<CustomerModel>? customersList;

  EventDetailsModel({
    this.iD,
    this.name,
    this.description,
    this.category,
    this.isActive,
    this.isFull,
    this.eventDuration,
    this.capacity,
    this.admissionFee,
    this.withdrawalFee,
    this.startDate,
    this.endDate,
    this.rate,
    this.status,
    this.workdaysList,
    this.facilitiesList,
    this.location,
    this.mediaList,
    this.customersList
  });

  EventDetailsModel.fromJson(Map<String, dynamic> json) {
    iD = json['id'];
    name = json['name'];
    description = json['description'];
    category = json['category'] != null ? CategoryInfoModel.fromJson(json['category']) : null;
    isActive = json['is_active'];
    isFull = json['is_full'];
    eventDuration = json['event_duration'];
    capacity = json['capacity'];
    admissionFee = json['admission_fee'];
    withdrawalFee = json['withdrawal_fee'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    rate = json['rate'];
    status = json['status'];
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
    if (json['customers'] != null) {
      customersList = <CustomerModel>[];
      json['customers'].forEach((v) {
        customersList!.add(CustomerModel.fromJson(v));
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
    data['is_full'] = isFull;
    data['event_duration'] = eventDuration;
    data['capacity'] = capacity;
    data['admission_fee'] = admissionFee;
    data['withdrawal_fee'] = withdrawalFee;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['rate'] = rate;
    data['status'] = status;
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
    if (customersList != null) {
      data['customers'] = customersList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
