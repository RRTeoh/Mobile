import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentDetails {
  DateTime date;         // <- now DateTime type
  String time;
  String name;
  String amount;

  PaymentDetails({
    required this.date,
    required this.time,
    required this.name,
    required this.amount,
  });

factory PaymentDetails.fromMap(Map<String, dynamic> map) {
  return PaymentDetails(
    date: (map['date'] as Timestamp).toDate(), // ✅ works if Firestore field is a timestamp
    time: map['time'] ?? '',
    name: map['name'] ?? '',
    amount: map['amount'] ?? '',
  );
}

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date), 
      'time': time,
      'name': name,
      'amount': amount,
    };
  }

  DateTime get parsedDate => date; // Already a DateTime now
}
