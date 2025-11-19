class TimeService {
  static String formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final localTime = time.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(localTime.year, localTime.month, localTime.day);

    final difference = today.difference(messageDate).inDays;

    // Today - show time
    if (messageDate == today) {
      final hour = localTime.hour.toString().padLeft(2, '0');
      final minute = localTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    // Yesterday
    if (messageDate == yesterday) {
      return 'Yesterday';
    }

    // Within the last week - show day name
    if (difference < 7) {
      const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      return weekdays[localTime.weekday - 1];
    }

    // Older - show date
    final day = localTime.day.toString().padLeft(2, '0');
    final month = localTime.month.toString().padLeft(2, '0');
    final year = localTime.year;

    // If same year, omit year
    if (localTime.year == now.year) {
      return '$day/$month';
    }

    return '$day/$month/$year';
  }
}
