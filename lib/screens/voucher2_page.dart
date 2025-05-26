import 'package:flutter/material.dart';

class Voucher2Page extends StatelessWidget {
  const Voucher2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // or any color you prefer
      appBar: AppBar(
        title: const Text("Voucher 2"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/myprofile/voucher2.jpg',
                width: double.infinity,
                height: 210,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: 
                const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children:  [
                    Text(
                      "7 Days Pass Voucher",
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // prevent red text
                      decoration: TextDecoration.none, // prevent underline
                      ),
                    ), 
                 ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("1. The 7-Day Pass is available to new visitors or non-members only.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                    ),
                     SizedBox(height:3),
                     Text("2. Gym reserves the right to modify or cancel the voucher offer at any time without prior notice.",
                          
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),              
                    ),
                     SizedBox(height:3),
                     Text("3. The pass cannot be paused, extended, or reissued once activated.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),              
                    ), 
                     SizedBox(height:3),
                     Text("4. The 7-Day Pass is non-transferable and may only be used by the individual who registered for it.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),              
                    ),
                                         SizedBox(height:3),
                     Text("5. Advance booking is required for classes or personal training sessions.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),              
                    ), 
                     SizedBox(height:3),
                     Text("6. Non-transferable and cannot be extended or reissued.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),              
                    ),
                    SizedBox(height:3),
                    Text("7. It cannot be combined with other promotions, discounts, or vouchers.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),              
                    ),  
                  ],
                 ),  
                ),
                const SizedBox(height: 100),
                //Redemm button
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: null, // disables the button
                      child: const Text(
                        "Redeem",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
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
    );
  }
}