import 'package:flutter/material.dart';

import '../models/show.dart';
import '../services/api_service.dart';

class ShowProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<TVShow> _shows = [];
  List<TVShow> get shows => _shows;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  int _currentPage = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String _searchQuery = '';

  Future<void> fetchPopularShows({int page = 1}) async {
    _isLoading = true;
    _currentPage = page;
    _searchQuery = '';
    notifyListeners();

    try {
      final results = await _apiService.fetchPopularShows(page);
      _shows = results;
      _hasMore = results.isNotEmpty;
    } catch (e) {
      _shows = [];
      _hasMore = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMorePopularShows() async {
    if (_isLoadingMore || !_hasMore || _searchQuery.isNotEmpty) return;

    _isLoadingMore = true;
    _currentPage++;
    notifyListeners();

    try {
      final moreResults = await _apiService.fetchPopularShows(_currentPage);
      if (moreResults.isEmpty) {
        _hasMore = false;
      } else {
        _shows.addAll(moreResults);
      }
    } catch (e) {
      _hasMore = false;
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> searchShows(String query, {int page = 1}) async {
    _isLoading = true;
    _currentPage = page;
    _searchQuery = query;
    notifyListeners();

    try {
      final results = await _apiService.searchShows(query, page);
      _shows = results;
      _hasMore = results.isNotEmpty;
    } catch (e) {
      _shows = [];
      _hasMore = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreSearchResults() async {
    if (_isLoadingMore || !_hasMore || _searchQuery.isEmpty) return;

    _isLoadingMore = true;
    _currentPage++;
    notifyListeners();

    try {
      final moreResults =
          await _apiService.searchShows(_searchQuery, _currentPage);
      if (moreResults.isEmpty) {
        _hasMore = false;
      } else {
        _shows.addAll(moreResults);
      }
    } catch (e) {
      _hasMore = false;
    }

    _isLoadingMore = false;
    notifyListeners();
  }
}
