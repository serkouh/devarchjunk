class PostPined {
  final int id;
  final String content;
  final String createdAt;
  final List<String> mediaUrls;
  final String userName;
  final String userProfilePicture;

  PostPined({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.mediaUrls,
    required this.userName,
    required this.userProfilePicture,
  });

  factory PostPined.fromJson(Map<String, dynamic> json) {
    // Extract media URLs if available
    List<String> mediaUrls = [];
    if (json['media'] != null && json['media'] is List) {
      mediaUrls = List<String>.from(
        json['media']
            .where((mediaItem) => mediaItem['url'] != null)
            .map((mediaItem) => mediaItem['url']),
      );
    }

    // Extract user data safely
    final user = json['user'] ?? {};
    final userName = user['name'] ?? 'Unknown';
    final userProfilePicture = user['profile_picture'] ?? '';

    return PostPined(
      id: json['id'],
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
      mediaUrls: mediaUrls,
      userName: userName,
      userProfilePicture: userProfilePicture,
    );
  }
}

class Topicpined {
  final int id;
  final String name;
  final int postCount;
  final String imageFromPost;

  Topicpined(
      {required this.id,
      required this.name,
      required this.postCount,
      required this.imageFromPost});

  factory Topicpined.fromJson(Map<String, dynamic> json) {
    return Topicpined(
      id: json['id'],
      name: json['name'],
      postCount: json['post_count'],
      imageFromPost: json['preview_image'] ?? "",
    );
  }
}
