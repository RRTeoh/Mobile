import 'package:flutter/material.dart';

class Promo1 extends StatelessWidget {
  const Promo1({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Voucher 1",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: EdgeInsets.only(top: kToolbarHeight + 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue.shade100, Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/myprofile/voucher1.jpg',
              width: double.infinity,
              height: 170,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    "Black Friday Discount",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Terms and conditions",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "1. Applicable to all gym members only.",
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "2. Valid for 7 days after activation.",
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "3. Cannot be combined with other offers.",
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "4. Expired vouchers will not be reissued or extended.",
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "5. Cannot be combined with other offers.",
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "6. The voucher can be redeemed via the official gym app or at the front desk.",
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: Container(
                                  height: 320,
                                  padding: const EdgeInsets.all(20),
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          const SizedBox(height: 40),
                                          Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  'assets/images/myprofile/qrcode.png',
                                                  width: 300,
                                                  height: 170,
                                                  fit: BoxFit.contain,
                                                ),
                                                const Text(
                                                  "SFX2098T0",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                const Text(
                                                  "Show or Enter the code to redeem",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue.shade100,
                        ),
                        child: const Text(
                          "Redeem",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
