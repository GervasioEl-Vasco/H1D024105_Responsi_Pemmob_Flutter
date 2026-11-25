import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/location_model.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/search_result_item.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  void _onLocationSelected(BuildContext context, LocationModel location) {
    // Memperbarui lokasi terpilih pada WeatherViewModel
    context.read<WeatherViewModel>().selectLocation(location);

    // Kembali ke layar utama
    Navigator.pop(context);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text('Memuat cuaca untuk ${location.name}...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Kota & Favorit'),
      ),
      body: Consumer<SearchViewModel>(
        builder: (context, searchVm, child) {
          return Column(
            children: [
              // Search Bar Widget
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SearchBarWidget(
                  onChanged: (val) => searchVm.onQueryChanged(val),
                  onClear: () => searchVm.clearSearch(),
                ),
              ),

              // Content Area
              Expanded(
                child: Builder(
                  builder: (context) {
                    // Kondisi 1: Sedang mencari di API
                    if (searchVm.isLoading) {
                      return const LoadingView(
                        message: 'Mencari lokasi kota dari server...',
                      );
                    }

                    // Kondisi 2: Terjadi error saat request API pencarian
                    if (searchVm.errorMessage != null) {
                      return ErrorView(
                        message: searchVm.errorMessage!,
                        onRetry: () => searchVm.executeSearch(searchVm.query),
                      );
                    }

                    // Kondisi 3: Pengguna sedang mengetik pencarian
                    if (searchVm.isSearching) {
                      if (searchVm.searchResults.isEmpty) {
                        return EmptyView(
                          title: 'Kota Tidak Ditemukan',
                          message:
                              'Tidak ada hasil untuk "${searchVm.query}". Pastikan ejaan nama kota sudah benar.',
                          icon: Icons.location_off_rounded,
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: searchVm.searchResults.length,
                        itemBuilder: (context, index) {
                          final loc = searchVm.searchResults[index];
                          final isFav = searchVm.isFavorite(loc);

                          return SearchResultItem(
                            location: loc,
                            isFavorite: isFav,
                            onTap: () => _onLocationSelected(context, loc),
                            onToggleFavorite: () async {
                              final added = await searchVm.toggleFavorite(loc);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    content: Text(
                                      added
                                          ? '${loc.name} ditambahkan ke favorit'
                                          : '${loc.name} dihapus dari favorit',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    }

                    // Kondisi 4: Tampilan Awal (Belum mengetik) -> Tampilkan Favorit & Riwayat
                    return _buildDefaultView(context, searchVm);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDefaultView(BuildContext context, SearchViewModel searchVm) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        // Section: Riwayat Pencarian (Jika ada)
        if (searchVm.history.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Riwayat Pencarian',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () => searchVm.clearHistory(),
                child: const Text('Hapus Semua'),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: searchVm.history.map((term) {
              return ActionChip(
                avatar: const Icon(Icons.history_rounded, size: 16),
                label: Text(term),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                onPressed: () => searchVm.executeSearch(term),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],

        // Section: Daftar Lokasi Favorit
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  color: Colors.redAccent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Lokasi Favorit Tersimpan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            if (searchVm.favorites.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${searchVm.favorites.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        if (searchVm.favorites.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  'Belum Ada Lokasi Favorit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cari nama kota dan tekan ikon hati untuk menyimpannya sebagai lokasi favorit.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: searchVm.favorites.length,
            itemBuilder: (context, index) {
              final fav = searchVm.favorites[index];
              return Dismissible(
                key: Key('fav_${fav.id}_${fav.name}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (_) {
                  searchVm.removeFavorite(fav.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${fav.name} dihapus dari favorit'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: SearchResultItem(
                  location: fav,
                  isFavorite: true,
                  onTap: () => _onLocationSelected(context, fav),
                  onToggleFavorite: () => searchVm.removeFavorite(fav.id),
                ),
              );
            },
          ),
      ],
    );
  }
}
