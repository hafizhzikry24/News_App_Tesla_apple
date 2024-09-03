import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  final String _apiKey = 'b5e346a75eb2484c990e563972ca8379';

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/everything?q=tesla&from=2024-08-03&sortBy=publishedAt&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Article> articles = (data['articles'] as List)
          .map((article) => Article.fromJson(article))
          .toList();
      return articles;
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<List<Article>> fetchFavorites() async {
    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/everything?q=apple&from=2024-09-02&to=2024-09-02&sortBy=popularity&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Article> articles = (data['articles'] as List)
          .map((article) => Article.fromJson(article))
          .toList();
      return articles;
    } else {
      throw Exception('Failed to load favorite articles');
    }
  }
}
