

class Schedulecourse{
  String time;
  String duration;
  String title;
  String subtitle;
  //String rating;
  

  Schedulecourse(
    {
      required this.time,
      required this.duration,
      required this.title,
      required this.subtitle,
      //required this.rating
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
        //rating: ''
      )

    );

    scourse.add(
      Schedulecourse(
        time: '10:00', 
        duration: '1hr', 
        title: 'Body Combat',
        subtitle: '10:00 am - 11:00 am',
        //rating: ''
      )

    );

    scourse.add(
      Schedulecourse(
        time: '12:30', 
        duration: '45mins', 
        title: 'Pilates',
        subtitle: '12:30 pm - 01:15 pm',
        //rating: ''
      )

    );

    scourse.add(
      Schedulecourse(
        time: '13:20', 
        duration: '1hr', 
        title: 'Boxing for Beginners',
        subtitle: '13:20 pm - 14:20 pm',
        //rating: ''
      )

    );

    scourse.add(
      Schedulecourse(
        time: '15:00', 
        duration: '1hr', 
        title: 'Boxing for Beginners',
        subtitle: '15:00 pm - 16:00 pm',
        //rating: ''
      )

    );

    scourse.add(
      Schedulecourse(
        time: '15:30', 
        duration: '30mins', 
        title: 'HIIT Burn',
        subtitle: '15:30 am - 16:00 am',
        //rating: ''
      )

    );

    scourse.add(
      Schedulecourse(
        time: '16:10', 
        duration: '1hr', 
        title: 'Yoga',
        subtitle: '16:10 am - 17:10 am',
        //rating: ''
      )

    );

    

    return scourse;
  }
}