import 'package:flutter/material.dart';
import 'package:asgm1/details/course.dart';
import 'package:asgm1/details/promotion.dart';
import 'package:asgm1/details/date.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Course> courses = [];
  List<Promotion> promotion = [];
  List<Date> dates = [];

  @override
  Widget build(BuildContext context) {
    courses = Course.getAllCourse();
    promotion = Promotion.getAllPromo();
    dates = Date.getAllDate();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 123, 218, 248), 
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0),
            ),
            //Container(
              //decoration: BoxDecoration(
                //color: Colors.white,
                //shape: BoxShape.circle,
              //),
              //padding: EdgeInsets.all(5),
              //child: 
              Icon(
                Icons.list,
                color:Colors.black,
                size: 22,
                ),
            //),
            SizedBox(width: 8),
            //Container(
             // decoration: BoxDecoration(
                //color: Colors.white,
                //shape: BoxShape.circle,
              //),
              //padding: EdgeInsets.all(5),
              //child: 
              Icon(
                Icons.notifications,
                color: Colors.black,
                size: 22,
                ),
            //),
            SizedBox(width: 210),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            //   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 1),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(30),
            //   ),
            //   child: Row(
            //     children: [
            //       Icon(
            //         Icons.search,
            //         color: Colors.grey,
            //         size: 30
            //       ),
            //       SizedBox(width: 5),
            //       Text(
            //         "Search",
            //         style: TextStyle(
            //           color: Colors.grey,
            //           fontSize: 20
            //         )
            //       )
            //     ],
            //   )
            // ),
            SizedBox(width: 10),
            CircleAvatar(
                radius: 23,
                backgroundImage: AssetImage("assets/images/Profile.png"),
                
              ),
          ],
        )
      ),
      
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,   // start from top
            end: Alignment.bottomCenter,  // end at bottom
            colors: [
               const Color.fromARGB(255, 123, 218, 248),   // top color
               Colors.white,  // bottom color
            ],
            stops: [
              0.0, // sharp or not
              0.7, // blue part
            ],
          ),
        ),
        child: ListView(
          children: 
          [
            Padding(
          padding: EdgeInsets.only(left: 20, top:0, bottom:20), // right:30),
          child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Today",
              style: TextStyle(
                fontSize: 15, 
                fontWeight: FontWeight.bold,
                color: Colors.black),
            ),
            SizedBox(height:2),
            Text(
                "May 14, 2025",
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 12, 0, 143)
                ),
            ),
            SizedBox(height:10),
            Container(
              height: 200,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child:Column(
                children: [
                  Row(
                    children: [
                      //mon,tues,wed,thurs,fri,sat,sun
                      SizedBox(width:12),
                      Container(
                        margin:EdgeInsets.only(top: 30),
                        height: 85,
                        width: 38,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 233, 233),
                          borderRadius: BorderRadius.circular(75)
                        ),
                        child:Column(
                          children: [
                            Container(
                              margin:EdgeInsets.only(top: 15),
                              child: Text(
                                //dates[index].day, 
                                "Mon",
                                style: TextStyle(
                                  fontSize:13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            ),
                            SizedBox(height:15),
                            Container(
                              height:30,
                              width:30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(7),
                              child: Text(
                                "10",
                                //dates[index].date,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            )
                          ],
                        )
                        ),
                      SizedBox(width:5),
                      Container(
                        margin:EdgeInsets.only(top: 30),
                        height: 85,
                        width: 38,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 233, 233),
                          borderRadius: BorderRadius.circular(75)
                        ),
                        child:Column(
                          children: [
                            Container(
                              margin:EdgeInsets.only(top: 15),
                              child: Text(
                                "Tue",
                                style: TextStyle(
                                  fontSize:13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            ),
                            SizedBox(height:15),
                            Container(
                              height:30,
                              width:30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(7),
                              child: Text(
                                "11",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            )
                          ],
                        )
                      ),
                      SizedBox(width:5),
                      Container(
                        margin:EdgeInsets.only(top: 30),
                        height: 85,
                        width: 38,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 233, 233),
                          borderRadius: BorderRadius.circular(75)
                        ),
                        child:Column(
                          children: [
                            Container(
                              margin:EdgeInsets.only(top: 15),
                              child: Text(
                                "Wed",
                                style: TextStyle(
                                  fontSize:13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            ),
                            SizedBox(height:15),
                            Container(
                              height:30,
                              width:30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(7),
                              child: Text(
                                "12",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            )
                          ],
                        )
                      ),
                      SizedBox(width:5),
                      Container(
                        margin:EdgeInsets.only(top: 30),
                        height: 85,
                        width: 38,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 233, 233),
                          borderRadius: BorderRadius.circular(75)
                        ),
                        child:Column(
                          children: [
                            Container(
                              margin:EdgeInsets.only(top: 15),
                              child: Text(
                                "Thu",
                                style: TextStyle(
                                  fontSize:13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            ),
                            SizedBox(height:15),
                            Container(
                              height:30,
                              width:30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(7),
                              child: Center(
                              child: Text(
                                "13",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                              )
                            )
                          ],
                        )
                      ),
                      SizedBox(width:5),
                      Container(
                        margin:EdgeInsets.only(top: 30),
                        height: 85,
                        width: 38,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 12, 0, 143),
                          borderRadius: BorderRadius.circular(75)
                        ),
                        child:Column(
                          children: [
                            Container(
                              margin:EdgeInsets.only(top: 15),
                              child: Text(
                                "Fri",
                                style: TextStyle(
                                  fontSize:13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                )
                              )
                            ),
                            SizedBox(height:15),
                            Container(
                              height:30,
                              width:30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(7),
                              child: Text(
                                "14",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            )
                          ],
                        )
                      ),
                      SizedBox(width:5),
                      Container(
                        margin:EdgeInsets.only(top: 30),
                        height: 85,
                        width: 38,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 233, 233),
                          borderRadius: BorderRadius.circular(75)
                        ),
                        child:Column(
                          children: [
                            Container(
                              margin:EdgeInsets.only(top: 15),
                              child: Text(
                                "Sat",
                                style: TextStyle(
                                  fontSize:13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            ),
                            SizedBox(height:15),
                            Container(
                              height:30,
                              width:30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(7),
                              child: Text(
                                "15",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            )
                          ],
                        )
                      ),
                      SizedBox(width:5),
                      Container(
                        margin:EdgeInsets.only(top: 30),
                        height: 85,
                        width: 38,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 233, 233),
                          borderRadius: BorderRadius.circular(75)
                        ),
                        child:Column(
                          children: [
                            Container(
                              margin:EdgeInsets.only(top: 15),
                              child: Text(
                                "Sun",
                                style: TextStyle(
                                  fontSize:13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            ),
                            SizedBox(height:15),
                            Container(
                              height:30,
                              width:30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(7),
                              child: Text(
                                "16",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      //25%,calories,reminder
                      Container(
                        margin:EdgeInsets.only(left: 10,top:15),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage("assets/images/25%.png"),
                            fit: BoxFit.cover
                            )
                        ),
                      ),
                      SizedBox(width:10),
                      Container(
                        margin:EdgeInsets.only(top:15),
                        height:60,
                        width:60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 214,233,249),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 18),
                              Text(
                                "160kcal ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              ),
                              Text(
                                "Remaining",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              ),
                            ],
                          )
                        )
                      ),
                      SizedBox(width:10),
                      Container(
                        margin:EdgeInsets.only(top:15),
                        height:60,
                        width:160,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 214,233,249),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children:[
                            SizedBox(height:5),
                            Text(
                              "Upcoming Schedule:",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              )
                            ),
                            SizedBox(height:10),
                            Row(
                              children: 
                              [
                                SizedBox(width:10),
                                Text(
                                  "12:00 p.m.",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                  )
                                ),
                                SizedBox(width:15),
                                Text(
                                  "Yoga Class",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                  )
                                )
                              ],
                            )
                          ]
                        )
                      ),
                    ],
                  )
                ],
            )
            ),
            SizedBox(height:20),
            Text(
              "Sports You May Like",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black
              )
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
              Row(
              children: [
                SizedBox(width:10),
                //list of sports you may like
                Container(
                  margin:EdgeInsets.only(top:10,bottom:10),
                  height:27,
                  width:60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(0,2)
                      )
                    ]
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Archery",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      //fontWeight: FontWeight.bold,
                      color: Colors.black
                    )
                  )
                ),
                SizedBox(width:10),
                Container(
                  margin:EdgeInsets.only(top:10,bottom:10),
                  height:27,
                  width:60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(0,2)
                      )
                    ]
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Curling",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      //fontWeight: FontWeight.bold,
                      color: Colors.black
                    )
                  )
                ),
                SizedBox(width:10),
                Container(
                  margin:EdgeInsets.only(top:10,bottom:10),
                  height:27,
                  width:60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(0,2)
                      )
                    ]
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Kabaddi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      //fontWeight: FontWeight.bold,
                      color: Colors.black
                    )
                  )
                ),
                SizedBox(width:10),
                Container(
                  margin:EdgeInsets.only(top:10,bottom:10),
                  height:27,
                  width:97,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(0,2)
                      )
                    ]
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Rock Climbing",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      //fontWeight: FontWeight.bold,
                      color: Colors.black
                    )
                  )
                ),
                SizedBox(width:10),
                Container(
                  margin:EdgeInsets.only(top:10,bottom:10),
                  height:27,
                  width:60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(0,2)
                      )
                    ]
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Parkour",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      //fontWeight: FontWeight.bold,
                      color: Colors.black
                    )
                  )
                ),
                SizedBox(width:10)
              ],
            ),
            ),
            
            SizedBox(height:20),
            Text(
              "Courses",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
              )
            ),
            SizedBox(
              height: 175,
              //width: 150, // set height to show items horizontally
              child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: courses.length,
              itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                  height: 175,
                  width: 150,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 214,233,249),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin:EdgeInsets.only(top:10),
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: 
                          DecorationImage(
                            image: AssetImage(courses[index].courseimage),
                            fit: BoxFit.cover
                            )
                        ),
                      ),
                      Container(
                        margin:EdgeInsets.only(top:5),
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          courses[index].coursename,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            //fontWeight: FontWeight.bold
                         )
                       )
                      ),
                    ]
                  )
                );
              },
              ),
            ),
                
            
            SizedBox(height:10),
            Text(
              "Promotion",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
              )
            ),

            SizedBox(
              height: 175,
              //width: 150, // set height to show items horizontally
              child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: promotion.length,
              itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                  height: 175,
                  width: 150,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 214,233,249),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin:EdgeInsets.only(top:10),
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: 
                          DecorationImage(
                            image: AssetImage(promotion[index].promoimage),
                            fit: BoxFit.cover
                            )
                        ),
                      ),
                      Container(
                        margin:EdgeInsets.only(top:5, left:5, right:5),
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          promotion[index].promoname,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            //fontWeight: FontWeight.bold
                         )
                       )
                      ),
                    ]
                  )
                );
              },
              ),
            ),
           ],//final
            ),
          )

          ]
        )
        ),
    );
  }
}
