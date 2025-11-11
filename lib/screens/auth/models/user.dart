import 'package:jol_app/screens/auth/models/user_wallet.dart';

class User {
  final int id;
  final String email;
  final String username;
  final String? firstName;  // Optional, as per schema
  final String? lastName;   // Optional
  final UserWallet wallet;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    required this.wallet,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      wallet: UserWallet.fromJson(json['wallet'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'wallet': wallet.toJson(),
    };
  }
}