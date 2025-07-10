
enum CourtTabs {
  appointments,
  activities,
  workdays,
  courses,
  media,
  about;
  static CourtTabs fromString(String s) => switch (s) {
    "appointments" => appointments,
    "activities" => activities,
    "workdays" => workdays,
    "courses" => courses,
    "media" => media,
    "about" => about,
    _ => about
  };
}
