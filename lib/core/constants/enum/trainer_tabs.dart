
enum TrainerTabs {
  appointments,
  subscribers,
  activities,
  workdays,
  media,
  about;
  static TrainerTabs fromString(String s) => switch (s) {
    "appointments" => appointments,
    "subscribers" => subscribers,
    "activities" => activities,
    "workdays" => workdays,
    "media" => media,
    "about" => about,
    _ => about
  };
}
