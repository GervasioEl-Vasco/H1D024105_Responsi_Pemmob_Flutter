import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../search/search_screen.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import 'widgets/current_weather_card.dart';
import 'widgets/daily_forecast_list.dart';
import 'widgets/weather_details_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, weatherVm, child) {
        final location = weatherVm.currentLocation;
        final weather = weatherVm.weather;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location?.name ?? 'Cuaca Terkini',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (location != null && location.subtitle.isNotEmpty)
                  Text(
                    location.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
            actions: [
              // Tombol Tambah/Hapus Favorit
              if (location != null)
                IconButton(
                  tooltip: weatherVm.isCurrentLocationFavorite
                      ? 'Hapus dari Favorit'
                      : 'Simpan ke Favorit',
                  icon: Icon(
                    weatherVm.isCurrentLocationFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: weatherVm.isCurrentLocationFavorite
                        ? Colors.red.shade400
                        : Colors.grey.shade700,
                  ),
                  onPressed: () async {
                    final isFav = await weatherVm.toggleFavorite();
                    // Sinkronisasi dengan SearchViewModel jika terbuka
                    if (context.mounted) {
                      context.read<SearchViewModel>().loadFavorites();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          content: Text(
                            isFav
                                ? '${location.name} ditambahkan ke favorit'
                                : '${location.name} dihapus dari favorit',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),

              // Tombol Cari Lokasi
              IconButton(
                tooltip: 'Cari Lokasi',
                icon: const Icon(Icons.search_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
              ),

              // Tombol Refresh
              IconButton(
                tooltip: 'Segarkan',
                icon: const Icon(Icons.refresh_rounded),
                onPressed: weatherVm.isLoading
                    ? null
                    : () => weatherVm.refresh(),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (weatherVm.isLoading && weather == null) {
                return const LoadingView(
                  message: 'Sedang memuat data cuaca dari Open-Meteo...',
                );
              }

              if (weatherVm.hasError && weather == null) {
                return ErrorView(
                  message: weatherVm.errorMessage ??
                      'Gagal mengambil data cuaca dari server.',
                  onRetry: () => weatherVm.fetchWeather(),
                );
              }

              if (weather == null || location == null) {
                return Center(
                  child: Text(
                    'Tidak ada data cuaca.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => weatherVm.refresh(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Loading bar kecil jika sedang refresh saat sudah ada data
                      if (weatherVm.isLoading)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: LinearProgressIndicator(minHeight: 3),
                        ),

                      // Kartu Cuaca Terkini
                      CurrentWeatherCard(
                        weather: weather,
                        location: location,
                      ),
                      const SizedBox(height: 20),

                      // Grid Rincian Informasi Tambahan
                      WeatherDetailsGrid(
                        weather: weather,
                      ),
                      const SizedBox(height: 20),

                      // Perkiraan Cuaca 7 Hari ke Depan
                      DailyForecastList(
                        forecasts: weather.dailyForecasts,
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
