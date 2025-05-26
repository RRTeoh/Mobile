

class Promotion{
  String promoimage;
  String promoname;
  

  Promotion(
    {
      required this.promoimage,
      required this.promoname
    }
  );

  static List <Promotion> getAllPromo(){
    List <Promotion> promotion = [];

    promotion.add(
      Promotion(
        promoimage:'assets/images/promotion/premium.jpg',
        promoname: 'Premium for 7 Days Free!',
        )
    );

    promotion.add(
      Promotion(
        promoimage:'assets/images/promotion/member.png',
        promoname: 'Upgrade your gym membership card now!',
        )
    );

    promotion.add(
      Promotion(
        promoimage:'assets/images/promotion/50%.jpg',
        promoname: 'Enjoy 50% off for 3 days!',
        )
    );

    
    return promotion;
  }
}

