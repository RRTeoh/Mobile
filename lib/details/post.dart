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
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  void _showCommentPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return Column(
                children: [
                  // Handle bar and title
                  Container(
                    width: 40,
                    height: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text("Comments", style: TextStyle(fontWeight: FontWeight.bold)),
                  
                  // Comment list
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key('comment_$index'),
                          direction: DismissDirection.endToStart,
                          background: slideActions(),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(widget.userImage),
                            ),
                            title: RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: "user_$index ",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: "This is a sample comment."),
                                ],
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text("Reply", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                SizedBox(width: 10),
                                Text("Message", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            trailing: Icon(Icons.favorite_border, size: 18),
                          ),
                        );
                      },
                    ),
                  ),

                  // Comment input only (no emoji bar)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Add a comment...",
                                border: InputBorder.none,
                                isCollapsed: true,
                              ),
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.send, size: 22, color: Colors.blue),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget slideActions() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 15),
      color: Colors.redAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.grey[800], shape: BoxShape.circle),
            child: Icon(Icons.edit, color: Colors.white, size: 16),
          ),
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            child: Icon(Icons.delete, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
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
          // Top bar
          Row(
            children: [
              CircleAvatar(radius: 20, backgroundImage: AssetImage(widget.userImage)),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.username, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.timeAgo, style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        child: Container(
                          color: Colors.grey[100],
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 5,
                                margin: EdgeInsets.only(bottom: 15),
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
                            ],
                          ),
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
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(widget.postImage, fit: BoxFit.cover),
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
              GestureDetector(
                onTap: _showCommentPanel,
                child: Icon(Icons.comment_outlined, size: 18),
              ),
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
