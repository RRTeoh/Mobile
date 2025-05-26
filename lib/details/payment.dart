import 'package:flutter/material.dart';
import 'package:asgm1/details/paymentdetails.dart';

class MyPayment extends StatelessWidget {
  const MyPayment({super.key});

  @override
  Widget build(BuildContext context) {
    List<PaymentDetails> payments = PaymentDetails.getallDetails();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 20),
      itemCount: payments.length + 1, // +1 for the filter bar
      itemBuilder: (context, index) {
        if (index == 0) {
          // Show filter bar with space below
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
                  children: const [
                    Text(
                      '20 April 25 - 19 May 25',
                      style: TextStyle(fontSize: 12),
                    ),
                    Icon(Icons.filter_list, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(height: 10), // gap below the filter bar
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
