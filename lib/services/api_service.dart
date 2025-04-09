import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/show.dart';

class ApiService {
  static const _base = 'https://www.episodate.com/api';

  Future<List<TVShow>> fetchPopularShows(int page) async {
    final url = Uri.parse('$_base/most-popular?page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['tv_shows'] as List)
          .map((show) => TVShow.fromJson(show))
          .toList();
    } else {
      throw Exception('Failed to load popular shows');
    }
  }

  Future<List<TVShow>> searchShows(String query, int page) async {
    final url = Uri.parse('$_base/search?q=$query&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['tv_shows'] as List)
          .map((show) => TVShow.fromJson(show))
          .toList();
    } else {
      throw Exception('Search failed');
    }
  }

  Future<TVShow> getShowDetails(String id) async {
    final url = Uri.parse('$_base/show-details?q=$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return TVShow.fromJson(jsonData['tvShow']);
    } else {
      throw Exception('Failed to load show details');
    }
  }
}
