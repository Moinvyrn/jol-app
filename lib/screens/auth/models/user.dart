// User Model - From /api/v1/user/detail/

import 'package:jol_app/screens/auth/models/user_wallet.dart';

class User {
  final int id;
  final String email;
  final String username;
  final String? firstName;
  final String? lastName;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
  });

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['pk'] ?? json['id'] ?? 0,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      // email and id are read-only, typically not sent in updates
    };
  }

  // CopyWith method
  User copyWith({
    int? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, '
        'firstName: $firstName, lastName: $lastName)';
  }
}

// UserProfile Model - From /api/v1/user/profile/
// NOTE: This does NOT contain User data - that comes from a separate endpoint
class UserProfile {
  final String? bio;
  final String? location;
  final DateTime? birthDate;
  final String? avatar;
  final String referralCode;
  final String referralLink;
  final int? referredBy;
  final int totalReferrals;
  final int availableGamePoints;

  UserProfile({
    this.bio,
    this.location,
    this.birthDate,
    this.avatar,
    required this.referralCode,
    required this.referralLink,
    this.referredBy,
    this.totalReferrals = 0,
    this.availableGamePoints = 0,
  });

  // Parse UserProfile from JSON - NO USER FIELD
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
      avatar: json['avatar'] as String?,
      referralCode: json['referral_code'] as String? ?? '',
      referralLink: json['referral_link'] as String? ?? '',
      referredBy: json['referred_by'] as int?,
      totalReferrals: json['total_referrals'] as int? ?? 0,
      availableGamePoints: json['available_game_points'] as int? ?? 0,
    );
  }

  // To JSON (for updates - only include editable fields)
  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'location': location,
      'birth_date': birthDate?.toIso8601String().split('T')[0],
      // avatar, referral_code, referral_link, total_referrals,
      // available_game_points are read-only
    };
  }

  // CopyWith method for easy updates
  UserProfile copyWith({
    String? bio,
    String? location,
    DateTime? birthDate,
    String? avatar,
    String? referralCode,
    String? referralLink,
    int? referredBy,
    int? totalReferrals,
    int? availableGamePoints,
  }) {
    return UserProfile(
      bio: bio ?? this.bio,
      location: location ?? this.location,
      birthDate: birthDate ?? this.birthDate,
      avatar: avatar ?? this.avatar,
      referralCode: referralCode ?? this.referralCode,
      referralLink: referralLink ?? this.referralLink,
      referredBy: referredBy ?? this.referredBy,
      totalReferrals: totalReferrals ?? this.totalReferrals,
      availableGamePoints: availableGamePoints ?? this.availableGamePoints,
    );
  }

  @override
  String toString() {
    return 'UserProfile(bio: $bio, location: $location, '
        'birthDate: $birthDate, avatar: $avatar, referralCode: $referralCode, '
        'referralLink: $referralLink, referredBy: $referredBy, '
        'totalReferrals: $totalReferrals, availableGamePoints: $availableGamePoints)';
  }
}