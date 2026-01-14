class FeedResponse {
  final List<PinnedTopic> pinnedTopics;
  final List<Post> trendingPosts;
  final List<Post> newPosts;

  FeedResponse({
    required this.pinnedTopics,
    required this.trendingPosts,
    required this.newPosts,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) {
    return FeedResponse(
      pinnedTopics: (json['pinned_topics'] as List)
          .map((e) => PinnedTopic.fromJson(e))
          .toList(),
      trendingPosts: (json['trending_posts'] as List)
          .map((e) => Post.fromJson(e))
          .toList(),
      newPosts:
          (json['new_posts'] as List).map((e) => Post.fromJson(e)).toList(),
    );
  }
}

class Post {
  final int id;
  final String content;
  final List<String> mediaUrls; // List of URLs (main media)
  final List<String> thumbnails; // List of URLs (thumbnails)
  final String createdAt;
  final int userId;
  final int reactionCount;
  final int commentsCount;
  final String authorName;
  final String topicName;
  final String author_profile_picture;

  Post({
    required this.id,
    required this.content,
    required this.mediaUrls,
    required this.thumbnails,
    required this.createdAt,
    required this.userId,
    required this.reactionCount,
    required this.commentsCount,
    required this.authorName,
    required this.topicName,
    required this.author_profile_picture,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    print("-------------------------");
    print(json);
    if (json['media_urls'] is Map) {
      // Case 1: 'media_urls' is an object with 'urls' and 'thumbnails' keys
      var mediaUrlsObj = json['media_urls'] as Map<String, dynamic>;

      List<String> mediaUrls = List<String>.from(mediaUrlsObj['urls'] ?? []);

      List<dynamic>? rawThumbnails = mediaUrlsObj['thumbnails'];
      List<String> thumbnails = (rawThumbnails ?? [])
          .map((e) => e?.toString() ?? '') // Replace nulls with empty strings
          .toList();

// If the lengths of the lists do not match, fill the shorter one with empty strings
      if (mediaUrls.length > thumbnails.length) {
        thumbnails = List.generate(mediaUrls.length, (index) {
          return index < thumbnails.length ? thumbnails[index] : '';
        });
      } else if (thumbnails.length > mediaUrls.length) {
        mediaUrls = List.generate(thumbnails.length, (index) {
          return index < mediaUrls.length ? mediaUrls[index] : '';
        });
      }

      return Post(
        id: json['id'],
        content: json['content'] ?? "",
        author_profile_picture: json['author_profile_picture'] ??
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqafzhnwwYzuOTjTlaYMeQ7hxQLy_Wq8dnQg&s',
        mediaUrls: mediaUrls,
        thumbnails: thumbnails,
        createdAt: json['created_at'] ?? "",
        userId: json['user_id'] ?? 1,
        reactionCount: json['reaction_count'] ?? "",
        commentsCount: json['comments_count'] ?? "",
        authorName: json['author_name'] ?? "",
        topicName: json['topic_name'] ?? "",
      );
    } else if (json['media_urls'] is List) {
      // Case 2: 'media_urls' is a simple list of URLs
      List<String> mediaUrls = List<String>.from(json['media_urls'] ?? []);
      List<String> thumbnails =
          List.generate(mediaUrls.length, (index) => ''); // Empty thumbnails

      return Post(
        author_profile_picture: json['author_profile_picture'] ??
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqafzhnwwYzuOTjTlaYMeQ7hxQLy_Wq8dnQg&s',
        id: json['id'],
        content: json['content'],
        mediaUrls: mediaUrls,
        thumbnails: thumbnails,
        createdAt: json['created_at'],
        userId: json['user_id'],
        reactionCount: json['reaction_count'],
        commentsCount: json['comments_count'],
        authorName: json['author_name'],
        topicName: json['topic_name'],
      );
    } else {
      throw Exception('Invalid media_urls format');
    }
  }
}

class PinnedTopic {
  final int id;
  final String name;
  final String description;
  final String image_url;
  final bool isPinned;

  PinnedTopic({
    required this.id,
    required this.name,
    required this.description,
    required this.image_url,
    required this.isPinned,
  });

  factory PinnedTopic.fromJson(Map<String, dynamic> json) {
    print("//////////////////");
    return PinnedTopic(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image_url: json['image_url'],
      isPinned: json['is_pinned'],
    );
  }
}
