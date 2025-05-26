import 'package:flutter/material.dart';

class Voucher1Page extends StatelessWidget {
  const Voucher1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // or any color you prefer
      appBar: AppBar(
        title: const Text("Voucher 1"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/myprofile/voucher1.jpg',
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
                    Text("1. Applicable to all new members only.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                    ),
                     SizedBox(height:3),
                     Text("2. Valid for 7 days after activation.",
                          
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),              
                    ),
                     SizedBox(height:3),
                     Text("3. Cannot be combined with other offers",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                    ), 
                                         SizedBox(height:3),
                     Text("4. Expired vouchers will not be reissued or extended.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                    ), 
                                         SizedBox(height:3),
                     Text("5. Cannot be combined with other offers",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                    ), 
                                         SizedBox(height:3),
                     Text("6. The voucher can be redeemed via the official gym app or at the front desk.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                    ), 
                  ],
                )  
                ),
                const SizedBox(height: 150),
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