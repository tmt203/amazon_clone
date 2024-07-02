import 'dart:convert';

class Rating {
  final String userId;
  final num rating;

  Rating({
    required this.userId,
    required this.rating,
  });

  Rating copyWith({
    String? userId,
    double? rating,
  }) {
    return Rating(
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'rating': rating,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      userId: map['userId'] as String,
      rating: map['rating'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Rating(userId: $userId, rating: $rating)';

  @override
  bool operator ==(covariant Rating other) {
    if (identical(this, other)) return true;

    return other.userId == userId && other.rating == rating;
  }

  @override
  int get hashCode => userId.hashCode ^ rating.hashCode;
}
