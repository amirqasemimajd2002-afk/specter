import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // اضافه شد برای پشتیبانی از فارسی
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const SpecterApp());
}

class SpecterApp extends StatelessWidget {
  const SpecterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Specter',
      debugShowCheckedModeBanner: false,

      // --- تنظیمات زبان و جهت متن (RTL) ---
      // این بخش باعث می‌شود اپلیکیشن با زبان فارسی هماهنگ شود
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', 'IR'), // فارسی
        Locale('en', 'US'), // انگلیسی
      ],
      locale: const Locale('fa', 'IR'), // پیش‌فرض اپلیکیشن را روی فارسی می‌گذاریم

      // --- Global App Theme Configuration ---
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        
        // رنگ پس‌زمینه اصلی
        scaffoldBackgroundColor: Colors.black,
        
        // تعریف تم اصلی بر پایه رنگ قرمز اختصاصی شما
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD32F2F),
          brightness: Brightness.dark,
          primary: const Color(0xFFD32F2F),
          surface: const Color(0xFF121212), // کمی روشن‌تر از سیاه مطلق برای کارت‌ها
        ),
        
        // تنظیمات AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true, // برای زیبایی بیشتر در حالت فارسی
        ),
        
        // تنظیمات دکمه‌ها
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD32F2F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        
        // تنظیمات فونت و متن
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      
      home: const DashboardScreen(),
    );
  }
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // بارگذاری کلیدهای امن
  await SupabaseService.init();
  runApp(const MyApp());
}
