import 'dart:async';
import 'package:flutter/material.dart';
import '../models/content_model.dart'; // مطمئن شو نام فایل و کلاس درست است
import 'bookmarks_screen.dart';
import 'explore_screen.dart';
import 'genres_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late final PageController _pageController;
  Timer? _timer;
  int _currentBannerIndex = 0;

  // لیست فرضی برای بنرها (در آینده از دیتابیس می‌آید)
  final List<String> _banners = [
    'https://via.placeholder.com/800x400/D32F2F/FFFFFF?text=New+Manga+Released',
    'https://via.placeholder.com/800x400/000000/D32F2F?text=Join+the+Community',
    'https://via.placeholder.com/800x400/D32F2F/FFFFFF?text=Top+Rated+This+Week',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    
    // شروع تایمر برای اسلایدر بنرها
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentBannerIndex < _banners.length - 1) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _DashboardBody(pageController: _pageController, banners: _banners),
            const BookmarksScreen(),
            const ExploreScreen(),
            const GenresScreen(),
            const ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD32F2F).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFD32F2F),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'خانه'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'نشان‌ها'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'کاوش'),
          BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'ژانرها'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'پروفایل'),
        ],
      ),
    );
  }
}

class _DashboardBody extends StatefulWidget {
  final PageController pageController;
  final List<String> banners;

  const _DashboardBody({required this.pageController, required this.banners});

  @override
  State<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<_DashboardBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بخش بنر اسلایدر
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: widget.pageController,
              itemCount: widget.banners.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(widget.banners[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),

          // بخش عنوان‌ها و لیست‌ها
          _buildSectionTitle('جدیدترین‌ها'),
          _buildHorizontalContentList(),

          _buildSectionTitle('محبوب‌ترین‌ها'),
          _buildHorizontalContentList(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // این متد جایگزین گرید قبلی شده و قابلیت اسکرول افقی دارد
  Widget _buildHorizontalContentList() {
    return FutureBuilder<List<ContentModel>>(
      future: _fetchMockData(), // در آینده این متد با API جایگزین می‌شود
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFD32F2F)));
        } else if (snapshot.hasError) {
          return const Center(child: Text('خطا در بارگذاری داده‌ها', style: TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('محتوایی یافت نشد', style: TextStyle(color: Colors.white)));
        }

        final items = snapshot.data!;
        return SizedBox(
          height: 240, // ارتفاع مشخص برای کارت‌ها
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 140, // عرض هر کارت
                child: _ContentCard(item: items[index]),
              );
            },
          ),
        );
      },
    );
  }

  // دیتای آزمایشی (Mock Data)
  Future<List<ContentModel>> _fetchMockData() async {
    await Future.delayed(const Duration(seconds: 1)); // شبیه‌سازی شبکه
    return List.generate(
      10,
      (index) => ContentModel(
        id: '$index',
        title: 'مانگا شماره $index',
        imageUrl: 'https://via.placeholder.com/150x200/121212/D32F2F?text=Manga+$index',
        genres: ['اکشن'],
        type: 'manga',
        lastChapter: 'فصل $index',
        rating: 4.5,
        reviewsCount: 120,
        summary: 'این یک خلاصه آزمایشی برای مانگا شماره $index است.',
        pricePerChapter: 'رایگان',

      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final ContentModel item;

  const _ContentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // عملیات کلیک روی کارت
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // تصویر کارت
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(item.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // عنوان کارت
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          // ژانر کارت
          Text(
            item.genres.join(', '),
            style: const TextStyle(
              color: Color(0xFFD32F2F),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
