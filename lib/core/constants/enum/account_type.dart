
enum AccountType {
  stadium,
  trainer;
  static AccountType fromString(String s) => switch (s) {
    "stadium" => stadium,
    "trainer" => trainer,
    _ => trainer
  };
}
