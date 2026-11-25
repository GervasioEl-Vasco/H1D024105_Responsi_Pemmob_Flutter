import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final ApiService apiService;
  final StorageService storageService;

  LocationModel? _currentLocation;
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isCurrentLocationFavorite = false;

  WeatherViewModel({
    required this.apiService,
    required this.storageService,
  });

  // Getters
  LocationModel? get currentLocation => _currentLocation;
  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasData => _weather != null && _errorMessage == null;
  bool get isCurrentLocationFavorite => _isCurrentLocationFavorite;

  /// Memulai inisialisasi: memuat lokasi terakhir atau default Jakarta
  Future<void> initialize() async {
    final lastLocation = storageService.getLastSelectedLocation();
    _currentLocation = lastLocation ?? LocationModel.defaultLocation;
    _checkFavoriteStatus();
    await fetchWeather();
  }

  /// Memilih lokasi baru dan langsung mengambil data cuaca
  Future<void> selectLocation(LocationModel location) async {
    if (_currentLocation?.id == location.id && _weather != null) {
      return;
    }

    _currentLocation = location;
    await storageService.saveLastSelectedLocation(location);
    _checkFavoriteStatus();
    await fetchWeather();
  }

  /// Mengambil data cuaca dari API
  Future<void> fetchWeather() async {
    if (_currentLocation == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await apiService.fetchWeather(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
      );
      _weather = result;
      _errorMessage = null;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan tidak terduga: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh data cuaca terkini
  Future<void> refresh() async {
    _checkFavoriteStatus();
    await fetchWeather();
  }

  /// Memeriksa status favorit lokasi saat ini
  void _checkFavoriteStatus() {
    if (_currentLocation != null) {
      _isCurrentLocationFavorite =
          storageService.isFavorite(_currentLocation!.id);
      notifyListeners();
    }
  }

  /// Menambah atau menghapus lokasi saat ini dari daftar favorit
  Future<bool> toggleFavorite() async {
    if (_currentLocation == null) return false;

    if (_isCurrentLocationFavorite) {
      await storageService.removeFavorite(_currentLocation!.id);
      _isCurrentLocationFavorite = false;
    } else {
      await storageService.addFavorite(_currentLocation!);
      _isCurrentLocationFavorite = true;
    }

    notifyListeners();
    return _isCurrentLocationFavorite;
  }
}
