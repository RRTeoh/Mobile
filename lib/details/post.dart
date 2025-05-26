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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top user row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(widget.userImage),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.timeAgo,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.more_horiz),
            ],
          ),

          SizedBox(height: 10),

          Text(widget.caption, style: TextStyle(fontSize: 14)),
          SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              widget.postImage,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),

          Row(
            children: [
              GestureDetector(
                onTap: toggleLike,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.black,
                ),
              ),
              SizedBox(width: 5),
              Text('$likeCount'),
              SizedBox(width: 20),
              Icon(Icons.comment_outlined),
              SizedBox(width: 5),
              Text('${widget.comments}'),
              SizedBox(width: 20),
              Icon(Icons.share_outlined),
              SizedBox(width: 5),
              Text('${widget.shares}'),
            ],
          ),
          SizedBox(height: 10),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "comment on ${widget.username}'s post",
                    ),
                  ),
                ),
                Icon(Icons.send),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
