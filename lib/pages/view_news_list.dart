/*
 * Copyright 2024-Present, Syigen Ltd. and Syigen Private Limited. All rights reserved.
 *
 */
import 'package:flutter/material.dart';
import 'package:safe_app/pages/add_news_form.dart';
import '../model/news.dart';
import '../widgets/news_card.dart';

class NewsListView extends StatelessWidget {
  NewsListView({super.key});

  final List<News> dummyNews = [
    News(
      title: 'hello',
      description: '',
      image: null,
    ),
    News(
      title: 'Elephants Die After Contact with Electric Fences',
      description: '',
      image: null,
    ),
    News(
      title: 'Initiatives to Mitigate Human-Elephant Conflict',
      description: '',
      image: null,
    ),
    News(
      title: 'Initiatives to Mitigate Human-Elephant Conflict',
      description: '',
      image: null,
    ),
    News(
      title: 'Initiatives to Mitigate Human-Elephant Conflict',
      description: '',
      image: null,
    ),
    News(
      title: 'Initiatives to Mitigate Human-Elephant Conflict',
      description: '',
      image: null,
    ),
    News(
      title: 'Initiatives to Mitigate Human-Elephant Conflict',
      description: '',
      image: null,
    ),
    News(
      title: 'Initiatives to Mitigate Human-Elephant Conflict',
      description: '',
      image: null,
    ),
    News(
      title: 'Initiatives to Mitigate Human-Elephant Conflict',
      description: '',
      image: null,
    ),
    News(
      title: 'Initiatives to Mitigate Human-Elephant Conflict',
      description: '',
      image: null,
    ),
    News(
      title: 'Initiatives to Mitigate Human-Elephant Conflict',
      description: '',
      image: null,
    ),

  ];

  @override
  Widget build(BuildContext context) {
    // Get screen width using MediaQuery for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF021B1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF06302B), // Background color for the button
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF03624C),
              ),
              iconSize: 28,
            ),
          ),
        ),
        title: _buildSearchBar(screenWidth), // Pass screenWidth for responsive search bar
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Divider(color: Color(0xFF00DF81), height: 1),
              const SizedBox(height: 16),
              _buildNewsList(),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF00DF81), // Border color
            width: 5, // Border thickness
          ),
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
          child: Icon(
            Icons.add,
            color: const Color(0xFF00DF81),
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
      ),
    );
  }

  Widget _buildSearchBar(double screenWidth) {
    return Container(
      width: screenWidth * 0.7,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF03624C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF00DF81)),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'search news',
          hintStyle: TextStyle(color: const Color(0xFF7C7C7C).withOpacity(0.7)),
          suffixIcon: const Icon(Icons.search, color: Color(0xFF00DF81)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return Expanded(
      child: dummyNews.isEmpty
          ? Center(
        child: Text(
          'No news available',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      )
          : ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: ListView.builder(
          itemCount: dummyNews.length,
          itemBuilder: (context, index) {
            return NewsCard(
              index: index + 1,
              news: dummyNews[index],
            );
          },
        ),
      ),
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return RawScrollbar(
      controller: details.controller,
      thumbColor: const Color(0xFF00DF81),
      radius: const Radius.circular(20),
      thickness: 10,
      child: child,
    );
  }
}
