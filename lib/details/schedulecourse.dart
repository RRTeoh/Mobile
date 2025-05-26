

class Schedulecourse{
  String time;
  String duration;
  String title;
  String subtitle;
  double rating;
  

  Schedulecourse(
    {
      required this.time,
      required this.duration,
      required this.title,
      required this.subtitle,
      required this.rating
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
        rating: 4.0
      )

    );

    scourse.add(
      Schedulecourse(
        time: '10:00', 
        duration: '1hr', 
        title: 'Body Combat',
        subtitle: '10:00 am - 11:00 am',
        rating: 3.0
      )

    );

    scourse.add(
      Schedulecourse(
        time: '12:30', 
        duration: '45m', 
        title: 'Pilates',
        subtitle: '12:30 pm - 01:15 pm',
        rating: 5.0
      )

    );

    scourse.add(
      Schedulecourse(
        time: '13:20', 
        duration: '1hr', 
        title: 'Boxing for Beginners',
        subtitle: '13:20 pm - 14:20 pm',
        rating: 4.0
      )

    );

    scourse.add(
      Schedulecourse(
        time: '15:00', 
        duration: '1hr', 
        title: 'Boxing for Beginners',
        subtitle: '15:00 pm - 16:00 pm',
        rating: 3.0
      )

    );

    scourse.add(
      Schedulecourse(
        time: '15:30', 
        duration: '30m', 
        title: 'HIIT Burn',
        subtitle: '15:30 pm - 16:00 pm',
        rating: 4.0
      )

    );

    scourse.add(
      Schedulecourse(
        time: '16:10', 
        duration: '1hr', 
        title: 'Yoga',
        subtitle: '16:10 pm - 17:10 pm',
        rating: 5.0
      )

    );

    

    return scourse;
  }
}