import 'package:centro_partner/features/home/data/model/media_model.dart';

class GroupModel {
  final String id;
  final String name;
  final List<MediaModel> media;

  GroupModel({
    required this.id,
    required this.name,
    required this.media,
  });

  // Optional: use the first media as the group cover
  String? get coverImageUrl {
    final firstImage = media.firstWhere(
          (m) => m.type == 'image',
    );
    return firstImage.thumbnailUrl ?? firstImage.url;
  }
}
