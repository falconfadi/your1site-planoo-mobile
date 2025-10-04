
enum MainTabs {
  activities,
  classes,
  events,
  entertainment;
  static MainTabs fromString(String s) => switch (s) {
    "activities" => activities,
    "classes" => classes,
    "events" => events,
    "entertainment" => entertainment,
    _ => entertainment
  };
}
