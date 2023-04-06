import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/src/models/category_model.dart';

import 'package:news_app/src/models/news_models.dart';

const _URL_NEWS = 'newsapi.org';
const _API_KEY = '6d7f0f25b5c943c28554a436504587cb';

class NewsService extends ChangeNotifier {
  List<Article> headlines = [];
  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyball, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];
  String _selectedCategory = 'business';
  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadlines();
    categories.forEach((item) {
      this.categoryArticles[item.name] = [];
    });
    this.getArticlesByCategory(_selectedCategory);
  }

  String get selectedCategory => _selectedCategory;

  set selectedCategory(value) {
    this._selectedCategory = value;
    getArticlesByCategory(value);
    notifyListeners();
  }

  List<Article> get getArticulosCategoriaSeleccionada => categoryArticles[_selectedCategory]!;

  getTopHeadlines() async {
    final path = '/v2/top-headlines';
    final resp = await http.get(Uri.https(_URL_NEWS, path, {
      'country': 'us',
      'apiKey': _API_KEY,
    }));

    final newsResponse = newsResponseFromJson(resp.body);
    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    if (categoryArticles[category]!.length > 0) {
      return categoryArticles[category];
    }

    final path = '/v2/top-headlines';
    final resp = await http.get(Uri.https(_URL_NEWS, path, {
      'country': 'us',
      'apiKey': _API_KEY,
      'category': category,
    }));

    final newsResponse = newsResponseFromJson(resp.body);
    print(newsResponse.articles);
    categoryArticles[category]!.addAll(newsResponse.articles);
    notifyListeners();
  }
}
