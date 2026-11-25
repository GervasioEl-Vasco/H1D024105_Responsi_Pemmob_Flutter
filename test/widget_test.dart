import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_flutter/models/location_model.dart';
import 'package:responsi_flutter/models/weather_model.dart';
import 'package:responsi_flutter/utils/weather_code_helper.dart';

void main() {
  group('LocationModel Tests', () {
    test('Default location is Jakarta', () {
      final defaultLoc = LocationModel.defaultLocation;
      expect(defaultLoc.name, 'Jakarta');
      expect(defaultLoc.country, 'Indonesia');
      expect(defaultLoc.latitude, -6.21462);
      expect(defaultLoc.longitude, 106.84513);
    });

    test('JSON serialization works correctly', () {
      final loc = LocationModel(
        id: 12345,
        name: 'Bandung',
        latitude: -6.9175,
        longitude: 107.6191,
        country: 'Indonesia',
        admin1: 'Jawa Barat',
      );

      final json = loc.toJson();
      final fromJson = LocationModel.fromJson(json);

      expect(fromJson.id, loc.id);
      expect(fromJson.name, loc.name);
      expect(fromJson.latitude, loc.latitude);
      expect(fromJson.longitude, loc.longitude);
      expect(fromJson.admin1, loc.admin1);
      expect(fromJson.subtitle, 'Jawa Barat, Indonesia');
    });
  });

  group('WeatherCodeHelper Tests', () {
    test('Returns correct condition for code 0 (Cerah)', () {
      final info = WeatherCodeHelper.getInfo(0);
      expect(info.description, 'Cerah');
    });

    test('Returns correct condition for code 61 (Hujan Ringan)', () {
      final info = WeatherCodeHelper.getInfo(61);
      expect(info.description, 'Hujan Ringan');
    });

    test('Returns correct condition for code 95 (Badai Petir)', () {
      final info = WeatherCodeHelper.getInfo(95);
      expect(info.description, 'Badai Petir');
    });
  });

  group('WeatherModel JSON Parsing Tests', () {
    test('Parses raw API JSON response properly', () {
      final mockJson = {
        'current_units': {
          'temperature_2m': '°C',
          'relative_humidity_2m': '%',
          'apparent_temperature': '°C',
          'precipitation': 'mm',
          'wind_speed_10m': 'km/h',
        },
        'current': {
          'time': '2026-11-25T18:00',
          'temperature_2m': 28.5,
          'relative_humidity_2m': 80,
          'apparent_temperature': 33.2,
          'precipitation': 0.0,
          'weather_code': 1,
          'wind_speed_10m': 3.5,
        },
        'daily_units': {
          'temperature_2m_max': '°C',
          'temperature_2m_min': '°C',
          'precipitation_probability_max': '%',
        },
        'daily': {
          'time': ['2026-11-25', '2026-11-26'],
          'weather_code': [1, 61],
          'temperature_2m_max': [32.0, 29.5],
          'temperature_2m_min': [24.0, 23.5],
          'precipitation_probability_max': [20, 80],
        },
      };

      final weather = WeatherModel.fromJson(mockJson);

      expect(weather.currentTemperature, 28.5);
      expect(weather.relativeHumidity, 80);
      expect(weather.apparentTemperature, 33.2);
      expect(weather.weatherCode, 1);
      expect(weather.windSpeed, 3.5);
      expect(weather.dailyForecasts.length, 2);
      expect(weather.dailyForecasts[0].maxTemperature, 32.0);
      expect(weather.dailyForecasts[0].minTemperature, 24.0);
      expect(weather.dailyForecasts[1].precipitationProbability, 80);
    });
  });
}
