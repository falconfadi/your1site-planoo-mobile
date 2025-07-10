
enum DaysEnum {
  sunday,
  monday, 
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday;
  static DaysEnum fromString(String s) => switch (s) {
  "sunday"=> sunday,
  "monday"=> monday,
  "tuesday"=> tuesday,
  "wednesday"=> wednesday,
  "thursday"=> thursday,
  "friday"=> friday,
  "saturday"=> saturday,
    _ => saturday
  };
}
