
enum MediaEnum {
  all,
  // groups,
  images,
  videos;

  static MediaEnum fromString(String s) => switch (s) {
  "all"=> all,
  // "groups"=> groups,
  "images"=> images,
  "videos"=> videos,
    _ => videos
  };
}
