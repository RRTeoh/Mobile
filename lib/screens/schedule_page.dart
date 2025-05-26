import 'package:flutter/material.dart';
import 'package:asgm1/details/schedulecourse.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SearchCourse extends StatefulWidget
{
  const SearchCourse ({super.key});

  @override
  State<SearchCourse> createState() => _SearchCourseState();
  
}

class _SearchCourseState extends State<SearchCourse>
{
  final List<Schedulecourse> _allCourse = Schedulecourse.getAllSC();
  List<Schedulecourse> _foundCourse =[];
  Set<int> addedCourseIndices = {};

  String buttonText = "+ Add to my schedule";

  @override

  void initState()
  {
    _foundCourse = _allCourse;
    super.initState();
  }

  void _runFilter(String enteredKeyword)
  {
    List<Schedulecourse> results = [];
    if(enteredKeyword.isEmpty)
    {
      results = _allCourse;
    }else
    {
      results = _allCourse
      .where((scourse)=>
      scourse.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
      .toList();
    }

    setState(() {
      _foundCourse = results;
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250), // Custom height
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topLeft,
                colors: [
                  const Color.fromARGB(255, 123, 218, 248),
                  Colors.white,
                ],
                //stops: [
                 // 0.0, // sharp or not
                 // 0.9, // blue part
                //],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(left:20, right:20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height:5),
                    Row(
                      children: [
                        Icon(Icons.filter_alt, color: Colors.black, size: 20),
                        SizedBox(width: 8),
                        Icon(Icons.notifications, color: Colors.black, size: 20),
                        SizedBox(width: 115),
                        Text(
                          "Gym Schedule",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 12, 0, 143)
                          )
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                         TextField(
                          onChanged: (value) => _runFilter(value),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: 
                            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                            hintText: "Search",
                            suffixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )
                          ),
                        ),
                        
                      ],
                   )
                 ),
                    const SizedBox(height: 20),
                        Center(

                          child: Text(
                          "May 2025",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                          )
                        ),
                        ),
                        //const SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.all(19),
                          child:Row(
                          children: 
                          [
                            Column(
                              children: 
                              [
                                Text(
                                  "Mon",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:10),
                                  child: Text(
                                  "10",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                  )
                                )
                              ],
                            ),
                            SizedBox(width:17),
                            Column(
                              children: 
                              [
                                Text(
                                  "Tue",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:10),
                                  child: Text(
                                  "11",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                  )
                                )
                              ],
                            ),
                            SizedBox(width:17),
                            Column(
                              children: 
                              [
                                Text(
                                  "Wed",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:10),
                                  child: Text(
                                  "12",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                  )
                                )
                              ],
                            ),
                            SizedBox(width:17),
                            Column(
                              children: 
                              [
                                Text(
                                  "Thu",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:10),
                                  child: Text(
                                  "13",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                  )
                                )
                              ],
                            ),
                            SizedBox(width:17),
                            Column(
                              children: 
                              [
                                Text(
                                  "Fri",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                ),
                                //SizedBox(height: 5),
                                Padding(
                                  padding: EdgeInsets.only(top:10),
                                  child: Text(
                                  "14",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                  ),
                                  )
                                )
                              ],
                            ),
                            SizedBox(width:17),
                            Column(
                              children: 
                              [
                                Text(
                                  "Sat",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                ),
                                //SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.only(top:10),
                                  child: Text(
                                  "15",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                  )
                                )
                              ],
                            ),
                            SizedBox(width:17),
                            Column(
                              children: 
                              [
                                Text(
                                  "Sun",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:10),
                                  child: Text(
                                  "16",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                  )
                                )
                              ],
                            )
                          ],
                        )
                        )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Expanded(
                        child: _foundCourse.isNotEmpty
                        ? ListView.builder(
                          itemCount: _foundCourse.length,
                          itemBuilder: (context, index) => Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                // Left Side
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _foundCourse[index].time,
                                            //'10:00',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 12, 0, 143),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          padding: EdgeInsets.only(left:15),
                                          child:Text(
                                        //'1hr',
                                          _foundCourse[index].duration,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ), 
                                        )
                                      ],
                                   ),
                                  SizedBox(width: 16),

                                  // Middle
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          //'BODY BALANCE',
                                          _foundCourse[index].title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time, size: 14, color: Colors.grey),
                                            SizedBox(width: 4),
                                            Text(
                                              //'10:00 am - 11:00 am',
                                              _foundCourse[index].subtitle,
                                                style: TextStyle(fontSize: 13, color: Colors.grey),
                                            ),
                                            ],
                                        ),
                                        SizedBox(height: 4),
                                        RatingBar.builder(
                                          initialRating: _foundCourse[index].rating.toDouble(),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          itemSize: 20,
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.yellow
                                            ),
                                          onRatingUpdate: (double value) { },
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Right side (+ button)
                                  Padding(
                                    padding: EdgeInsets.only(top: 50), // Pushes the whole circle down
                                      child:Container(
                                      height: 30,
                                      width: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: addedCourseIndices.contains(index) ?Colors.green: Colors.cyan,
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        addedCourseIndices.contains(index) ?Icons.check:Icons.add, 
                                        color: Colors.white,
                                        size: 20,
                                        ),
                                      onPressed: () {
                                        Schedulecourse course = _foundCourse[index];
                                      // Handle add action
                                      showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: Container(
                                  height: 500,
                                  padding: const EdgeInsets.only(left:20),
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //const SizedBox(height: 40),
                                          Row(
                                            children: [
                                              Text(
                                                course.title,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                                )
                                              ),
                                              SizedBox(width:10),
                                              Container(
                                              margin:EdgeInsets.only(top:10,bottom:10),
                                                height:25,
                                                width:60,
                                                  decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 218, 218, 218),
                                                  borderRadius: BorderRadius.circular(15),
                                                  
                                              ),
                                              padding: EdgeInsets.all(5),
                                                child: Text(
                                                  course.classmode,
                                                  textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black
                                                    )
                                                )
                                              ),
                                            ],
                                          ),
                                                Padding(
                                                  padding: EdgeInsets.only(right:20),
                                                  child:Container(
                                                  height: 200,
                                                  width: 350,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    image: 
                                                    DecorationImage(
                                                    image: AssetImage(course.imagePath),
                                                    fit: BoxFit.cover
                                                  )
                                                  ),
                                                ),
                                                ),
                                                const SizedBox(height:15),
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 23,
                                                      backgroundImage: AssetImage(course.teacherimagepath),
                                                    ),
                                                    SizedBox(width:10),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Trainer",
                                                          textAlign: TextAlign.left,
                                                          style:TextStyle(
                                                            fontSize: 10,
                                                            color:Colors.grey
                                                          )
                                                        ),
                                                        Text(
                                                          course.teachername,
                                                          textAlign: TextAlign.left,
                                                          style:TextStyle(
                                                            fontSize: 15,
                                                            color:Colors.black
                                                          )
                                                        ),
                                                        RatingBar.builder(
                                                        initialRating: course.rating.toDouble(),
                                                        minRating: 1,
                                                        direction: Axis.horizontal,
                                                        itemSize: 10,
                                                        itemBuilder: (context, _) => const Icon(
                                                        Icons.star,
                                                        color: Colors.yellow
                                                        ),
                                                        onRatingUpdate: (double value) { },
                                                        ),
                                                      ],
                                                    )

                                                  ]
                                                ),
                                                SizedBox(height:10),
                                                Padding(
                                                  padding: EdgeInsets.only(left:10),
                                                  child:Column(
                                                  children: 
                                                  [
                                                    Row(
                                                    children:[Icon(Icons.access_time, size: 14, color: Colors.grey),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      course.subtitle,
                                                      style: TextStyle(fontSize: 10, color: Colors.black),
                                                    ),
                                                    ]
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                    children:[Icon(Icons.calendar_month, size: 14, color: Colors.red),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      course.date,
                                                      style: TextStyle(fontSize: 10, color: Colors.black),
                                                    ),
                                                    ]
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                    children:[Icon(Icons.location_on, size: 14, color: Colors.blue),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      course.address,
                                                      style: TextStyle(fontSize: 10, color: Colors.black),
                                                    ),
                                                    ]
                                                    ),
                                                    SizedBox(height:10),
                                                    Padding(
                                                      padding: EdgeInsets.only(right:20),
                                                      child:Text(
                                                      course.description,
                                                      textAlign: TextAlign.justify,
                                                      style: TextStyle(
                                                        fontSize: 8,
                                                        color: Colors.black
                                                      )
                                                    )
                                                    ),
                                                    SizedBox(height:10),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                      backgroundColor: addedCourseIndices.contains(index)
                                                      ? Colors.greenAccent.shade200
                                                      : const Color.fromARGB(255, 22, 45, 180),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          addedCourseIndices.add(index); // mark this item as added
                                                        });  
                                                      },
                                                      child: Text(
                                                        addedCourseIndices.contains(index) ? "Added" : "+ Add to my schedule",
                                                        
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          
                                                          color: addedCourseIndices.contains(index) ?Colors.black :Colors.white,
                                                        ),
                                                      ),
                                                          ),
          
                                                  ],),
                                                )
                                              ],
                                            ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                                    )
                                      
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ): const Text(
                          "No results found. Please try with different search",
                          style: TextStyle(fontSize: 22),
                        )
                       )
    );
  }
}
