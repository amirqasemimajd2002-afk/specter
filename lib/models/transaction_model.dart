class TransactionModel {
  final String title;
  final String date;
  final int amount;
  final bool isDeposit;

  TransactionModel({
    required this.title,
    required this.date,
    required this.amount,
    required this.isDeposit,
  });

  // متد کمکی برای فرمت کردن عدد (جایگزین تابع داخل UI)
  String get formattedAmount {
    final value = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      buffer.write(value[i]);
      final remaining = value.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write(',');
      }
    }
    return buffer.toString();
  }

  // برای تبدیل داده‌های دیتابیس به مدل
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      title: json['title'],
      date: json['date'],
      amount: json['amount'],
      isDeposit: json['isDeposit'],
    );
  }
}
