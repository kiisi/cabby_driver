import 'package:cabby_driver/data/network/api_provider.dart';

import '../models/rating_model.dart';

class RatingRepository {
  final ApiProvider _apiProvider;

  RatingRepository(this._apiProvider);

  Future<Rating> submitRating(RatingRequest request) async {
    final response = await _apiProvider.post('/ratings', request.toJson());
    return Rating.fromJson(response.data);
  }

  Future<List<Rating>> getRideRatings(String rideId) async {
    final response = await _apiProvider.get('/ratings/ride/$rideId');
    return (response.data as List).map((rating) => Rating.fromJson(rating)).toList();
  }

  Future<List<Rating>> getDriverRatings(String driverId) async {
    final response = await _apiProvider.get('/ratings/driver/$driverId');
    return (response.data as List).map((rating) => Rating.fromJson(rating)).toList();
  }

  Future<RatingStats> getDriverRatingStats(String driverId) async {
    final response = await _apiProvider.get('/ratings/driver/$driverId/stats');
    return RatingStats.fromJson(response.data);
  }

  Future<Rating?> getRatingByRideAndUser(String rideId, String userId) async {
    final response = await _apiProvider.get('/ratings/ride/$rideId/user/$userId');
    if (response.data != null) {
      return Rating.fromJson(response.data);
    }
    return null;
  }

  Future<bool> hasUserRatedRide(String rideId, String userId) async {
    try {
      final rating = await getRatingByRideAndUser(rideId, userId);
      return rating != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateRating(String ratingId, RatingRequest request) async {
    await _apiProvider.put('/ratings/$ratingId', request.toJson());
  }

  Future<void> deleteRating(String ratingId) async {
    await _apiProvider.delete('/ratings/$ratingId');
  }
}
