import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:cabby_driver/core/common/constant.dart';
import '../../data/models/driver_model.dart';
import '../../data/models/ride_model.dart';
import '../../data/models/earnings_model.dart';

class ApiProvider {
  late Dio _dio;
  String? _token;

  // Singleton instance
  static ApiProvider? _instance;

  // Singleton factory
  factory ApiProvider() {
    _instance ??= ApiProvider._internal();
    return _instance!;
  }

  // Private constructor
  ApiProvider._internal() {
    _initDio();
  }

  // Initialize Dio client
  void _initDio() {
    final baseOptions = BaseOptions(
      baseUrl: Constant.baseUrl,
      connectTimeout: const Duration(milliseconds: 15000),
      receiveTimeout: const Duration(milliseconds: 15000),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(baseOptions);

    // Add interceptors for logging and authorization
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add authorization token if available
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Handle response
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          // Handle error
          return handler.next(error);
        },
      ),
    );

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  // Generic GET
  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      return await _dio.get(path, queryParameters: query);
    } catch (error) {
      return _handleError(error);
    }
  }

// Generic POST
  Future<Response> post(String path, Map<String, dynamic> data) async {
    try {
      return await _dio.post(path, data: data);
    } catch (error) {
      return _handleError(error);
    }
  }

// Generic PUT
  Future<Response> put(String path, Map<String, dynamic> data) async {
    try {
      return await _dio.put(path, data: data);
    } catch (error) {
      return _handleError(error);
    }
  }

// Generic DELETE
  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (error) {
      return _handleError(error);
    }
  }

  // Set authentication token
  void setToken(String token) {
    _token = token;
  }

  // Clear authentication token
  void clearToken() {
    _token = null;
  }

  // Helper method to handle errors
  dynamic _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        // Server responded with an error
        final errorMessage =
            error.response!.data is Map ? error.response!.data['message'] ?? 'Unknown error' : 'Server error';
        return Future.error(errorMessage);
      } else {
        // No response (network error, timeout, etc.)
        return Future.error('Network error: ${error.message}');
      }
    } else {
      // Other errors
      return Future.error('Unexpected error: $error');
    }
  }

  // AUTHENTICATION ENDPOINTS

  // Driver login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/driver/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      // Set token for future requests
      if (response.data['token'] != null) {
        setToken(response.data['token']);
      }

      return response.data;
    } catch (error) {
      return _handleError(error);
    }
  }

  // Driver registration
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String licenseNumber,
    required VehicleInfo vehicle,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/driver/register',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'licenseNumber': licenseNumber,
          'vehicle': vehicle.toJson(),
        },
      );

      // Set token for future requests
      if (response.data['token'] != null) {
        setToken(response.data['token']);
      }

      return response.data;
    } catch (error) {
      return _handleError(error);
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _dio.post('/auth/driver/logout');
      clearToken();
      return;
    } catch (error) {
      return _handleError(error);
    }
  }

  // Get current driver profile
  Future<DriverModel> getProfile() async {
    try {
      final response = await _dio.get('/drivers/profile');
      return DriverModel.fromJson(response.data);
    } catch (error) {
      return _handleError(error);
    }
  }

  // Update driver profile
  Future<DriverModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/drivers/profile', data: data);
      return DriverModel.fromJson(response.data);
    } catch (error) {
      return _handleError(error);
    }
  }

  // Update driver location
  Future<void> updateLocation(double latitude, double longitude) async {
    try {
      await _dio.post(
        '/drivers/location',
        data: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );
      return;
    } catch (error) {
      return _handleError(error);
    }
  }

  // RIDE ENDPOINTS

  // Get active ride
  Future<RideModel?> getActiveRide() async {
    try {
      final response = await _dio.get('/drivers/rides/active');
      if (response.data == null) return null;
      return RideModel.fromJson(response.data);
    } catch (error) {
      if (error is DioException && error.response?.statusCode == 404) {
        // No active ride
        return null;
      }
      return _handleError(error);
    }
  }

  // Get ride by ID
  Future<RideModel> getRide(String rideId) async {
    try {
      final response = await _dio.get('/rides/$rideId');
      return RideModel.fromJson(response.data);
    } catch (error) {
      return _handleError(error);
    }
  }

  // Get nearby ride requests
  Future<List<RideModel>> getNearbyRideRequests() async {
    try {
      final response = await _dio.get('/drivers/rides/nearby');
      return (response.data as List).map((json) => RideModel.fromJson(json)).toList();
    } catch (error) {
      return _handleError(error);
    }
  }

  // EARNINGS ENDPOINTS

  // Get earnings summary for a date range
  Future<EarningsModel> getEarnings({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.get(
        '/drivers/earnings',
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );
      return EarningsModel.fromJson(response.data);
    } catch (error) {
      return _handleError(error);
    }
  }

  // Get weekly earnings summary
  Future<EarningsModel> getWeeklySummary() async {
    try {
      final response = await _dio.get('/drivers/earnings/weekly');
      return EarningsModel.fromJson(response.data);
    } catch (error) {
      return _handleError(error);
    }
  }

  // Get monthly earnings summary
  Future<EarningsModel> getMonthlySummary() async {
    try {
      final response = await _dio.get('/drivers/earnings/monthly');
      return EarningsModel.fromJson(response.data);
    } catch (error) {
      return _handleError(error);
    }
  }

  // Get ride history with pagination
  Future<List<EarningRide>> getRideHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/drivers/rides/history',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return (response.data as List).map((json) => EarningRide.fromJson(json)).toList();
    } catch (error) {
      return _handleError(error);
    }
  }

  // RATING ENDPOINTS

  // Get driver ratings
  Future<List<RatingModel>> getRatings({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/drivers/ratings',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return (response.data as List).map((json) => RatingModel.fromJson(json)).toList();
    } catch (error) {
      return _handleError(error);
    }
  }

  // Rate a rider
  Future<RatingModel> rateRider(
    String rideId,
    String riderId,
    int rating,
    String? comment,
  ) async {
    try {
      final response = await _dio.post(
        '/ratings',
        data: {
          'rideId': rideId,
          'riderId': riderId,
          'rating': rating,
          'comment': comment,
          'raterRole': 'driver',
        },
      );
      return RatingModel.fromJson(response.data);
    } catch (error) {
      return _handleError(error);
    }
  }

  // DOCUMENT ENDPOINTS

  // Upload driver document (ID, license, insurance, etc.)
  Future<String> uploadDocument(String documentType, dynamic file) async {
    try {
      final formData = FormData.fromMap({
        'documentType': documentType,
        'file': await MultipartFile.fromFile(file.path),
      });

      final response = await _dio.post(
        '/drivers/documents',
        data: formData,
      );

      return response.data['documentUrl'];
    } catch (error) {
      return _handleError(error);
    }
  }

  // Get driver documents
  Future<List<DocumentModel>> getDocuments() async {
    try {
      final response = await _dio.get('/drivers/documents');
      return (response.data as List).map((json) => DocumentModel.fromJson(json)).toList();
    } catch (error) {
      return _handleError(error);
    }
  }
}

