import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class SearchViewModel extends ChangeNotifier {
  final ApiService apiService;
  final StorageService storageService;

  List<LocationModel> _searchResults = [];
  List<LocationModel> _favorites = [];
  List<String> _history = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _query = '';
  Timer? _debounceTimer;

  SearchViewModel({
    required this.apiService,
    required this.storageService,
  }) {
    loadFavorites();
    loadHistory();
  }

  // Getters
  List<LocationModel> get searchResults => _searchResults;
  List<LocationModel> get favorites => _favorites;
  List<String> get history => _history;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get query => _query;
  bool get isSearching => _query.trim().isNotEmpty;

  /// Memuat daftar lokasi favorit dari storage
  void loadFavorites() {
    _favorites = storageService.getFavoriteLocations();
    notifyListeners();
  }

  /// Memuat riwayat pencarian
  void loadHistory() {
    _history = storageService.getSearchHistory();
    notifyListeners();
  }

  /// Menangani perubahan input teks pencarian dengan debounce 400ms
  void onQueryChanged(String newQuery) {
    _query = newQuery;
    _errorMessage = null;

    _debounceTimer?.cancel();

    if (newQuery.trim().isEmpty) {
      _searchResults = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      executeSearch(newQuery);
    });
  }

  /// Melakukan request pencarian kota ke Open-Meteo Geocoding API
  Future<void> executeSearch(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await apiService.searchLocation(clean);
      _searchResults = results;
      if (results.isNotEmpty) {
        await storageService.addSearchHistory(clean);
        loadHistory();
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _searchResults = [];
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat mencari kota: $e';
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Menghapus teks pencarian
  void clearSearch() {
    _debounceTimer?.cancel();
    _query = '';
    _searchResults = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Memeriksa apakah lokasi tersimpan sebagai favorit
  bool isFavorite(LocationModel location) {
    return _favorites.any((item) => item.id == location.id);
  }

  /// Toggle favorit untuk lokasi tertentu
  Future<bool> toggleFavorite(LocationModel location) async {
    final current = isFavorite(location);
    if (current) {
      await storageService.removeFavorite(location.id);
    } else {
      await storageService.addFavorite(location);
    }
    loadFavorites();
    return !current;
  }

  /// Menghapus lokasi dari favorit
  Future<void> removeFavorite(int locationId) async {
    await storageService.removeFavorite(locationId);
    loadFavorites();
  }

  /// Menghapus riwayat pencarian
  Future<void> clearHistory() async {
    await storageService.clearSearchHistory();
    loadHistory();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
