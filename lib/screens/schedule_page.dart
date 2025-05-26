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
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      padding: const EdgeInsets.all(10),
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
                        const SizedBox(height: 20),
                        
                      ],
                   )
                 ),
                    
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
                                      color: Colors.cyan,
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.add, 
                                        color: Colors.white,
                                        size: 20,
                                        ),
                                      onPressed: () {
                                      // Handle add action
                                      },
                                    ),
                                  ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ): const Text(
                          "No results found. Please try with different search",
                          style: TextStyle(fontSize: 22),
                        )
                       )
      //Center(child: Text("Schedule Page Content")),
    );
  }
}
