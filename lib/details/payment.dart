import 'package:flutter/material.dart';
import 'package:asgm1/details/paymentdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class MyPayment extends StatefulWidget {
  const MyPayment({super.key});

  @override
  State<MyPayment> createState() => _MyPaymentState();
}

class _MyPaymentState extends State<MyPayment> {
  List<PaymentDetails> payments = [];
  String selectedFilter = 'Last 30 Days';

  @override
  void initState() {
    super.initState();
    _loadPayments(); // Call Firestore fetch on load
  }

  Future<void> _loadPayments() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'testUser123'; // use proper UID

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('payments')
        .get();

    final allPayments = snapshot.docs
        .map((doc) => PaymentDetails.fromMap(doc.data()))
        .toList();

    _applyFilter(selectedFilter, allPayments);
  }

  void _applyFilter(String filter, List<PaymentDetails> allPayments) {
    final now = DateTime.now();

    List<PaymentDetails> filtered;

    switch (filter) {
      case 'Today':
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

  void _handleFilterSelection(String filter) {
    _loadPayments(); // re-fetch and apply filter
    selectedFilter = filter;
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
                      DateFormat('dd MMM yyyy').format(payment.date),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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
