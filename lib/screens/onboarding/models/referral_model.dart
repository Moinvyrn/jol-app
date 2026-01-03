class ReferralResponse {
  final bool success;
  final String? message;
  final dynamic data;

  ReferralResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ReferralResponse.fromJson(Map<String, dynamic> json) {
    return ReferralResponse(
      success: json['success'] ?? true,
      message: json['message'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }
}