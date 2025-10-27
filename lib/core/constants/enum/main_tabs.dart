
enum MainTabs {
  activities,
  courses,
  events;
  static MainTabs fromString(String s) => switch (s) {
    "activities" => activities,
    "courses" => courses,
    "events" => events,
    _ => events
  };
}
