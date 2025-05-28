import 'package:flutter/material.dart';

class Posts extends StatefulWidget {
  final String username;
  final String userImage;
  final String postImage;
  final String caption;
  final String timeAgo;
  final int likes;
  final int comments;
  final int shares;

  const Posts({
    required this.username,
    required this.userImage,
    required this.postImage,
    required this.caption,
    required this.timeAgo,
    required this.likes,
    required this.comments,
    required this.shares,
    super.key,
  });

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  late int likeCount;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
  }

  void toggleLike() {
    setState(() {
      if (isLiked) {
        likeCount--;
        isLiked = false;
      } else {
        likeCount++;
        isLiked = true;
      }
    });
  }
Widget _buildOptionTile(IconData icon, String title) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: ListTile(
      dense: true,
      leading: Icon(icon, size: 22, color: Colors.black),
      title: Text(title, style: TextStyle(fontSize: 14)),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(widget.userImage),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.timeAgo,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.more_horiz,size: 25),
                onPressed:() {
                  showModalBottomSheet(
                    context: context,
                      builder: (context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.vertical(top:Radius.circular(20)),
                          child:Container(
                            color: Colors.grey[100],
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                           children: [
                            Container(
                              width: 40,
                              height: 5,
                              margin: EdgeInsets.only(bottom:15),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            
                            _buildOptionTile(Icons.bookmark_outline, 'Save'),
                            SizedBox(height: 10),
                            _buildOptionTile(Icons.star_outline, 'Add to Favourites'),
                            SizedBox(height: 10),
                            _buildOptionTile(Icons.person_outline, 'About this account'),
                            SizedBox(height: 10),
                            _buildOptionTile(Icons.hide_source, 'Hide'),
                            SizedBox(height: 10),
                          ], 
                          )
                          ),
                        );
                      },
                  );
                },
              ),
              
            ],
          ),

          SizedBox(height: 10),

          Text(widget.caption, style: TextStyle(fontSize: 12.5)),
          SizedBox(height: 10),

          SizedBox(
            height: 185, 
            width: 360,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                widget.postImage,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 6),

          Row(
            children: [
              GestureDetector(
                onTap: toggleLike,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.black,
                   size: 18,
                ),
              ),
              SizedBox(width: 4),
              Text('$likeCount', style: TextStyle(fontSize: 13)),
              SizedBox(width: 16),
              Icon(Icons.comment_outlined, size: 18),
              SizedBox(width: 4),
              Text('${widget.comments}', style: TextStyle(fontSize: 13)),
              SizedBox(width: 16),
              Icon(Icons.share_outlined, size: 18),
              SizedBox(width: 4),
              Text('${widget.shares}', style: TextStyle(fontSize: 11)),
            ],
          ),
          SizedBox(height: 10),

          Container(
            height: 36,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "comment on ${widget.username}'s post",
                      hintStyle: TextStyle(fontSize: 12),
                      contentPadding: EdgeInsets.only(bottom: 14),
                    ),
                  ),
                ),
                Icon(Icons.send, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
