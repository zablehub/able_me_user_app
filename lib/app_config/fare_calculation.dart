class FareCalculation {
  static double getRate() {
    final DateTime currentTime = DateTime.now();
    final int hour = currentTime.hour;
    final int weekday = currentTime.weekday;

    // Weekday: Monday to Friday (1 to 5)
    bool isWeekday = weekday >= 1 && weekday <= 5;

    // Time conditions
    bool isDayTime = hour >= 6 && hour < 18; // 6 AM to 6 PM
    bool isNightTime = hour >= 18 || hour < 6; // 6 PM to 6 AM

    if (isWeekday && isDayTime) {
      return 2.34;
    } else if ((isWeekday || !isWeekday) && isNightTime) {
      return 2.76;
    } else {
      return 0.00; // Default rate if not matching any condition
    }
  }
  // final double ratePerKMMorning = 2.34;
  // final double ratePerKMEvening = 2.76;
  // final double flagFallMorning = 5.3;
  // final double flagfallEvening = 6.6;
  // late final double rate;
  // FareCalculation() {
  //   final DateTime now = DateTime.now();
  //   if (_isTimeBetween6AMand6PM(now)) {
  //     rate = ratePerKMMorning;
  //   } else {
  //     rate = ratePerKMEvening;
  //   }
  // }
  // bool _isTimeBetween6AMand6PM(DateTime currentTime) {
  //   const int startHour = 6;
  //   const int endHour = 18;

  //   final int currentHour = currentTime.hour;

  //   return currentHour >= startHour && currentHour < endHour;
  // }

  // bool _isTimeBetween6PMand6AM(DateTime currentTime) {
  //   const int eveningStartHour = 18; // 6 PM
  //   const int morningEndHour = 6; // 6 AM

  //   final int currentHour = currentTime.hour;

  //   return currentHour >= eveningStartHour || currentHour < morningEndHour;
  // }
}
