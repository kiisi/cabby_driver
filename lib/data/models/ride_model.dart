import 'package:equatable/equatable.dart';
import 'driver_model.dart';

class RideModel extends Equatable {
  final String id;
  final String riderId;
  final String? driverId;
  final RiderUser? rider;
  final DriverModel? driver;
  final LocationPoint pickup;
  final LocationPoint destination;
  final double estimatedDistance;
  final int estimatedDuration;
  final double fare;
  final String status; // 'pending', 'accepted', 'arrived', 'in_progress', 'completed', 'cancelled'
  final String paymentMethod; // 'cash', 'card'
  final String paymentStatus; // 'pending', 'paid', 'failed'
  final String? cancellationReason;
  final List<RideMessage>? messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RideModel({
    required this.id,
    required this.riderId,
    this.driverId,
    this.rider,
    this.driver,
    required this.pickup,
    required this.destination,
    required this.estimatedDistance,
    required this.estimatedDuration,
    required this.fare,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    this.cancellationReason,
    this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  // Formatted fare with currency symbol
  String get formattedFare => '\$${fare.toStringAsFixed(2)}';

  // Factory constructor to create RideModel from JSON
  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['_id'] ?? json['id'] ?? '',
      riderId: json['riderId'] ?? '',
      driverId: json['driverId'],
      rider: json['rider'] != null ? RiderUser.fromJson(json['rider']) : null,
      driver: json['driver'] != null ? DriverModel.fromJson(json['driver']) : null,
      pickup: LocationPoint.fromJson(json['pickup'] ?? {}),
      destination: LocationPoint.fromJson(json['destination'] ?? {}),
      estimatedDistance: (json['estimatedDistance'] ?? 0.0).toDouble(),
      estimatedDuration: json['estimatedDuration'] ?? 0,
      fare: (json['fare'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? 'cash',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      cancellationReason: json['cancellationReason'],
      messages: json['messages'] != null
          ? (json['messages'] as List).map((m) => RideMessage.fromJson(m)).toList()
          : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  // Convert RideModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'riderId': riderId,
      'driverId': driverId,
      'rider': rider?.toJson(),
      'driver': driver?.toJson(),
      'pickup': pickup.toJson(),
      'destination': destination.toJson(),
      'estimatedDistance': estimatedDistance,
      'estimatedDuration': estimatedDuration,
      'fare': fare,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'cancellationReason': cancellationReason,
      'messages': messages?.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of RideModel with some changes
  RideModel copyWith({
    String? id,
    String? riderId,
    String? driverId,
    RiderUser? rider,
    DriverModel? driver,
    LocationPoint? pickup,
    LocationPoint? destination,
    double? estimatedDistance,
    int? estimatedDuration,
    double? fare,
    String? status,
    String? paymentMethod,
    String? paymentStatus,
    String? cancellationReason,
    List<RideMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RideModel(
      id: id ?? this.id,
      riderId: riderId ?? this.riderId,
      driverId: driverId ?? this.driverId,
      rider: rider ?? this.rider,
      driver: driver ?? this.driver,
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      estimatedDistance: estimatedDistance ?? this.estimatedDistance,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      fare: fare ?? this.fare,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        riderId,
        driverId,
        rider,
        driver,
        pickup,
        destination,
        estimatedDistance,
        estimatedDuration,
        fare,
        status,
        paymentMethod,
        paymentStatus,
        cancellationReason,
        messages,
        createdAt,
        updatedAt,
      ];
}

class LocationPoint extends Equatable {
  final String address;
  final GeoLocation location;

  const LocationPoint({
    required this.address,
    required this.location,
  });

  // Factory constructor to create LocationPoint from JSON
  factory LocationPoint.fromJson(Map<String, dynamic> json) {
    return LocationPoint(
      address: json['address'] ?? '',
      location: GeoLocation.fromJson(json['location'] ?? {}),
    );
  }

  // Convert LocationPoint to JSON
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'location': location.toJson(),
    };
  }

  @override
  List<Object?> get props => [address, location];
}

class GeoLocation extends Equatable {
  final double latitude;
  final double longitude;

  const GeoLocation({
    required this.latitude,
    required this.longitude,
  });

  // Factory constructor to create GeoLocation from JSON
  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  // Convert GeoLocation to JSON
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  List<Object?> get props => [latitude, longitude];
}

class RideMessage extends Equatable {
  final String senderId;
  final String senderRole; // 'driver' or 'rider'
  final String message;
  final DateTime timestamp;

  const RideMessage({
    required this.senderId,
    required this.senderRole,
    required this.message,
    required this.timestamp,
  });

  // Factory constructor to create RideMessage from JSON
  factory RideMessage.fromJson(Map<String, dynamic> json) {
    return RideMessage(
      senderId: json['senderId'] ?? '',
      senderRole: json['senderRole'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
    );
  }

  // Convert RideMessage to JSON
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderRole': senderRole,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [senderId, senderRole, message, timestamp];
}
