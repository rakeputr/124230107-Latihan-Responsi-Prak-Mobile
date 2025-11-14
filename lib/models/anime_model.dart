class AnimeModel {
  final int malId;
  final String title;
  final String imageUrl;
  final double score;
  final String? synopsis;
  final int? rank;

  AnimeModel({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
    this.synopsis,
    this.rank,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      malId: json['mal_id'] as int,
      title: json['title'] as String,
      imageUrl: json['images']['jpg']['image_url'] as String,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      synopsis: json['synopsis'] as String?,
      rank: json['rank'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': malId,
      'title': title,
      'images': {
        'jpg': {'image_url': imageUrl},
      },
      'score': score,
      'synopsis': synopsis,
      'rank': rank,
    };
  }
}
