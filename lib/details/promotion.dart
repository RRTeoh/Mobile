

class Promotion{
  String promoimage;
  String promoname;
  String description; 

  Promotion(
    {
      required this.promoimage,
      required this.promoname,
      required this.description,
    }
  );

  static List <Promotion> getAllPromo(){
    List <Promotion> promotion = [];

    promotion.add(
      Promotion(
        promoimage:'assets/images/services/fitnessassessment.jpg',
        promoname: 'Fitness assessment',
        description: "Measure your progress with strength tests and body composition scans.",
        )
    );

    promotion.add(
      Promotion(
        promoimage:'assets/images/services/groupfitness.jpg',
        promoname: 'Group fitness',
        description: "Join fun and energetic group classes like Zumba, Yoga, and HIIT led by experts.",

        )
    );

    promotion.add(
      Promotion(
        promoimage:'assets/images/services/nutritionconsult.jpg',
        promoname: 'Nutrition consult',
        description: "Get personalized diet plans and tips from our in-house nutritionists.",

        )
    );
    promotion.add(
      Promotion(
        promoimage:'assets/images/services/personaltraining.jpg',
        promoname: 'Personal training',
        description: "One-on-one coaching tailored to your fitness goals, guided by certified trainers.",

        )
    );
    
    return promotion;
  }
}
