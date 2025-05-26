

class Date{
  String day;
  String date;

  

  Date(
    {
      required this.day,
      required this.date
    }
  );

  static List <Date> getAllDate(){
    List <Date> dates = [];

    dates.add(
      Date(
        day: 'Mon', 
        date: '10'
      )
    );

    dates.add(
      Date(
        day: 'Tue', 
        date: '11'
      )
    );

    dates.add(
      Date(
        day: 'Wed', 
        date: '12'
      )
    );

    dates.add(
      Date(
        day: 'Thu', 
        date: '13'
      )
    );

    dates.add(
      Date(
        day: 'Fri', 
        date: '14'
      )
    );

    dates.add(
      Date(
        day: 'Sat', 
        date: '15'
      )
    );

    dates.add(
      Date(
        day: 'Sun', 
        date: '16'
      )
    );

    return dates;
  }
}