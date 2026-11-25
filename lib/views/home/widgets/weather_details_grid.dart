import 'package:flutter/material.dart';
import '../../../models/weather_model.dart';

class WeatherDetailsGrid extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsGrid({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final rainProb = weather.dailyForecasts.isNotEmpty
        ? weather.dailyForecasts.first.precipitationProbability
        : 0;

    final items = [
      _DetailItem(
        title: 'Kelembapan',
        value: '${weather.relativeHumidity}${weather.humidityUnit}',
        subtitle: 'Kelembapan relatif udara',
        icon: Icons.water_drop_rounded,
        iconColor: const Color(0xFF0288D1),
        bgColor: const Color(0xFFE1F5FE),
      ),
      _DetailItem(
        title: 'Kecepatan Angin',
        value: '${weather.windSpeed} ${weather.windSpeedUnit}',
        subtitle: 'Kecepatan angin 10m',
        icon: Icons.air_rounded,
        iconColor: const Color(0xFF00897B),
        bgColor: const Color(0xFFE0F2F1),
      ),
      _DetailItem(
        title: 'Peluang Hujan',
        value: '$rainProb%',
        subtitle: 'Peluang presipitasi hari ini',
        icon: Icons.umbrella_rounded,
        iconColor: const Color(0xFF5E35B1),
        bgColor: const Color(0xFFEDE7F6),
      ),
      _DetailItem(
        title: 'Curah Hujan',
        value: '${weather.precipitation} ${weather.precipitationUnit}',
        subtitle: 'Akumulasi curah hujan',
        icon: Icons.grain_rounded,
        iconColor: const Color(0xFF1E88E5),
        bgColor: const Color(0xFFE3F2FD),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            'Informasi Cuaca Tambahan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade100,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: item.bgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.icon,
                          color: item.iconColor,
                          size: 20,
                        ),
                      ),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.value,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DetailItem {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  _DetailItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}
