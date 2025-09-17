import 'package:equatable/equatable.dart';

class DriverModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? profilePicture;
  final String licenseNumber;
  final VehicleInfo vehicle;
  final bool isVerified;
  final bool isAvailable;
  final DriverLocation? currentLocation;
  final double averageRating;
  final int totalRides;
  final String status; // 'active', 'inactive', 'suspended'
  final List<String>? documents;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DriverModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.profilePicture,
    required this.licenseNumber,
    required this.vehicle,
    required this.isVerified,
    required this.isAvailable,
    this.currentLocation,
    required this.averageRating,
    required this.totalRides,
    required this.status,
    this.documents,
    required this.createdAt,
    required this.updatedAt,
  });

  // Full name getter
  String get fullName => '$firstName $lastName';

  // Factory constructor to create DriverModel from JSON
  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['_id'] ?? json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profilePicture: json['profilePicture'],
      licenseNumber: json['licenseNumber'] ?? '',
      vehicle: VehicleInfo.fromJson(json['vehicle'] ?? {}),
      isVerified: json['isVerified'] ?? false,
      isAvailable: json['isAvailable'] ?? false,
      currentLocation:
          json['currentLocation'] != null ? DriverLocation.fromJson(json['currentLocation']) : null,
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalRides: json['totalRides'] ?? 0,
      status: json['status'] ?? 'inactive',
      documents: json['documents'] != null ? List<String>.from(json['documents']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  // Convert DriverModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'licenseNumber': licenseNumber,
      'vehicle': vehicle.toJson(),
      'isVerified': isVerified,
      'isAvailable': isAvailable,
      'currentLocation': currentLocation?.toJson(),
      'averageRating': averageRating,
      'totalRides': totalRides,
      'status': status,
      'documents': documents,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of DriverModel with some changes
  DriverModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    String? licenseNumber,
    VehicleInfo? vehicle,
    bool? isVerified,
    bool? isAvailable,
    DriverLocation? currentLocation,
    double? averageRating,
    int? totalRides,
    String? status,
    List<String>? documents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DriverModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      vehicle: vehicle ?? this.vehicle,
      isVerified: isVerified ?? this.isVerified,
      isAvailable: isAvailable ?? this.isAvailable,
      currentLocation: currentLocation ?? this.currentLocation,
      averageRating: averageRating ?? this.averageRating,
      totalRides: totalRides ?? this.totalRides,
      status: status ?? this.status,
      documents: documents ?? this.documents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phoneNumber,
        profilePicture,
        licenseNumber,
        vehicle,
        isVerified,
        isAvailable,
        currentLocation,
        averageRating,
        totalRides,
        status,
        documents,
        createdAt,
        updatedAt,
      ];
}

class VehicleInfo extends Equatable {
  final String make;
  final String model;
  final String year;
  final String color;
  final String licensePlate;
  final String vehicleType; // 'economy', 'comfort', 'premium'
  final String? photo;

  const VehicleInfo({
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.licensePlate,
    required this.vehicleType,
    this.photo,
  });

  // Factory constructor to create VehicleInfo from JSON
  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? '',
      color: json['color'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      vehicleType: json['vehicleType'] ?? 'economy',
      photo: json['photo'],
    );
  }

  // Convert VehicleInfo to JSON
  Map<String, dynamic> toJson() {
    return {
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'licensePlate': licensePlate,
      'vehicleType': vehicleType,
      'photo': photo,
    };
  }

  // Get vehicle full name
  String get fullName => '$year $make $model';

  @override
  List<Object?> get props => [
        make,
        model,
        year,
        color,
        licensePlate,
        vehicleType,
        photo,
      ];
}

class DriverLocation extends Equatable {
  final String type; // 'Point'
  final List<double> coordinates; // [longitude, latitude]
  final DateTime timestamp;

  const DriverLocation({
    required this.type,
    required this.coordinates,
    required this.timestamp,
  });

  // Get latitude
  double get latitude => coordinates[1];

  // Get longitude
  double get longitude => coordinates[0];

  // Factory constructor to create DriverLocation from JSON
  factory DriverLocation.fromJson(Map<String, dynamic> json) {
    return DriverLocation(
      type: json['type'] ?? 'Point',
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
          : [0.0, 0.0],
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
    );
  }

  // Convert DriverLocation to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [type, coordinates, timestamp];
}

class RiderUser extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? profilePicture;
  final double avgRating;
  final int tripCount;
  final String? notes;

  const RiderUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.profilePicture,
    required this.avgRating,
    required this.tripCount,
    this.notes,
  });

  // Full name getter
  String get fullName => '$firstName $lastName';

  // Factory constructor to create RiderUser from JSON
  factory RiderUser.fromJson(Map<String, dynamic> json) {
    return RiderUser(
      id: json['_id'] ?? json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profilePicture: json['profilePicture'],
      avgRating: (json['avgRating'] ?? 0.0).toDouble(),
      tripCount: json['tripCount'] ?? 0,
      notes: json['notes'],
    );
  }

  // Convert RiderUser to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'avgRating': avgRating,
      'tripCount': tripCount,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phoneNumber,
        profilePicture,
        avgRating,
        tripCount,
        notes,
      ];
}
