import 'package:flutter/material.dart';
import 'explore_screen.dart';

class Genre {
  final String name;
  final IconData icon;

  Genre(this.name, this.icon);
}

class GenresScreen extends StatefulWidget {
  const GenresScreen({super.key});

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  // لیست ژانرها
  final List<Genre> _genres = [
    Genre("اکشن", Icons.bolt),
    Genre("درام", Icons.theater_comedy),
    Genre("فانتزی", Icons.auto_awesome),
    Genre("کمدی", Icons.emoji_emotions),
    Genre("ترسناک", Icons.nightlight),
    Genre("عاشقانه", Icons.favorite),
    Genre("علمی-تخیلی", Icons.rocket_launch),
    Genre("ورزشی", Icons.sports_soccer),
    Genre("معمایی", Icons.search),
    Genre("تاریخی", Icons.history_edu),
    Genre("روانشناسی", Icons.psychology),
    Genre("ماجراجویی", Icons.explore),
    Genre("هنرهای رزمی", Icons.sports_martial_arts),
    Genre("آشپزی", Icons.restaurant),
    Genre("ابرقهرمانی", Icons.shield),
    Genre("جادویی", Icons.auto_fix_high),
    Genre("آخرالزمانی", Icons.warning_amber_rounded),
    Genre("بازی ویدیویی", Icons.sports_esports),
    Genre("دخترانه", Icons.female),
    Genre("شیطانی", Icons.whatshot),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "ژانرها",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(), // اسکرول نرم‌تر
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75, // کمی بلندتر برای جلوگیری از تداخل متن
          ),
          itemCount: _genres.length,
          itemBuilder: (context, index) {
            final genre = _genres[index];

            return _GenreCard(
              genre: genre,
              onTap: () {
                // انتقال به صفحه اکسپلور با ژانر انتخاب شده
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExploreScreen(initialGenre: genre.name),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// جدا کردن کارت برای تمیزی بیشتر کد و مدیریت انیمیشن
class _GenreCard extends StatelessWidget {
  final Genre genre;
  final VoidCallback onTap;

  const _GenreCard({required this.genre, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.grey[900], // رنگ پس‌زمینه ثابت (چون در اینجا انتخاب لحظه‌ای نداریم)
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // آیکون با رنگ قرمز برای هماهنگی با تم Specter
            Icon(genre.icon, color: const Color(0xFFD32F2F), size: 28),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                genre.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
