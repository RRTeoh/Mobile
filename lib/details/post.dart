import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Posts extends StatefulWidget {
  final String username;
  final String userImage;
  final String postImage;
  final String caption;
  final String timeAgo;
  final int initialLikes;
  final String currentUserId;
  final String currentUserName;
  final String currentUserAvatar;
  final String postOwnerId;
  final String postId;

  const Posts({
    required this.username,
    required this.userImage,
    required this.postImage,
    required this.caption,
    required this.timeAgo,
    required this.initialLikes,
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserAvatar,
    required this.postOwnerId,
    required this.postId,
    super.key,
  });

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  int likeCount = 0;
  bool isLiked = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialLikeState();
  }

  void _loadInitialLikeState() async {
    final postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.postOwnerId)
        .collection('posts')
        .doc(widget.postId);

    final postSnap = await postRef.get();
    if (postSnap.exists) {
      setState(() {
        likeCount = postSnap['likes'] ?? 0;
      });
    }

    final likeSnap = await postRef.collection('likes').doc(widget.currentUserId).get();
    if (likeSnap.exists) {
      setState(() {
        isLiked = true;
      });
    }
  }

  void toggleLike() async {
    final postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.postOwnerId)
        .collection('posts')
        .doc(widget.postId);

    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });

    if (isLiked) {
      await postRef.update({'likes': FieldValue.increment(1)});
      await postRef.collection('likes').doc(widget.currentUserId).set({
        'likedAt': FieldValue.serverTimestamp(),
      });

      if (widget.currentUserId != widget.postOwnerId) {
        _sendNotification("liked your post.");
      }
    } else {
      await postRef.update({'likes': FieldValue.increment(-1)});
      await postRef.collection('likes').doc(widget.currentUserId).delete();
    }
  }

  void _submitComment() async {
    String comment = _commentController.text.trim();
    if (comment.isEmpty) return;

    final postRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.postOwnerId)
        .collection('posts')
        .doc(widget.postId);

    await postRef.collection('comments').add({
      'user': widget.currentUserName,
      'avatar': widget.currentUserAvatar,
      'comment': comment,
      'time': FieldValue.serverTimestamp(),
    });

    _commentController.clear();

    if (widget.currentUserId != widget.postOwnerId) {
      _sendNotification("commented on your post.");
    }
  }

  void _sendNotification(String action) {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(widget.postOwnerId)
        .collection('notifications')
        .add({
      'user': widget.currentUserName,
      'avatar': widget.currentUserAvatar,
      'action': action,
      'time': FieldValue.serverTimestamp(),
      'preview': widget.postImage,
      'read': false,
    });
  }

  void _showCommentPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder: (_, scrollController) {
              return Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const Text("Comments", style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.postOwnerId)
                          .collection('posts')
                          .doc(widget.postId)
                          .collection('comments')
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final comments = snapshot.data!.docs;
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index].data() as Map<String, dynamic>;
                            final time = (comment['time'] as Timestamp).toDate();
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(comment['avatar']),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(comment['user'] ?? '',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                      const SizedBox(width: 10),
                                      Text(_timeAgo(time),
                                          style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(comment['comment'] ?? '', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextField(
                              controller: _commentController,
                              decoration: const InputDecoration(
                                hintText: "Add a comment...",
                                border: InputBorder.none,
                                isCollapsed: true,
                              ),
                              style: const TextStyle(fontSize: 13),
                              onSubmitted: (_) => _submitComment(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _submitComment,
                          child: const Icon(Icons.send, size: 22, color: Colors.blue),
                        ),
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

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return "${diff.inDays}d";
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
        title: Text(title, style: const TextStyle(fontSize: 14)),
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
              CircleAvatar(radius: 20, backgroundImage: AssetImage(widget.userImage)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.timeAgo, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_horiz, size: 25),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Container(
                          color: Colors.grey[100],
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 5,
                                margin: const EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              _buildOptionTile(Icons.bookmark_outline, 'Save'),
                              const SizedBox(height: 10),
                              _buildOptionTile(Icons.star_outline, 'Add to Favourites'),
                              const SizedBox(height: 10),
                              _buildOptionTile(Icons.person_outline, 'About this account'),
                              const SizedBox(height: 10),
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
          const SizedBox(height: 10),
          Text(widget.caption, style: const TextStyle(fontSize: 12.5)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              widget.postImage,
              height: 185,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
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
              const SizedBox(width: 4),
              Text('$likeCount', style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: _showCommentPanel,
                child: const Icon(Icons.comment_outlined, size: 18),
              ),
              const SizedBox(width: 4),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.postOwnerId)
                    .collection('posts')
                    .doc(widget.postId)
                    .collection('comments')
                    .snapshots(),
                builder: (context, snapshot) {
                  int count = snapshot.data?.docs.length ?? 0;
                  return Text('$count', style: const TextStyle(fontSize: 13));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
