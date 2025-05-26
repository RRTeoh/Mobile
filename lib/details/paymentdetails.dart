
class PaymentDetails{
  String date;
  String time;
  String name;
  String amount;

  PaymentDetails({
    required this.date,
    required this.time,
    required this.name,
    required this.amount
  });

  static List <PaymentDetails> getallDetails(){
    List <PaymentDetails> paymentdetails = [];

    paymentdetails.add(
      PaymentDetails(
        date: "1 June",
        time: "11:14",
        name: "Membership Subscription",
        amount: "- RM 50"),
    );

    paymentdetails.add(
      PaymentDetails(
        date: "15 May",
        time: "5:00",
        name: "Tabata Workshop",
        amount: "- RM 100"),
    );

    paymentdetails.add(
      PaymentDetails(
        date: "29 April",
        time: "12:34",
        name: "Healthy Bento",
        amount: "- RM 12"),
    );
    paymentdetails.add(
      PaymentDetails(
        date: "28 April",
        time: "10:00",
        name: "Healthy Smoothie",
        amount: "- RM 15"),
    );
    paymentdetails.add(
      PaymentDetails(
        date: "1 April",
        time: "12:34",
        name: "Membership Subscription",
        amount: "- RM 50"),
    );        
    return paymentdetails;
  }
}