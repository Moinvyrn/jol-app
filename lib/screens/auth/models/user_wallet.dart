class UserWallet {
  final int totalCoins;
  final int usedCoins;
  final int availableCoins;

  UserWallet({
    required this.totalCoins,
    required this.usedCoins,
    required this.availableCoins,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) {
    return UserWallet(
      totalCoins: json['total_coins'] ?? 0,
      usedCoins: json['used_coins'] ?? 0,
      availableCoins: json['available_coins'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_coins': totalCoins,
      'used_coins': usedCoins,
      'available_coins': availableCoins,
    };
  }
}