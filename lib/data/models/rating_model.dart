import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  final String id;
  final String ride;
  final RatedBy ratedBy;
  final RatedFor ratedFor;
  final String userId;
  final int rating;
  final String? feedback;
  final DateTime createdAt;

  const Rating({
    required this.id,
    required this.ride,
    required this.ratedBy,
    required this.ratedFor,
    required this.userId,
    required this.rating,
    this.feedback,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['_id'] ?? '',
      ride: json['ride'] ?? '',
      ratedBy: RatedBy.values.firstWhere(
        (e) => e.toString().split('.').last == json['ratedBy'],
        orElse: () => RatedBy.rider,
      ),
      ratedFor: RatedFor.values.firstWhere(
        (e) => e.toString().split('.').last == json['ratedFor'],
        orElse: () => RatedFor.driver,
      ),
      userId: json['userId'] ?? '',
      rating: json['rating'] ?? 0,
      feedback: json['feedback'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'ride': ride,
      'ratedBy': ratedBy.toString().split('.').last,
      'ratedFor': ratedFor.toString().split('.').last,
      'userId': userId,
      'rating': rating,
      'feedback': feedback,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Rating copyWith({
    String? id,
    String? ride,
    RatedBy? ratedBy,
    RatedFor? ratedFor,
    String? userId,
    int? rating,
    String? feedback,
    DateTime? createdAt,
  }) {
    return Rating(
      id: id ?? this.id,
      ride: ride ?? this.ride,
      ratedBy: ratedBy ?? this.ratedBy,
      ratedFor: ratedFor ?? this.ratedFor,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      feedback: feedback ?? this.feedback,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ride,
        ratedBy,
        ratedFor,
        userId,
        rating,
        feedback,
        createdAt,
      ];
}

enum RatedBy { rider, driver }

enum RatedFor { rider, driver }

class RatingRequest extends Equatable {
  final String ride;
  final RatedBy ratedBy;
  final RatedFor ratedFor;
  final String userId;
  final int rating;
  final String? feedback;

  const RatingRequest({
    required this.ride,
    required this.ratedBy,
    required this.ratedFor,
    required this.userId,
    required this.rating,
    this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      'ride': ride,
      'ratedBy': ratedBy.toString().split('.').last,
      'ratedFor': ratedFor.toString().split('.').last,
      'userId': userId,
      'rating': rating,
      'feedback': feedback,
    };
  }

  @override
  List<Object?> get props => [
        ride,
        ratedBy,
        ratedFor,
        userId,
        rating,
        feedback,
      ];
}

class RatingStats extends Equatable {
  final double averageRating;
  final int totalRatings;
  final Map<int, int> ratingBreakdown;

  const RatingStats({
    required this.averageRating,
    required this.totalRatings,
    required this.ratingBreakdown,
  });

  factory RatingStats.fromJson(Map<String, dynamic> json) {
    return RatingStats(
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalRatings: json['totalRatings'] ?? 0,
      ratingBreakdown: Map<int, int>.from(json['ratingBreakdown'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [averageRating, totalRatings, ratingBreakdown];
}
