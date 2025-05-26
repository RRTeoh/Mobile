

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
        coursename: 'Yoga',
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
        coursename: 'Gym',
        )
    );

    courses.add(
      Course(
        courseimage:'assets/images/courses/Pilates.jpg',
        coursename: 'Pilates',
        )
    );

    courses.add(
      Course(
        courseimage:'assets/images/courses/HIIT.jpg',
        coursename: 'HIIT',
        )
    );

    courses.add(
      Course(
        courseimage:'assets/images/courses/Kickboxing.jpg',
        coursename: 'Kickboxing',
        )
    );

    return courses;
  }
}

