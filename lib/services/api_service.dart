import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';
import '../models/weather_model.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String _forecastBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Mengambil data perkiraan dan cuaca terkini dari Open-Meteo
  Future<WeatherModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final uri = Uri.parse(
        '$_forecastBaseUrl?latitude=$latitude&longitude=$longitude'
        '&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m'
        '&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max'
        '&timezone=auto',
      );

      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw ApiException('Koneksi timeout. Silakan periksa jaringan Anda.');
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw ApiException(
          'Gagal memuat cuaca (Status: ${response.statusCode}).',
        );
      }
    } on SocketException {
      throw ApiException('Tidak ada koneksi internet. Silakan periksa koneksi Anda.');
    } on FormatException {
      throw ApiException('Format data respons server tidak valid.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Terjadi kesalahan yang tidak terduga: $e');
    }
  }

  /// Mencari lokasi kota menggunakan Open-Meteo Geocoding API
  Future<List<LocationModel>> searchLocation(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    try {
      final uri = Uri.parse(
        '$_geocodingBaseUrl?name=${Uri.encodeComponent(cleanQuery)}&count=10&language=id&format=json',
      );

      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw ApiException('Pencarian timeout. Silakan coba kembali.');
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final results = data['results'] as List<dynamic>?;

        if (results == null || results.isEmpty) {
          return [];
        }

        return results
            .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          'Gagal mencari lokasi (Status: ${response.statusCode}).',
        );
      }
    } on SocketException {
      throw ApiException('Tidak ada koneksi internet. Silakan periksa koneksi Anda.');
    } on FormatException {
      throw ApiException('Format data respons server tidak valid.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Terjadi kesalahan saat mencari lokasi: $e');
    }
  }
}
