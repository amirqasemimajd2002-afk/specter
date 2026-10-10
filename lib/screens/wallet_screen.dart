import 'package:flutter/material.dart';
import '../models/transaction_model.dart'; // وارد کردن مدل جدید

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  static const Color accentRed = Color(0xFFD32F2F);
  
  late Future<List<TransactionModel>> _transactionsFuture;
  int _balance = 0; // این هم بعداً از سرور می‌آید

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _fetchWalletData();
  }

  // شبیه‌سازی دریافت داده از سرور یا دیتابیس
  Future<List<TransactionModel>> _fetchWalletData() async {
    await Future.delayed(const Duration(seconds: 1)); // شبیه‌سازی تأخیر شبکه
    
    _balance = 250000; // مقدار موجودی هم از سرور می‌آید

    // این لیست در آینده مستقیماً از API می‌آید
    final List<Map<String, dynamic>> mockData = [
      {'title': 'شارژ کیف پول', 'date': '۱۴۰۴/۰۷/۱۲', 'amount': 100000, 'isDeposit': true},
      {'title': 'خرید اشتراک ویژه', 'date': '۱۴۰۴/۰۷/۱۰', 'amount': 45000, 'isDeposit': false},
      {'title': 'شارژ کیف پول', 'date': '۱۴۰۴/۰۷/۰۵', 'amount': 200000, 'isDeposit': true},
      {'title': 'خرید کتاب صوتی', 'date': '۱۴۰۴/۰۶/۲۸', 'amount': 30000, 'isDeposit': false},
    ];

    return mockData.map((json) => TransactionModel.fromJson(json)).toList();
  }

  void _onTopUp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('اتصال به درگاه پرداخت...'),
        backgroundColor: accentRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: const Text('کیف پول', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: FutureBuilder<List<TransactionModel>>(
          future: _transactionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: accentRed));
            }
            if (snapshot.hasError) {
              return const Center(child: Text('خطا در بارگذاری', style: TextStyle(color: Colors.white)));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('تراکنشی یافت نشد', style: TextStyle(color: Colors.white)));
            }

            final transactions = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBalanceCard(),
                  const SizedBox(height: 16),
                  _buildActionsRow(),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text('تراکنش‌های اخیر', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  // استفاده از مدل به جای Map
                  ...transactions.map((t) => _buildTransactionTile(t)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E1E), Color(0xFF2A2A2A)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentRed.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.account_balance_wallet, color: accentRed, size: 22),
              SizedBox(width: 8),
              Text('موجودی فعلی', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // استفاده از متد جدید داخل مدل
              Text(
                _formatNumberForBalance(_balance), 
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 6),
              const Text('تومان', style: TextStyle(color: Colors.white54, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  // این تابع فقط برای نمایش موجودی است که از مدل استفاده نمی‌کند چون عدد ساده است
  String _formatNumberForBalance(int amount) {
    final value = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      buffer.write(value[i]);
      final remaining = value.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buffer.write(',');
    }
    return buffer.toString();
  }

  Widget _buildActionsRow() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _onTopUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.add_card),
        label: const Text('افزایش اعتبار', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTransactionTile(TransactionModel transaction) {
    final bool isDeposit = transaction.isDeposit;
    final Color amountColor = isDeposit ? Colors.greenAccent : accentRed;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: amountColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isDeposit ? Icons.south_west : Icons.north_east,
              color: amountColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(transaction.date, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${isDeposit ? '+' : '-'}${transaction.formattedAmount}', // استفاده از property مدل
            style: TextStyle(color: amountColor, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
