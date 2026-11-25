import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class StorageService {
  static const String _keyFavorites = 'favorite_locations';
  static const String _keyLastLocation = 'last_selected_location';
  static const String _keySearchHistory = 'search_history';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Inisialisasi StorageService
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  /// Mengambil daftar lokasi favorit yang tersimpan
  List<LocationModel> getFavoriteLocations() {
    final jsonString = _prefs.getString(_keyFavorites);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded
          .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Menambah lokasi ke daftar favorit
  Future<bool> addFavorite(LocationModel location) async {
    final favorites = getFavoriteLocations();
    // Cek apakah sudah ada berdasarkan ID
    final exists = favorites.any((item) => item.id == location.id);
    if (!exists) {
      favorites.add(location);
      final jsonString =
          jsonEncode(favorites.map((e) => e.toJson()).toList());
      return await _prefs.setString(_keyFavorites, jsonString);
    }
    return true;
  }

  /// Menghapus lokasi dari daftar favorit
  Future<bool> removeFavorite(int locationId) async {
    final favorites = getFavoriteLocations();
    favorites.removeWhere((item) => item.id == locationId);
    final jsonString = jsonEncode(favorites.map((e) => e.toJson()).toList());
    return await _prefs.setString(_keyFavorites, jsonString);
  }

  /// Memeriksa apakah lokasi adalah favorit
  bool isFavorite(int locationId) {
    final favorites = getFavoriteLocations();
    return favorites.any((item) => item.id == locationId);
  }

  /// Menyimpan lokasi terakhir yang dipilih pengguna
  Future<bool> saveLastSelectedLocation(LocationModel location) async {
    final jsonString = jsonEncode(location.toJson());
    return await _prefs.setString(_keyLastLocation, jsonString);
  }

  /// Mengambil lokasi terakhir yang dipilih pengguna
  LocationModel? getLastSelectedLocation() {
    final jsonString = _prefs.getString(_keyLastLocation);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      return LocationModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  /// Mengambil riwayat pencarian
  List<String> getSearchHistory() {
    return _prefs.getStringList(_keySearchHistory) ?? [];
  }

  /// Menambahkan riwayat pencarian
  Future<void> addSearchHistory(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) return;

    final history = getSearchHistory();
    history.remove(clean);
    history.insert(0, clean);

    if (history.length > 10) {
      history.removeRange(10, history.length);
    }

    await _prefs.setStringList(_keySearchHistory, history);
  }

  /// Menghapus riwayat pencarian
  Future<void> clearSearchHistory() async {
    await _prefs.remove(_keySearchHistory);
  }
}
