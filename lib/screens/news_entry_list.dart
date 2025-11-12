import 'package:flutter/material.dart';
import 'package:football_news/models/news_entry.dart';
import 'package:football_news/widgets/left_drawer.dart';
import 'package:football_news/widgets/news_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:football_news/screens/news_detail.dart';

class NewsEntryListPage extends StatefulWidget {
  const NewsEntryListPage({super.key});

  @override
  State<NewsEntryListPage> createState() => _NewsEntryListPageState();
}

class _NewsEntryListPageState extends State<NewsEntryListPage> {
  // Pick ONE: localhost (Chrome) or 10.0.2.2 (Android emulator)
  static const String baseUrl = 'http://localhost:8000';
  // static const String baseUrl = 'http://10.0.2.2:8000';

  Future<List<NewsEntry>> fetchNews(CookieRequest request) async {
    final response = await request.get('$baseUrl/json/');

    final data = response;
    final List<NewsEntry> listNews = [];
    for (var d in data) {
      if (d != null) {
        listNews.add(NewsEntry.fromJson(d));
      }
    }
    return listNews;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<NewsEntry>>(
        future: fetchNews(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'There are no news in football news yet.',
                  style: TextStyle(fontSize: 18, color: Color(0xff59A5D8)),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) => NewsEntryCard(
              news: snapshot.data![index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailPage(
                      news: snapshot.data![index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
