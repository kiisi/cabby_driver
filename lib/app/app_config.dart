import 'package:flutter/material.dart';

class AppConfig {
  // App information
  static const String appName = 'Cabby Driver';
  static const String appVersion = '1.0.0';

  // API configuration
  static const String apiUrl = 'http://localhost:5000/api';
  static const String socketUrl = 'http://localhost:5000';

  // UI configuration
  static const Color primaryColor = Color(0xFF1E88E5); // Blue
  static const Color accentColor = Color(0xFFFFA000); // Amber
  static const Color onlineColor = Color(0xFF4CAF50); // Green
  static const Color offlineColor = Color(0xFF9E9E9E); // Grey
  static const double screenPadding = 16.0;
  static const double cardBorderRadius = 12.0;

  // Map configuration
  static const double defaultZoom = 15.0;
  static const double navigationZoom = 17.0;

  // Location update configuration
  static const Duration locationUpdateInterval = Duration(seconds: 15);

  // Driver settings
  static const double maxDriverSearchRadius = 5.0; // kilometers
  static const Duration rideRequestTimeout = Duration(seconds: 30);

  // Payment methods supported
  static const List<String> paymentMethods = ['cash', 'card'];

  // Vehicle types
  static const Map<String, String> vehicleTypes = {
    'economy': 'Economy',
    'comfort': 'Comfort',
    'premium': 'Premium',
  };

  // Ride status codes
  static const String rideStatusPending = 'pending';
  static const String rideStatusAccepted = 'accepted';
  static const String rideStatusArrived = 'arrived';
  static const String rideStatusInProgress = 'in_progress';
  static const String rideStatusCompleted = 'completed';
  static const String rideStatusCancelled = 'cancelled';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String onlineStatusKey = 'online_status';

  // Error messages
  static const String networkErrorMessage = 'Network error. Please check your connection and try again.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String authErrorMessage = 'Authentication error. Please log in again.';

  // Success messages
  static const String loginSuccessMessage = 'Login successful!';
  static const String registerSuccessMessage = 'Registration successful!';
  static const String rideCompletedMessage = 'Ride completed successfully!';

  // Feature flags
  static const bool enableChat = true;
  static const bool enableDocumentUpload = true;
  static const bool enableInAppNotifications = true;
}
