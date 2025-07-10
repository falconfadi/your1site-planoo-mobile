
enum CourseType {
  daily,
  monthly;
  static CourseType fromString(String s) => switch (s) {
    "daily" => daily,
    "monthly" => monthly,
    _ => monthly
  };
}
