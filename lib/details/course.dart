

class Course{
  String courseimage;
  String coursename;
  

  Course(
    {
      required this.courseimage,
      required this.coursename
    }
  );

  static List <Course> getAllCourse(){
    List <Course> courses = [];

    courses.add(
      Course(
        courseimage:'assets/images/courses/Yoga.png',
        coursename: 'Mind-Body',
        )
    );

    courses.add(
      Course(
        courseimage:'assets/images/courses/Cardio.png',
        coursename: 'Cardio',
        )
    );

    courses.add(
      Course(
        courseimage:'assets/images/courses/Home-Gym.jpg',
        coursename: 'Strength',
        )
    );
    courses.add(
      Course(
        courseimage:'assets/images/courses/HIIT.jpg',
        coursename: 'Muay Thai',
        )
    );

    courses.add(
      Course(
        courseimage:'assets/images/courses/Kickboxing.jpg',
        coursename: 'Ariel Yoga',
        )
    );

    return courses;
  }
}

