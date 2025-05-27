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
              Icon(Icons.more_horiz,size: 25),
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
