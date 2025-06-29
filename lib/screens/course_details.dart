class CourseDetails {
  String courseimage;
  String coursename;
  String videoUrl;
  String duration;
  String difficulty;
  String description;

  CourseDetails({
    required this.courseimage,
    required this.coursename,
    required this.videoUrl,
    required this.duration,
    required this.difficulty,
    required this.description,
  });

  static List<CourseDetails> getAllCourse() {
    return [
      CourseDetails(
        courseimage: 'assets/images/courses/Yoga.png',
        coursename: 'Mind-Body',
        videoUrl: 'assets/videos/YogaNew.mp4',
        duration: '18 min',
        difficulty: 'Medium',
        description: 'A balanced workout focusing on flexibility, breathing, and core strength.',
      ),
      CourseDetails(
      courseimage: 'assets/images/courses/Cardio.png',
      coursename: 'Cardio',
      videoUrl: 'assets/videos/CardioNew.mp4',
      duration: '25 min',
      difficulty: 'High',
      description:
          'A high-intensity cardio session designed to get your heart pumping and calories burning. Great for building endurance and stamina.',
    ),
    CourseDetails(
      courseimage: 'assets/images/courses/Yoga.jpg',
      coursename: 'Strength',
      videoUrl: 'assets/videos/YogaNew.mp4',
      duration: '30 min',
      difficulty: 'Medium',
      description:
          'A guided strength workout focusing on muscle building using body weight and optional dumbbells. Boosts metabolism and builds lean mass.',
    ),
    CourseDetails(
      courseimage: 'assets/images/courses/Yoga.jpg',
      coursename: 'Muay Thai',
      videoUrl: 'assets/videos/YogaNew.mp4',
      duration: '20 min',
      difficulty: 'Low',
      description:
          'A low-impact class that improves flexibility, builds strength, and develops control and endurance in the entire body. Focus on core stability.',
    ),
    CourseDetails(
      courseimage: 'assets/images/courses/Yoga.jpg',
      coursename: 'Ariel Yoga',
      videoUrl: 'assets/videos/YogaNew.mp4',
      duration: '20 min',
      difficulty: 'Low',
      description:
          'A low-impact class that improves flexibility, builds strength, and develops control and endurance in the entire body. Focus on core stability.',
    ),    
    ];
  }
}
