import 'package:flutter/material.dart';
import '../../../models/daily_forecast_model.dart';
import '../../../utils/date_formatter.dart';
import '../../../utils/weather_code_helper.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecastModel> forecasts;

  const DailyForecastList({
    super.key,
    required this.forecasts,
  });

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Perkiraan 7 Hari ke Depan',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${forecasts.length} Hari',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.grey.shade100,
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: forecasts.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade100,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final forecast = forecasts[index];
              final condition = WeatherCodeHelper.getInfo(forecast.weatherCode);
              final isToday = index == 0;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
                child: Row(
                  children: [
                    // Day of the week
                    SizedBox(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormatter.formatForecastDay(forecast.date),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                              color: isToday
                                  ? Theme.of(context).primaryColor
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            condition.description,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Weather Icon & rain probability
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            condition.icon,
                            color: condition.primaryColor,
                            size: 26,
                          ),
                          const SizedBox(width: 8),
                          if (forecast.precipitationProbability > 0)
                            Row(
                              children: [
                                const Icon(
                                  Icons.water_drop_rounded,
                                  size: 13,
                                  color: Color(0xFF0288D1),
                                ),
                                Text(
                                  '${forecast.precipitationProbability}%',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0288D1),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // Temperature Min / Max bar
                    Row(
                      children: [
                        Text(
                          '${forecast.minTemperature.round()}°',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF64B5F6), Color(0xFFFFB74D)],
                            ),
                          ),
                        ),
                        Text(
                          '${forecast.maxTemperature.round()}°',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
