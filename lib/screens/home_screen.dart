import 'package:flutter/material.dart';
import '../services/news_service.dart';
import '../models/article.dart';
import '../details/detail_news.dart'; // Import halaman detail

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // For BottomNavigationBar

  late Future<List<Article>> _futureArticles;

  @override
  void initState() {
    super.initState();
    _futureArticles = NewsService().fetchArticles();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        _futureArticles = NewsService().fetchArticles(); // Fetch Tesla news
      } else if (_selectedIndex == 1) {
        _futureArticles = NewsService().fetchFavorites(); // Fetch WSJ favorites
      }
    });
  }

  void _onArticleTap(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Article>>(
        future: _futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No articles found'));
          }

          final articles = snapshot.data!;

          return ListView.separated(
            itemCount: articles.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey[300]),
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                elevation: 4,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: article.urlToImage != null
                      ? FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: article.urlToImage!,
                          width: 100,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://akcdn.detik.net.id/visual/2018/09/18/0514dcdb-db9e-4864-9f72-00e23efbecff_11.png?w=720&q=90',
                              width: 100,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.network(
                          'https://akcdn.detik.net.id/visual/2018/09/18/0514dcdb-db9e-4864-9f72-00e23efbecff_11.png?w=720&q=90',
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                  title: Text(article.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article.description),
                      Text(article.formattedDate,
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  onTap: () =>
                      _onArticleTap(article), // Navigate to DetailScreen
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.electric_bolt),
            label: 'Tesla News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apple),
            label: 'Apple News',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
