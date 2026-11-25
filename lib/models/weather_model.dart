import 'daily_forecast_model.dart';

class WeatherModel {
  final double currentTemperature;
  final int relativeHumidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;
  final String currentTime;
  final String temperatureUnit;
  final String humidityUnit;
  final String windSpeedUnit;
  final String precipitationUnit;
  final List<DailyForecastModel> dailyForecasts;

  WeatherModel({
    required this.currentTemperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    required this.currentTime,
    this.temperatureUnit = '°C',
    this.humidityUnit = '%',
    this.windSpeedUnit = 'km/h',
    this.precipitationUnit = 'mm',
    required this.dailyForecasts,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final currentUnits = json['current_units'] as Map<String, dynamic>? ?? {};
    final daily = json['daily'] as Map<String, dynamic>? ?? {};

    // Parse daily forecast list
    final List<DailyForecastModel> forecasts = [];
    final times = daily['time'] as List<dynamic>? ?? [];
    final weatherCodes = daily['weather_code'] as List<dynamic>? ?? [];
    final maxTemps = daily['temperature_2m_max'] as List<dynamic>? ?? [];
    final minTemps = daily['temperature_2m_min'] as List<dynamic>? ?? [];
    final precipProbs = daily['precipitation_probability_max'] as List<dynamic>? ?? [];

    for (int i = 0; i < times.length; i++) {
      forecasts.add(
        DailyForecastModel.fromRaw(
          dateStr: times[i].toString(),
          weatherCode: (weatherCodes.length > i && weatherCodes[i] != null)
              ? (weatherCodes[i] as num).toInt()
              : 0,
          maxTemp: (maxTemps.length > i && maxTemps[i] != null)
              ? (maxTemps[i] as num).toDouble()
              : 0.0,
          minTemp: (minTemps.length > i && minTemps[i] != null)
              ? (minTemps[i] as num).toDouble()
              : 0.0,
          precipProb: (precipProbs.length > i && precipProbs[i] != null)
              ? (precipProbs[i] as num).toInt()
              : 0,
        ),
      );
    }

    return WeatherModel(
      currentTemperature: (current['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (current['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      apparentTemperature:
          (current['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      precipitation: (current['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (current['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed: (current['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      currentTime: current['time']?.toString() ?? '',
      temperatureUnit: currentUnits['temperature_2m']?.toString() ?? '°C',
      humidityUnit: currentUnits['relative_humidity_2m']?.toString() ?? '%',
      windSpeedUnit: currentUnits['wind_speed_10m']?.toString() ?? 'km/h',
      precipitationUnit: currentUnits['precipitation']?.toString() ?? 'mm',
      dailyForecasts: forecasts,
    );
  }
}
