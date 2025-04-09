import 'package:flutter/material.dart';

import '../models/show.dart';
import '../services/api_service.dart';

class ShowProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<TVShow> _shows = [];
  List<TVShow> get shows => _shows;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentPage = 1;
  String _searchQuery = '';

  Future<void> fetchPopularShows({int page = 1}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentPage = page;
      _searchQuery = '';
      _shows = await _apiService.fetchPopularShows(page);
    } catch (e) {
      _shows = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchShows(String query, {int page = 1}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _searchQuery = query;
      _currentPage = page;
      _shows = await _apiService.searchShows(query, page);
    } catch (e) {
      _shows = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
