import 'package:flutter/material.dart';
import '../../../models/location_model.dart';

class SearchResultItem extends StatelessWidget {
  final LocationModel location;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const SearchResultItem({
    super.key,
    required this.location,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.location_city_rounded,
            color: Theme.of(context).primaryColor,
            size: 22,
          ),
        ),
        title: Text(
          location.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF0F172A),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (location.subtitle.isNotEmpty)
              Text(
                location.subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              '${location.latitude.toStringAsFixed(2)}°, ${location.longitude.toStringAsFixed(2)}°',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          tooltip: isFavorite ? 'Hapus Favorit' : 'Simpan Favorit',
          icon: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isFavorite ? Colors.red.shade400 : Colors.grey.shade400,
          ),
          onPressed: onToggleFavorite,
        ),
      ),
    );
  }
}
