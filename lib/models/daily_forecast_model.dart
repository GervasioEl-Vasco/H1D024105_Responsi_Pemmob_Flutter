class DailyForecastModel {
  final DateTime date;
  final int weatherCode;
  final double maxTemperature;
  final double minTemperature;
  final int precipitationProbability;

  DailyForecastModel({
    required this.date,
    required this.weatherCode,
    required this.maxTemperature,
    required this.minTemperature,
    required this.precipitationProbability,
  });

  factory DailyForecastModel.fromRaw({
    required String dateStr,
    required int weatherCode,
    required double maxTemp,
    required double minTemp,
    required int precipProb,
  }) {
    return DailyForecastModel(
      date: DateTime.tryParse(dateStr) ?? DateTime.now(),
      weatherCode: weatherCode,
      maxTemperature: maxTemp,
      minTemperature: minTemp,
      precipitationProbability: precipProb,
    );
  }
}