// Rating model
class RatingModel {
  final String id;
  final String rideId;
  final String raterId;
  final String raterRole; // 'driver' or 'rider'
  final String ratedId;
  final String ratedRole; // 'driver' or 'rider'
  final int rating; // 1-5
  final String? comment;
  final DateTime createdAt;

  RatingModel({
    required this.id,
    required this.rideId,
    required this.raterId,
    required this.raterRole,
    required this.ratedId,
    required this.ratedRole,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['_id'] ?? json['id'] ?? '',
      rideId: json['rideId'] ?? '',
      raterId: json['raterId'] ?? '',
      raterRole: json['raterRole'] ?? '',
      ratedId: json['ratedId'] ?? '',
      ratedRole: json['ratedRole'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rideId': rideId,
      'raterId': raterId,
      'raterRole': raterRole,
      'ratedId': ratedId,
      'ratedRole': ratedRole,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// Document model
class DocumentModel {
  final String id;
  final String driverId;
  final String documentType; // 'license', 'insurance', 'id', etc.
  final String documentUrl;
  final String status; // 'pending', 'approved', 'rejected'
  final String? rejectionReason;
  final DateTime expiryDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  DocumentModel({
    required this.id,
    required this.driverId,
    required this.documentType,
    required this.documentUrl,
    required this.status,
    this.rejectionReason,
    required this.expiryDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['_id'] ?? json['id'] ?? '',
      driverId: json['driverId'] ?? '',
      documentType: json['documentType'] ?? '',
      documentUrl: json['documentUrl'] ?? '',
      status: json['status'] ?? 'pending',
      rejectionReason: json['rejectionReason'],
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : DateTime.now().add(const Duration(days: 365)),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'documentType': documentType,
      'documentUrl': documentUrl,
      'status': status,
      'rejectionReason': rejectionReason,
      'expiryDate': expiryDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
