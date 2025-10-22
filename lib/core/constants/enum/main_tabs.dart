
enum MainTabs {
  activities,
  courses,
  events,
  entertainment;
  static MainTabs fromString(String s) => switch (s) {
    "activities" => activities,
    "courses" => courses,
    "events" => events,
    "entertainment" => entertainment,
    _ => entertainment
  };
}
