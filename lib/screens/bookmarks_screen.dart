import 'package:flutter/material.dart';
import '../models/content_model.dart';
import 'manhua_detail_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  // لیست نشان‌ها (در آینده این داده‌ها از دیتابیس می‌آیند)
  final List<ContentModel> _bookmarkItems = [
    ContentModel(
      id: "1",
      title: "Solo Leveling",
      imageUrl: "https://via.placeholder.com/150",
      genres: ["اکشن"],
      type: "مانهوآ",
      lastChapter: "فصل ۱۷۹",
      rating: 4.8,
      reviewsCount: 1250,
      summary: "خلاصه داستان...",
      pricePerChapter: "۵۰۰۰",
    ),
    // آیتم‌های بیشتر برای تست...
  ];

  final TextEditingController _searchController = TextEditingController();
  List<ContentModel> _filteredBookmarks = [];

  @override
  void initState() {
    super.initState();
    _filteredBookmarks = _bookmarkItems;
  }

  void _filterBookmarks(String query) {
    setState(() {
      _filteredBookmarks = _bookmarkItems
          .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // --- تابع اصلی برای حذف ---
  void _removeItem(ContentModel item) {
    setState(() {
      _bookmarkItems.remove(item);
      _filterBookmarks(_searchController.text); // بروزرسانی لیست فیلتر شده
    });

    // نمایش یک پیام کوچک پایین صفحه (SnackBar)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("از نشانه‌ها حذف شد"),
        backgroundColor: const Color(0xFFD32F2F),
        action: SnackBarAction(
          label: "برگرداندن",
          textColor: Colors.white,
          onPressed: () {
            // در اینجا می‌توانید منطق Undo را پیاده کنید
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("نشان‌های من", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // باکس جستجو
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterBookmarks,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'جستجو در نشان‌ها...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFD32F2F)),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            if (_filteredBookmarks.isEmpty)
              const Expanded(
                child: Center(
                  child: Text("هیچ نشانه‌ای یافت نشد", style: TextStyle(color: Colors.white54)),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _filteredBookmarks.length,
                  itemBuilder: (context, index) {
                    final item = _filteredBookmarks[index];
                    
                    // استفاده از Dismissible برای قابلیت کشیدن به کنار و حذف
                    return Dismissible(
                      key: Key(item.id), // کلید یکتا برای هر آیتم
                      direction: DismissDirection.endToStart, // فقط از راست به چپ کشیده شود
                      onDismissed: (direction) => _removeItem(item),
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD32F2F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: _buildBookmarkCard(item),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkCard(ContentModel content) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManhuaDetailScreen(item: content),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD32F2F).withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  content.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        content.rating.toString(),
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
