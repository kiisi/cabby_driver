import 'package:cabby_driver/data/models/driver_model.dart';
import 'package:equatable/equatable.dart';
import 'ride_model.dart';

class EarningsModel extends Equatable {
  final double totalEarnings;
  final int totalRides;
  final double avgRideEarnings;
  final int totalHoursOnline;
  final int totalMinutesOnTrip;
  final List<DailyEarning> dailyEarnings;
  final DateTime startDate;
  final DateTime endDate;

  const EarningsModel({
    required this.totalEarnings,
    required this.totalRides,
    required this.avgRideEarnings,
    required this.totalHoursOnline,
    required this.totalMinutesOnTrip,
    required this.dailyEarnings,
    required this.startDate,
    required this.endDate,
  });

  // Formatted total earnings with currency symbol
  String get formattedTotalEarnings => '\$${totalEarnings.toStringAsFixed(2)}';

  // Formatted average earnings with currency symbol
  String get formattedAvgEarnings => '\$${avgRideEarnings.toStringAsFixed(2)}';

  // Calculate hourly rate
  double get hourlyRate {
    if (totalHoursOnline == 0) return 0;
    return totalEarnings / totalHoursOnline;
  }

  // Formatted hourly rate with currency symbol
  String get formattedHourlyRate => '\$${hourlyRate.toStringAsFixed(2)}';

  // Calculate trip time percentage
  double get tripTimePercentage {
    if (totalHoursOnline == 0) return 0;
    final totalMinutesOnline = totalHoursOnline * 60;
    return (totalMinutesOnTrip / totalMinutesOnline) * 100;
  }

  // Factory constructor to create EarningsModel from JSON
  factory EarningsModel.fromJson(Map<String, dynamic> json) {
    return EarningsModel(
      totalEarnings: (json['totalEarnings'] ?? 0.0).toDouble(),
      totalRides: json['totalRides'] ?? 0,
      avgRideEarnings: (json['avgRideEarnings'] ?? 0.0).toDouble(),
      totalHoursOnline: json['totalHoursOnline'] ?? 0,
      totalMinutesOnTrip: json['totalMinutesOnTrip'] ?? 0,
      dailyEarnings: json['dailyEarnings'] != null
          ? (json['dailyEarnings'] as List).map((e) => DailyEarning.fromJson(e)).toList()
          : [],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now().subtract(const Duration(days: 7)),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : DateTime.now(),
    );
  }

  // Convert EarningsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalEarnings': totalEarnings,
      'totalRides': totalRides,
      'avgRideEarnings': avgRideEarnings,
      'totalHoursOnline': totalHoursOnline,
      'totalMinutesOnTrip': totalMinutesOnTrip,
      'dailyEarnings': dailyEarnings.map((e) => e.toJson()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        totalEarnings,
        totalRides,
        avgRideEarnings,
        totalHoursOnline,
        totalMinutesOnTrip,
        dailyEarnings,
        startDate,
        endDate,
      ];
}

class DailyEarning extends Equatable {
  final DateTime date;
  final double earnings;
  final int rides;
  final int hoursOnline;
  final int minutesOnTrip;

  const DailyEarning({
    required this.date,
    required this.earnings,
    required this.rides,
    required this.hoursOnline,
    required this.minutesOnTrip,
  });

  // Formatted earnings with currency symbol
  String get formattedEarnings => '\$${earnings.toStringAsFixed(2)}';

  // Factory constructor to create DailyEarning from JSON
  factory DailyEarning.fromJson(Map<String, dynamic> json) {
    return DailyEarning(
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      earnings: (json['earnings'] ?? 0.0).toDouble(),
      rides: json['rides'] ?? 0,
      hoursOnline: json['hoursOnline'] ?? 0,
      minutesOnTrip: json['minutesOnTrip'] ?? 0,
    );
  }

  // Convert DailyEarning to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'earnings': earnings,
      'rides': rides,
      'hoursOnline': hoursOnline,
      'minutesOnTrip': minutesOnTrip,
    };
  }

  @override
  List<Object?> get props => [
        date,
        earnings,
        rides,
        hoursOnline,
        minutesOnTrip,
      ];
}

class EarningRide extends Equatable {
  final String id;
  final String riderId;
  final String driverId;
  final RiderUser? rider;
  final LocationPoint pickup;
  final LocationPoint destination;
  final double distance;
  final int duration;
  final double fare;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime completedAt;

  const EarningRide({
    required this.id,
    required this.riderId,
    required this.driverId,
    this.rider,
    required this.pickup,
    required this.destination,
    required this.distance,
    required this.duration,
    required this.fare,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    required this.completedAt,
  });

  // Formatted fare with currency symbol
  String get formattedFare => '\$${fare.toStringAsFixed(2)}';

  // Factory constructor to create EarningRide from JSON
  factory EarningRide.fromJson(Map<String, dynamic> json) {
    return EarningRide(
      id: json['_id'] ?? json['id'] ?? '',
      riderId: json['riderId'] ?? '',
      driverId: json['driverId'] ?? '',
      rider: json['rider'] != null ? RiderUser.fromJson(json['rider']) : null,
      pickup: LocationPoint.fromJson(json['pickup'] ?? {}),
      destination: LocationPoint.fromJson(json['destination'] ?? {}),
      distance: (json['distance'] ?? 0.0).toDouble(),
      duration: json['duration'] ?? 0,
      fare: (json['fare'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'completed',
      paymentMethod: json['paymentMethod'] ?? 'cash',
      paymentStatus: json['paymentStatus'] ?? 'paid',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : DateTime.now(),
    );
  }

  // Convert EarningRide to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'riderId': riderId,
      'driverId': driverId,
      'rider': rider?.toJson(),
      'pickup': pickup.toJson(),
      'destination': destination.toJson(),
      'distance': distance,
      'duration': duration,
      'fare': fare,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        riderId,
        driverId,
        rider,
        pickup,
        destination,
        distance,
        duration,
        fare,
        status,
        paymentMethod,
        paymentStatus,
        createdAt,
        completedAt,
      ];
}
