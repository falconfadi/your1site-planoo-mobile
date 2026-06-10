
enum MainTabs {
  courts,
  courses,
  events;
  static MainTabs fromString(String s) => switch (s) {
    "courts" => courts,
    "courses" => courses,
    "events" => events,
    _ => events
  };
}
