class UserData {
  final String fullName;
  final String avatarUrl;

  UserData({
    required this.fullName,
    required this.avatarUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      fullName: json['fullName'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'avatarUrl': avatarUrl,
    };
  }
}