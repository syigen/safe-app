import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_app/pages/add_news_form.dart';
import '../model/news_data.dart';
import '../widgets/CustomScroll.dart';
import '../widgets/news_card.dart';
import '../services/news_service.dart';

class NewsListView extends ConsumerStatefulWidget {
  @override
  _NewsListViewState createState() => _NewsListViewState();

}

class _NewsListViewState extends ConsumerState<NewsListView> {
  final NewsService _newsService = NewsService();
  List<News> _newsList = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newsData = await _newsService.getAllNews();
      setState(() {
        _newsList = newsData.map((item) => News(
          id: item['id'],
          title: item['title'],
          description: item['description'],
          imageUrl: item['image_url'],
          createdAt: DateTime.parse(item['created_at']),
        )).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading news: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<News> get _filteredNews {
    if (_searchQuery.isEmpty) return _newsList;
    return _newsList.where((news) =>
    news.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        news.description.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021B1A),
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        color: const Color(0xFF00DF81),
        backgroundColor: const Color(0xFF032221),
        onRefresh: _fetchNews,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildSearchBar(context),
              const SizedBox(height: 16),
              const Divider(
                color: Color(0xFF00DF81),
                height: 1,
                thickness: 1,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? _buildLoadingIndicator()
                    : _newsList.isEmpty
                    ? _buildEmptyState()
                    : _buildNewsList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF00DF81),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 80,
            color: const Color(0xFF00DF81).withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No news available',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a new article with the + button',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF06302B),
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF03624C)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      title: const Text(
        'NEWS LIST',
        style: TextStyle(
          color: Color(0xFFF1F7F6),
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),

    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double searchBarHeight = screenWidth < 600 ? 48.0 : 56.0;
    final double fontSize = screenWidth < 600 ? 14.0 : 16.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth < 600 ? 16.0 : 24.0),
      child: Container(
        height: searchBarHeight,
        decoration: BoxDecoration(
          color: const Color(0xFF03624C),
          borderRadius: BorderRadius.circular(searchBarHeight / 2),
          border: Border.all(color: const Color(0xFF00DF81)),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: 'Search news',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: fontSize),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF00DF81)),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear, color: Color(0xFF00DF81)),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
            )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    final newsToShow = _filteredNews;

    if (newsToShow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: const Color(0xFF00DF81).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double horizontalPadding = constraints.maxWidth < 600 ? 8.0 : 20.0;

        return ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: ListView.builder(
            itemCount: newsToShow.length,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemBuilder: (context, index) {
              return NewsCard(
                news: newsToShow[index],
                index: index + 1,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF00DF81), width: 5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF94).withOpacity(0.6),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: FloatingActionButton(
        backgroundColor: const Color(0xFF032221),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Color(0xFF00DF81),
          size: 40,
          weight: 900,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewsForm(),
            ),
          );
        },
      ),
    );
  }
}
