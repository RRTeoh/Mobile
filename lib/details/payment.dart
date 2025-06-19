import 'package:flutter/material.dart';
import 'package:asgm1/details/paymentdetails.dart';

class MyPayment extends StatefulWidget {
  const MyPayment({super.key});

  @override
  State<MyPayment> createState() => _MyPaymentState();
}

class _MyPaymentState extends State<MyPayment> {
  List<PaymentDetails> payments = PaymentDetails.getAllDetails();
  String selectedFilter = 'Last 30 Days';

void _handleFilterSelection(String filter) {
  final now = DateTime.now();
  final allPayments = PaymentDetails.getAllDetails();

  List<PaymentDetails> filtered;

  switch (filter) {
    case 'Today':
      print('Today is: ${now.toIso8601String().split("T")[0]}'); 
      filtered = allPayments.where((p) =>
          isSameDate(p.parsedDate, now)).toList();
      break;
    case 'Yesterday':
      final yesterday = now.subtract(const Duration(days: 1));
      filtered = allPayments.where((p) =>
          isSameDate(p.parsedDate, yesterday)).toList();
      break;
    case 'Last 7 Days':
      filtered = allPayments.where((p) =>
          p.parsedDate.isAfter(now.subtract(const Duration(days: 7)))).toList();
      break;
    case 'Last 30 Days':
      filtered = allPayments.where((p) =>
          p.parsedDate.isAfter(now.subtract(const Duration(days: 30)))).toList();
      break;
    default:
      filtered = allPayments;
  }

  setState(() {
    selectedFilter = filter;
    payments = filtered;
  });
}

bool isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 5),
      itemCount: payments.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedFilter,
                      style: const TextStyle(fontSize: 12),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.filter_list, color: Colors.grey),
                      offset: const Offset(0, -10), // push it upward (adjust as needed)
                      onSelected: _handleFilterSelection,
                      itemBuilder: (BuildContext context) {
                        return [
                          'Today',
                          'Yesterday',
                          'Last 7 Days',
                          'Last 30 Days'
                        ].map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        }

        final payment = payments[index - 1];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      payment.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      payment.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      payment.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      payment.amount,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
