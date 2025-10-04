
enum StatusEnum {
  accepted,
  completed,
  canceled;
  static StatusEnum fromString(String s) => switch (s) {
    "accepted" => accepted,
    "completed" => completed,
    "canceled" => canceled,
    _ => canceled
  };
}
