class UserProfile {
  final String username;
  final String email;
  final String balance;
  final String coins;

  UserProfile({
    required this.username,
    required this.email,
    required this.balance,
    required this.coins,
  });

  // متد برای تبدیل داده‌های JSON دیتابیس به آبجکت
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'] ?? 'کاربر اسپکتر',
      email: json['email'] ?? 'specter.user@gmail.com',
      balance: json['balance'] ?? '۰ تومان',
      coins: json['coins'] ?? '۰',
    );
  }
}
