
class MediaModel {
  final String id;
  final String name;
  final String url;
  final String? thumbnailUrl; // for videos or preview
  final String type; // 'image' or 'video'
  final double size; // in MB
  final DateTime createdAt;

  MediaModel({
    required this.id,
    required this.name,
    required this.url,
    this.thumbnailUrl,
    required this.type,
    required this.size,
    required this.createdAt,
  });
}
