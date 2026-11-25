import 'package:flutter/material.dart';

class WeatherConditionInfo {
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final Color primaryColor;

  const WeatherConditionInfo({
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.primaryColor,
  });
}

class WeatherCodeHelper {
  static WeatherConditionInfo getInfo(int code, {bool isDay = true}) {
    switch (code) {
      case 0:
        return const WeatherConditionInfo(
          description: 'Cerah',
          icon: Icons.wb_sunny_rounded,
          gradientColors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
          primaryColor: Color(0xFFFFA726),
        );
      case 1:
        return const WeatherConditionInfo(
          description: 'Sebagian Besar Cerah',
          icon: Icons.wb_sunny_outlined,
          gradientColors: [Color(0xFF2980B9), Color(0xFF6DD5FA)],
          primaryColor: Color(0xFFFFB74D),
        );
      case 2:
        return const WeatherConditionInfo(
          description: 'Cerah Berawan',
          icon: Icons.cloud_queue_rounded,
          gradientColors: [Color(0xFF3a7bd5), Color(0xFF3a6073)],
          primaryColor: Color(0xFF90CAF9),
        );
      case 3:
        return const WeatherConditionInfo(
          description: 'Berawan Tebal',
          icon: Icons.cloud_rounded,
          gradientColors: [Color(0xFF4B6CB7), Color(0xFF182848)],
          primaryColor: Color(0xFFB0BEC5),
        );
      case 45:
      case 48:
        return const WeatherConditionInfo(
          description: 'Berkabut',
          icon: Icons.blur_on_rounded,
          gradientColors: [Color(0xFF606c88), Color(0xFF3f4c6b)],
          primaryColor: Color(0xFFCFD8DC),
        );
      case 51:
      case 53:
      case 55:
        return const WeatherConditionInfo(
          description: 'Gerimis',
          icon: Icons.grain_rounded,
          gradientColors: [Color(0xFF3A6073), Color(0xFF16222A)],
          primaryColor: Color(0xFF81D4FA),
        );
      case 56:
      case 57:
        return const WeatherConditionInfo(
          description: 'Gerimis Membeku',
          icon: Icons.ac_unit_rounded,
          gradientColors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
          primaryColor: Color(0xFF80DEEA),
        );
      case 61:
        return const WeatherConditionInfo(
          description: 'Hujan Ringan',
          icon: Icons.water_drop_outlined,
          gradientColors: [Color(0xFF1F4037), Color(0xFF99F2C8)],
          primaryColor: Color(0xFF4FC3F7),
        );
      case 63:
        return const WeatherConditionInfo(
          description: 'Hujan Sedang',
          icon: Icons.water_drop_rounded,
          gradientColors: [Color(0xFF141E30), Color(0xFF243B55)],
          primaryColor: Color(0xFF29B6F6),
        );
      case 65:
        return const WeatherConditionInfo(
          description: 'Hujan Lebat',
          icon: Icons.beach_access_rounded,
          gradientColors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          primaryColor: Color(0xFF0288D1),
        );
      case 66:
      case 67:
        return const WeatherConditionInfo(
          description: 'Hujan Beku',
          icon: Icons.ac_unit_rounded,
          gradientColors: [Color(0xFF2C3E50), Color(0xFF3498DB)],
          primaryColor: Color(0xFF4DD0E1),
        );
      case 71:
      case 73:
      case 75:
      case 77:
        return const WeatherConditionInfo(
          description: 'Salju',
          icon: Icons.cloudy_snowing,
          gradientColors: [Color(0xFF70e1f5), Color(0xFFffd194)],
          primaryColor: Color(0xFFE0F7FA),
        );
      case 80:
      case 81:
      case 82:
        return const WeatherConditionInfo(
          description: 'Hujan Deras / Badai Hujan',
          icon: Icons.thunderstorm_rounded,
          gradientColors: [Color(0xFF1F1C2C), Color(0xFF928DAB)],
          primaryColor: Color(0xFF29B6F6),
        );
      case 85:
      case 86:
        return const WeatherConditionInfo(
          description: 'Hujan Salju Lebat',
          icon: Icons.cloudy_snowing,
          gradientColors: [Color(0xFF2C3E50), Color(0xFFBDC3C7)],
          primaryColor: Color(0xFFB3E5FC),
        );
      case 95:
        return const WeatherConditionInfo(
          description: 'Badai Petir',
          icon: Icons.flash_on_rounded,
          gradientColors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          primaryColor: Color(0xFFFFD54F),
        );
      case 96:
      case 99:
        return const WeatherConditionInfo(
          description: 'Badai Petir & Hujan Es',
          icon: Icons.flash_on_rounded,
          gradientColors: [Color(0xFF000000), Color(0xFF434343)],
          primaryColor: Color(0xFFFFCA28),
        );
      default:
        return const WeatherConditionInfo(
          description: 'Berawan',
          icon: Icons.cloud_outlined,
          gradientColors: [Color(0xFF3a7bd5), Color(0xFF3a6073)],
          primaryColor: Color(0xFF90CAF9),
        );
    }
  }
}
