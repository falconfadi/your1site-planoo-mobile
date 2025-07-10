
enum GenderType {
  male,
  female;
  static GenderType fromString(String s) => switch (s) {
    "male" => male,
    "female" => female,
    _ => female
  };
}
