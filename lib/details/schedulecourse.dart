

class Schedulecourse{
  String time;
  String duration;
  String title;
  String subtitle;
  double rating;
  String imagePath;
  String classmode;
  String teachername;
  String teacherimagepath;
  String date;
  String address;
  String description;

  

  Schedulecourse(
    {
      required this.time,
      required this.duration,
      required this.title,
      required this.subtitle,
      required this.rating,
      required this.imagePath,
      required this.classmode,
      required this.teachername,
      required this.teacherimagepath,
      required this.date,
      required this.address,
      required this.description

    }
  );

  static List <Schedulecourse> getAllSC(){
    List <Schedulecourse> scourse = [];

    scourse.add(
      Schedulecourse(
        time: '10:00', 
        duration: '1hr', 
        title: 'Body Balance',
        subtitle: '10:00 am - 11:00 am',
        rating: 4.0,
        imagePath: "assets/images/courses/Pilates.jpg",
        classmode: "physical",
        teachername: "Oliva Mitchell",
        teacherimagepath: "assets/images/Profile.png",
        date: "14 May 2025",
        address: "Mid Valley Megamall, Eko Cheras, Suria KLCC",
        description: "Join our Pilates class and experience a full-body workout that enhances strength, flexibility, and posture while promoting relaxation and mental clarity. Suitable for all fitness levels, our expert instructors will guide you through controlled, low-impact movements that engage your core, improve balance, and tone muscles without bulking up."
      )

    );

    scourse.add(
      Schedulecourse(
        time: '10:00', 
        duration: '1hr', 
        title: 'Body Combat',
        subtitle: '10:00 am - 11:00 am',
        rating: 3.0,
        imagePath: "assets/images/courses/Pilates.jpg",
        classmode: "physical",
        teachername: "Oliva Mitchell",
        teacherimagepath: "assets/images/Profile.png",
        date: "14 May 2025",
        address: "Mid Valley Megamall, Eko Cheras, Suria KLCC",
        description: "Join our Pilates class and experience a full-body workout that enhances strength, flexibility, and posture while promoting relaxation and mental clarity. Suitable for all fitness levels, our expert instructors will guide you through controlled, low-impact movements that engage your core, improve balance, and tone muscles without bulking up."
      )

    );

    scourse.add(
      Schedulecourse(
        time: '12:30', 
        duration: '45m', 
        title: 'Pilates',
        subtitle: '12:30 pm - 01:15 pm',
        rating: 5.0,
        imagePath: "assets/images/courses/Pilates.jpg",
        classmode: "physical",
        teachername: "Oliva Mitchell",
        teacherimagepath: "assets/images/Profile.png",
        date: "14 May 2025",
        address: "Mid Valley Megamall, Eko Cheras, Suria KLCC",
        description: "Join our Pilates class and experience a full-body workout that enhances strength, flexibility, and posture while promoting relaxation and mental clarity. Suitable for all fitness levels, our expert instructors will guide you through controlled, low-impact movements that engage your core, improve balance, and tone muscles without bulking up."
      )

    );

    scourse.add(
      Schedulecourse(
        time: '13:20', 
        duration: '1hr', 
        title: 'Boxing for Beginners',
        subtitle: '13:20 pm - 14:20 pm',
        rating: 4.0,
        imagePath: "assets/images/courses/Pilates.jpg",
        classmode: "physical",
        teachername: "Oliva Mitchell",
        teacherimagepath: "assets/images/Profile.png",
        date: "14 May 2025",
        address: "Mid Valley Megamall, Eko Cheras, Suria KLCC",
        description: "Join our Pilates class and experience a full-body workout that enhances strength, flexibility, and posture while promoting relaxation and mental clarity. Suitable for all fitness levels, our expert instructors will guide you through controlled, low-impact movements that engage your core, improve balance, and tone muscles without bulking up."
      )

    );

    scourse.add(
      Schedulecourse(
        time: '15:00', 
        duration: '1hr', 
        title: 'Boxing for Beginners',
        subtitle: '15:00 pm - 16:00 pm',
        rating: 3.0,
        imagePath: "assets/images/courses/Pilates.jpg",
        classmode: "physical",
        teachername: "Oliva Mitchell",
        teacherimagepath: "assets/images/Profile.png",
        date: "14 May 2025",
        address: "Mid Valley Megamall, Eko Cheras, Suria KLCC",
        description: "Join our Pilates class and experience a full-body workout that enhances strength, flexibility, and posture while promoting relaxation and mental clarity. Suitable for all fitness levels, our expert instructors will guide you through controlled, low-impact movements that engage your core, improve balance, and tone muscles without bulking up."
      )

    );

    scourse.add(
      Schedulecourse(
        time: '15:30', 
        duration: '30m', 
        title: 'HIIT Burn',
        subtitle: '15:30 pm - 16:00 pm',
        rating: 4.0,
        imagePath: "assets/images/courses/Pilates.jpg",
        classmode: "physical",
        teachername: "Oliva Mitchell",
        teacherimagepath: "assets/images/Profile.png",
        date: "14 May 2025",
        address: "Mid Valley Megamall, Eko Cheras, Suria KLCC",
        description: "Join our Pilates class and experience a full-body workout that enhances strength, flexibility, and posture while promoting relaxation and mental clarity. Suitable for all fitness levels, our expert instructors will guide you through controlled, low-impact movements that engage your core, improve balance, and tone muscles without bulking up."
      )

    );

    scourse.add(
      Schedulecourse(
        time: '16:10', 
        duration: '1hr', 
        title: 'Yoga',
        subtitle: '16:10 pm - 17:10 pm',
        rating: 5.0,
        imagePath: "assets/images/courses/Pilates.jpg",
        classmode: "physical",
        teachername: "Oliva Mitchell",
        teacherimagepath: "assets/images/Profile.png",
        date: "14 May 2025",
        address: "Mid Valley Megamall, Eko Cheras, Suria KLCC",
        description: "Join our Pilates class and experience a full-body workout that enhances strength, flexibility, and posture while promoting relaxation and mental clarity. Suitable for all fitness levels, our expert instructors will guide you through controlled, low-impact movements that engage your core, improve balance, and tone muscles without bulking up."
      )

    );

    

    return scourse;
  }
}