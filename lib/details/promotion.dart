

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
        promoname: 'Premium 7-Days',
        )
    );

    promotion.add(
      Promotion(
        promoimage:'assets/images/promotion/member.png',
        promoname: 'Membership Upgrade',
        )
    );

    promotion.add(
      Promotion(
        promoimage:'assets/images/promotion/50%.jpg',
        promoname: '50% off Promotion',
        )
    );

    
    return promotion;
  }
}

