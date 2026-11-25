class DateFormatter {
  static const List<String> _daysIndonesian = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _monthsIndonesian = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  /// Format date to "Hari ini", "Besok", or "Nama Hari, Tgl Bln"
  static String formatForecastDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    final difference = targetDate.difference(today).inDays;

    if (difference == 0) {
      return 'Hari ini';
    } else if (difference == 1) {
      return 'Besok';
    } else {
      final dayName = _daysIndonesian[date.weekday - 1];
      final monthName = _monthsIndonesian[date.month - 1];
      return '$dayName, ${date.day} $monthName';
    }
  }

  /// Format timestamp e.g. "2026-11-25T18:15" into "25 Nov 2026, 18:15 WIB"
  static String formatCurrentTime(String timeStr) {
    final parsed = DateTime.tryParse(timeStr);
    if (parsed == null) return timeStr;

    final dayName = _daysIndonesian[parsed.weekday - 1];
    final monthName = _monthsIndonesian[parsed.month - 1];
    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');

    return '$dayName, ${parsed.day} $monthName ${parsed.year} • $hour:$minute';
  }
}
