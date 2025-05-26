import 'package:flutter/material.dart';
import 'package:asgm1/screens/voucher1_page.dart';
import 'package:asgm1/screens/voucher2_page.dart';
import 'package:asgm1/screens/voucher3_page.dart';

class MyRewards extends StatefulWidget {
  const MyRewards({super.key});

  @override
  State<MyRewards> createState() => _MyRewards();
}

class _MyRewards extends State<MyRewards> {
  int myCurrentIndex = 0;

  final List<String> voucherImages = [
    'assets/images/myprofile/voucher1.jpg',
    'assets/images/myprofile/voucher2.jpg',
    'assets/images/myprofile/voucher3.jpg',
  ];

  final List<Widget> pages = const [
    Voucher1Page(),
    Voucher2Page(),
    Voucher3Page(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: voucherImages.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: GestureDetector(
            onTap: () {
              setState(() {
                myCurrentIndex = index;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pages[myCurrentIndex]),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                voucherImages[index],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
