
class LocationModel {
  int? iD;
  double? long;
  double? lat;
  String? name;
  String? createdAt;

  LocationModel({
    this.iD,
    this.long,
    this.lat,
    this.name,
    this.createdAt,
  });

  LocationModel.fromJson(Map<String, dynamic> json) {
    iD = json['id'];
    long = json['long'];
    lat = json['lat'];
    name = json['name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = iD;
    data['long'] = long;
    data['lat'] = lat;
    data['name'] = name;
    data['created_at'] = createdAt;
    return data;
  }
}
