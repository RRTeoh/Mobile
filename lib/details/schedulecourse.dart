import 'dart:math';

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
        imagePath: "assets/images/courses/BodyBalance.jpg",
        classmode: "physical",
        teachername: "Oliva Mitchell",
        teacherimagepath: "assets/images/trainers/Trainer6.jpg",
        date: "28 June 2025",
        address: "Mid Valley Megamall, Eko Cheras, Suria KLCC",
        description: "Join our Body Balance class and enjoy a holistic workout that combines yoga, tai chi, and Pilates to improve flexibility, core strength, and balance. With calming music and mindful movements, this low-impact class helps reduce stress, enhance posture, and bring harmony to body and mind—perfect for all fitness levels."
      )
    );

    scourse.add(
      Schedulecourse(
        time: '10:00', 
        duration: '1hr', 
        title: 'Body Combat',
        subtitle: '10:00 am - 11:00 am',
        rating: 3.0,
        imagePath: "assets/images/courses/BodyCombat.jpg",
        classmode: "physical",
        teachername: "Lena Graves",
        teacherimagepath: "assets/images/trainers/Trainer5.jpg",
        date: "1 July 2025",
        address: "Jalan Metro Prima 5, Kepong, 52100 Kuala Lumpur",
        description: "Unleash your inner warrior with Body Combat—a high-energy cardio workout inspired by martial arts like boxing, kickboxing, and Muay Thai. Set to powerful music, this non-contact class boosts endurance, tones your body, and helps you burn serious calories, all while building confidence and having fun."
      )

    );

    scourse.add(
      Schedulecourse(
        time: '3:00', 
        duration: '45m', 
        title: 'Pilates',
        subtitle: '3:00pm - 3:45pm',
        rating: 5.0,
        imagePath: "assets/images/courses/Pilates.jpg",
        classmode: "physical",
        teachername: "Ivy Monroe",
        teacherimagepath: "assets/images/trainers/Trainer7.jpg",
        date: "27 June 2025",
        address: "Jalan Kuchai Lama, 58200 Kuala Lumpur",
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
        imagePath: "assets/images/courses/Boxing.jpg",
        classmode: "physical",
        teachername: "Lin Xinyi",
        teacherimagepath: "assets/images/trainers/Trainer2.jpg",
        date: "27 June 2025",
        address: "Jalan Bukit Pantai, Bangsar, 59100 Kuala Lumpur",
        description: "Step into the ring with confidence in our Boxing for Beginners class, where you'll learn basic punches, footwork, and defensive moves in a supportive setting. This fun, full-body workout builds strength, coordination, and endurance while relieving stress—no prior experience needed!"
      )

    );

    scourse.add(
      Schedulecourse(
        time: '15:00', 
        duration: '1hr', 
        title: 'Boxing for Beginners',
        subtitle: '15:00 pm - 16:00 pm',
        rating: 3.0,
        imagePath: "assets/images/courses/Boxing.jpg",
        classmode: "physical",
        teachername: "Zoe Blake",
        teacherimagepath: "assets/images/trainers/Trainer4.jpg",
        date: "14 July 2025",
        address: "Jalan Sentul Bahagia, 51000 Kuala Lumpur",
        description: "Step into the ring with confidence in our Boxing for Beginners class, where you'll learn basic punches, footwork, and defensive moves in a supportive setting. This fun, full-body workout builds strength, coordination, and endurance while relieving stress—no prior experience needed!"
      )

    );

    scourse.add(
      Schedulecourse(
        time: '15:30', 
        duration: '30m', 
        title: 'HIIT Burn',
        subtitle: '15:30 pm - 16:00 pm',
        rating: 4.0,
        imagePath: "assets/images/courses/HIIT.jpg",
        classmode: "physical",
        teachername: "Thomas Hayes",
        teacherimagepath: "assets/images/trainers/Trainer3.jpg",
        date: "30 July 2025",
        address: "Jalan Setapak Indah 2, 53300 Kuala Lumpur",
        description: "Push your limits in our HIIT Burn class—a dynamic, high-intensity workout featuring short bursts of cardio and strength exercises. Designed to maximize calorie burn and build lean muscle in less time, this class is perfect for anyone looking to challenge themselves, boost metabolism, and stay motivated."
      )

    );

    scourse.add(
      Schedulecourse(
        time: '16:10', 
        duration: '1hr', 
        title: 'Yoga',
        subtitle: '16:10 pm - 17:10 pm',
        rating: 5.0,
        imagePath: "assets/images/courses/Yoga.png",
        classmode: "physical",
        teachername: "Axel Thorn",
        teacherimagepath: "assets/images/trainers/Trainer1.jpg",
        date: "11 June 2025",
        address: "Jalan Damai Perdana, 56000 Kuala Lumpur",
        description: "Find your balance with our Yoga class, designed to increase flexibility, build strength, and enhance mental focus through guided poses and breathwork. Whether you're a beginner or experienced, this practice supports relaxation, body awareness, and overall well-being in a calm and inclusive environment."
      )

    );
    

    return scourse;
  }

  static void updateAllDatesAndTimes(List<Schedulecourse> courses) {
    final now = DateTime.now();
    final rand = Random();
    for (var course in courses) {
      // Random day within next 14 days
      final daysToAdd = rand.nextInt(14);
      final newDate = now.add(Duration(days: daysToAdd));
      course.date = _formatDate(newDate);
      // Random time between 8:00 and 20:00
      final hour = 8 + rand.nextInt(13); // 8 to 20
      final minuteOptions = [0, 10, 15, 20, 30, 40, 45, 50];
      final minute = minuteOptions[rand.nextInt(minuteOptions.length)];
      final end = DateTime(newDate.year, newDate.month, newDate.day, hour, minute)
        .add(_parseDuration(course.duration));
      course.time = _formatTime(hour, minute);
      course.subtitle = '${_formatTime(hour, minute, ampm: true)} - ${_formatTime(end.hour, end.minute, ampm: true)}';
    }
  }

  static String _formatDate(DateTime date) {
    final months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month]} ${date.year}';
  }

  static String _formatTime(int hour, int minute, {bool ampm = false}) {
    if (ampm) {
      final h = hour > 12 ? hour - 12 : hour;
      final period = hour >= 12 ? 'pm' : 'am';
      return '${h.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}$period';
    } else {
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }
  }

  static Duration _parseDuration(String duration) {
    // Supports '1hr', '45m', '30m', etc.
    if (duration.contains('hr')) {
      final h = int.tryParse(duration.split('hr')[0].trim()) ?? 1;
      return Duration(hours: h);
    } else if (duration.contains('m')) {
      final m = int.tryParse(duration.split('m')[0].trim()) ?? 30;
      return Duration(minutes: m);
    }
    return Duration(hours: 1);
  }
}