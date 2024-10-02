// import 'package:intl/intl.dart';

extension FORMATTER on double {
  String convertMinutesToTimeFormat() {
    // Get total seconds
    int totalSeconds = (this * 60).toInt();

    // Calculate hours, minutes, and seconds
    int hours = totalSeconds ~/ 3600;
    int remainingMinutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    // Build the formatted string
    List<String> parts = [];

    if (hours > 0) {
      parts.add('$hours hour${hours > 1 ? 's' : ''}');
    }
    if (remainingMinutes > 0) {
      parts.add('$remainingMinutes minute${remainingMinutes > 1 ? 's' : ''}');
    }
    if (seconds > 0) {
      parts.add('$seconds second${seconds > 1 ? 's' : ''}');
    }

    // Join the parts with 'and'
    return parts.join(' and ');
  }
}
