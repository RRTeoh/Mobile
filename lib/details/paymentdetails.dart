class PaymentDetails {
  String date;
  String time;
  String name;
  String amount;

  PaymentDetails({
    required this.date,
    required this.time,
    required this.name,
    required this.amount,
  });

  DateTime get parsedDate {
    // Assumes format like "30 June"
    final fullDate = '$date 2025'; // Add year if needed
    return DateTime.parse(_convertMonthDateToISO(fullDate));

  }

  static String _convertMonthDateToISO(String input) {
    // e.g., "30 June 2025" → "2025-06-30"
    final months = {
      'January': '01',
      'February': '02',
      'March': '03',
      'April': '04',
      'May': '05',
      'June': '06',
      'July': '07',
      'August': '08',
      'September': '09',
      'October': '10',
      'November': '11',
      'December': '12',
    };

    final parts = input.split(' ');
    final day = parts[0].padLeft(2, '0');
    final month = months[parts[1]]!;
    final year = parts[2];
    return '$year-$month-$day';
  }

  static List<PaymentDetails> getAllDetails() {
    return [
      PaymentDetails(date: "18 June 2025", time: "11:14", name: "Membership Subscription", amount: "- RM 50"),
      PaymentDetails(date: "19 June 2025", time: "5:00", name: "Tabata Workshop", amount: "- RM 100"),
      PaymentDetails(date: "4 June 2025", time: "12:34", name: "Healthy Bento", amount: "- RM 12"),
      PaymentDetails(date: "13 May 2025", time: "10:00", name: "Healthy Smoothie", amount: "- RM 15"),
      PaymentDetails(date: "01 January 2025", time: "12:34", name: "Membership Subscription", amount: "- RM 50"),
    ];
  }
}
