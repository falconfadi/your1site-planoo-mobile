
class WorkdayDetailsModel {
  int? iD;
  String? day;
  String? start;
  String? end;
  bool? isActive;

  WorkdayDetailsModel({
    this.iD,
    this.day,
    this.start,
    this.end,
    this.isActive,
  });

  WorkdayDetailsModel.fromJson(Map<String, dynamic> json) {
    iD = json['id'];
    day = json['day'];
    start = json['start'];
    end = json['end'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = iD;
    data['day'] = day;
    data['start'] = start;
    data['end'] = end;
    data['is_active'] = isActive;
    return data;
  }
}
