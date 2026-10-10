import 'package:flutter/material.dart';
import 'package:specter/screens/wallet_screen.dart'; // مطمئن شو این فایل دقیقاً در این مسیر وجود دارد
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchProfileData();
  }

  Future<UserProfile> _fetchProfileData() async {
    await Future.delayed(const Duration(seconds: 1));
    return UserProfile(
      username: 'کاربر اسپکتر',
      email: 'specter.user@gmail.com',
      balance: '۱۲۵,۰۰۰ تومان',
      coins: '۱,۴۲۰',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<UserProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFD32F2F)));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("خطا در دریافت اطلاعات", style: TextStyle(color: Colors.white)));
          }
          
          final user = snapshot.data!;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 140.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildProfileHeader(user),
                  const SizedBox(height: 30),
                  _buildWalletSection(user, context),
                  const SizedBox(height: 20),
                  _buildSpecterPlusCard(), // حالا تعریف شده است
                  const SizedBox(height: 30),
                  _buildMenuSection(context), // حالا تعریف شده است
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- بخش‌های UI ---

  Widget _buildProfileHeader(UserProfile user) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle, 
            border: Border.all(color: const Color(0xFFD32F2F), width: 3), 
            color: Colors.grey[900]
          ),
          child: const Icon(Icons.person, color: Color(0xFFD32F2F), size: 50),
        ),
        const SizedBox(height: 20),
        Text(user.username, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(user.email, style: const TextStyle(color: Colors.grey, fontSize: 15)),
      ],
    );
  }

  Widget _buildWalletSection(UserProfile user, BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildWalletCard(icon: Icons.account_balance_wallet, title: 'موجودی', value: user.balance, onTap: () => _goToWallet(context))),
        const SizedBox(width: 15),
        Expanded(child: _buildWalletCard(icon: Icons.monetization_on, title: 'سکه‌ها', value: user.coins, onTap: () {})),
      ],
    );
  }

  Widget _buildWalletCard({required IconData icon, required String title, required String value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[850]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFD32F2F)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecterPlusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFD32F2F), Color(0xFF8B0000)]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        children: [
          Text("Specter Plus", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("دسترسی نامحدود به تمام محتواها", style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(Icons.settings, "تنظیمات"),
        _buildMenuItem(Icons.help_outline, "راهنما"),
        _buildMenuItem(Icons.logout, "خروج"),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: () {},
    );
  }

  void _goToWallet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WalletScreen()),
    );
  }
}
