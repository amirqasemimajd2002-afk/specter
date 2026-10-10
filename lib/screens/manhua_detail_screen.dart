import 'package:flutter/material.dart';
import '../models/content_model.dart'; 

class ManhuaDetailScreen extends StatelessWidget {
  final ContentModel item; // استفاده از مدل جدید

  const ManhuaDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // --- AppBar با افکت کشش تصویر ---
          SliverAppBar(
            expandedHeight: 350.0,
            pinned: true,
            backgroundColor: Colors.black,
            elevation: 0,
            iconTheme: const IconThemeData(color: Color(0xFFD32F2F)),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // نمایش تصویر اصلی
                  Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[900],
                      child: const Icon(Icons.broken_image, color: Colors.white12, size: 100),
                    ),
                  ),
                  // لایه گرادینت برای خوانایی بهتر متن و آیکون‌ها
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- محتوای اصلی صفحه ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  // بخش عنوان و امتیاز
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${item.rating} از ${item.reviewsCount} کاربر',
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.star, color: Colors.amber, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _buildIconButton(Icons.bookmark_border, () {}),
                      const SizedBox(width: 10),
                      _buildIconButton(Icons.notifications_none, () {}),
                    ],
                  ),

                  const SizedBox(height: 25),
                  
                  // باکس اطلاعات (نوع، ژانر و قیمت)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD32F2F).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD32F2F).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFD32F2F)),
                                ),
                                child: Text(
                                  item.type, // استفاده از نوع از مدل
                                  style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 12),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: item.genres.map((genre) => _buildGenreChip(genre)).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              children: [
                                const Text('قیمت هر چپتر', style: TextStyle(color: Colors.grey, fontSize: 10)),
                                const SizedBox(height: 4),
                                Text('${item.pricePerChapter} تومان', 
                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // بخش خلاصه داستان
                  const Text('خلاصه داستان', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.summary,
                      style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // دکمه‌های پایین صفحه
                  Row(
                    children: [
                      Expanded(child: _buildBottomActionBtn(icon: Icons.description_outlined, label: 'توضیحات', isActive: true, onTap: () {})),
                      const SizedBox(width: 8),
                      Expanded(child: _buildBottomActionBtn(icon: Icons.list_alt, label: 'چپترها', isActive: false, onTap: () {})),
                      const SizedBox(width: 8),
                      Expanded(child: _buildBottomActionBtn(icon: Icons.favorite_border, label: 'مورد علاقه', isActive: false, onTap: () {})),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- ویجت‌های کمکی (Helper Widgets) ---

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD32F2F).withValues(alpha: 0.4)),
        ),
        child: Icon(icon, color: const Color(0xFFD32F2F), size: 22),
      ),
    );
  }

  Widget _buildGenreChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label, 
        style: const TextStyle(color: Colors.white70, fontSize: 11)
      ),
    );
  }

  Widget _buildBottomActionBtn({required IconData icon, required String label, required bool isActive, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFD32F2F) : Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? const Color(0xFFD32F2F) : Colors.white10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 4),
            Text(
              label, 
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
