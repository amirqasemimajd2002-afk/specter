import 'package:flutter/material.dart';
import '../models/content_model.dart'; 
import 'manhua_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  final String? initialGenre;
  final FocusNode? focusNode;

  const ExploreScreen({super.key, this.initialGenre, this.focusNode});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // 1. اصلاح داده‌های شبیه‌سازی شده (مطابق با فیلدهای جدید مدل)
  final List<ContentModel> _allContents = [
    ContentModel(
      id: "1",
      title: "Solo Leveling",
      imageUrl: "https://via.placeholder.com/150",
      genres: ["اکشن", "فانتزی"],
      type: "مانهوآ",
      lastChapter: "فصل ۱۷۹",
      rating: 4.8,
      reviewsCount: 1250,
      summary: "یک شکارچی ضعیف به قدرتمندترین شکارچی جهان تبدیل می‌شود...",
      pricePerChapter: "۵۰۰۰",
    ),
    ContentModel(
      id: "2",
      title: "One Piece",
      imageUrl: "https://via.placeholder.com/150",
      genres: ["ماجراجویی", "اکشن"],
      type: "مانگا",
      lastChapter: "فصل ۱۱۰۰",
      rating: 4.9,
      reviewsCount: 5000,
      summary: "داستان دزدان دریایی که به دنبال گنج افسانه‌ای هستند...",
      pricePerChapter: "۳۰۰۰",
    ),
  ];

  List<ContentModel> _filteredContents = [];
  final List<String> allGenres = ["اکشن", "درام", "فانتزی", "کمدی", "ماجراجویی", "عاشقانه"];
  final List<String> typeOptions = ["همه", "مانگا", "مانهوآ", "مانها", "رمان"];
  
  String selectedType = "همه";
  final Set<String> selectedGenres = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialGenre != null) selectedGenres.add(widget.initialGenre!);
    _filteredContents = _allContents;
  }

  void _applyFilters() {
    setState(() {
      _filteredContents = _allContents.where((content) {
        final matchesType = selectedType == "همه" || content.type == selectedType;
        final matchesGenre = selectedGenres.isEmpty || content.genres.any((g) => selectedGenres.contains(g));
        final matchesSearch = _searchController.text.isEmpty || content.title.toLowerCase().contains(_searchController.text.toLowerCase());
        return matchesType && matchesGenre && matchesSearch;
      }).toList();
    });
  }

  // 2. پیاده‌سازی متدهای Modal
  void _showTypeSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => ListView(
          padding: const EdgeInsets.all(16),
          children: typeOptions.map((type) => RadioListTile<String>(
            title: Text(type, style: const TextStyle(color: Colors.white)),
            value: type,
            groupValue: selectedType,
            onChanged: (val) {
              setModalState(() => selectedType = val!);
              setState(() => selectedType = val!);
              _applyFilters();
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showGenreSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => ListView(
          padding: const EdgeInsets.all(16),
          children: allGenres.map((genre) => CheckboxListTile(
            title: Text(genre, style: const TextStyle(color: Colors.white)),
            value: selectedGenres.contains(genre),
            onChanged: (val) {
              setModalState(() => val! ? selectedGenres.add(genre) : selectedGenres.remove(genre));
              setState(() {});
              _applyFilters();
            },
          )).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildSearchBar(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFilterChip(label: "نوع: $selectedType", onTap: _showTypeSelection),
                  _buildFilterChip(label: selectedGenres.isEmpty ? "ژانر: همه" : "ژانر: ${selectedGenres.length} انتخاب شده", onTap: _showGenreSelection),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _filteredContents.isEmpty
                    ? const Center(child: Text("یافت نشد", style: TextStyle(color: Colors.white54)))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.55,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: _filteredContents.length,
                        itemBuilder: (context, index) => _buildMangaCard(_filteredContents[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: _searchController,
        focusNode: widget.focusNode,
        textAlign: TextAlign.right,
        onChanged: (_) => _applyFilters(),
        decoration: const InputDecoration(
          hintText: "... جستجو",
          hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildFilterChip({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFD32F2F).withValues(alpha: 0.2),
          border: Border.all(color: const Color(0xFFD32F2F)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(children: [Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)), const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16)]),
      ),
    );
  }

  // 3. اصلاح ویجت کارت (و کامل کردن کد ناقص انتهای آن)
  Widget _buildMangaCard(ContentModel content) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(context, MaterialPageRoute(builder: (context) => ManhuaDetailScreen(item: content)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(image: NetworkImage(content.imageUrl), fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(content.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
          Text(content.genres.join(" • "), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 10), textAlign: TextAlign.right),
          Text(content.lastChapter, style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
