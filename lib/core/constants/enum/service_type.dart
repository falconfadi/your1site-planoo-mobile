
enum ServiceType {
  normal,
  vip;
  static ServiceType fromString(String s) => switch (s) {
    "normal" => normal,
    "vip" => vip,
    _ => vip
  };
}
