class SlotDetailsModel {
  String? startTime;
  String? endTime;
  int? sessionDuration;


  SlotDetailsModel({
    this.startTime,
    this.endTime,
    this.sessionDuration,
  });

  SlotDetailsModel.fromJson(Map<String, dynamic> json) {
    startTime = json['start'];
    endTime = json['end'];
    sessionDuration = json['session_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = startTime;
    data['end'] = endTime;
    data['session_duration'] = sessionDuration;
    return data;
  }
}
