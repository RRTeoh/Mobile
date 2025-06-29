import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:asgm1/services/notification_service.dart';

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
  final String postId;
  final String postOwnerId;

  const Posts({
    super.key,
    required this.username,
    required this.userImage,
    required this.postImage,
    required this.caption,
    required this.timeAgo,
    required this.initialLikes,
    required this.currentUserId,
    required this.currentUserName,
    required this.currentUserAvatar,
    required this.postId,
    required this.postOwnerId,
  });

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  int likeCount = 0;
  bool isLiked = false;
  //bool isFavourited = false;
  bool isReported  = false;
  
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    likeCount = widget.initialLikes;
    _fetchReportStatus();
    //_checkIfFavourited();
    //_checkIfHidden();
  }

  /*void _checkIfFavourited() async {
    final favDoc = await FirebaseFirestore.instance
        .collection('favourites')
        .doc('${widget.currentUserId}_${widget.postId}')
        .get();
    if (favDoc.exists) {
      setState(() => isFavourited = true);
    }
  }*/

  /*void _checkIfHidden() async {
    final hideDoc = await FirebaseFirestore.instance
        .collection('hiddenPosts')
        .doc('${widget.currentUserId}_${widget.postId}')
        .get();
    if (hideDoc.exists) {
      setState(() => isHidden = true);
    }
  }*/

void _fetchReportStatus() async {
  final doc = await FirebaseFirestore.instance.collection('posts').doc(widget.postId).get();
  if (doc.exists) {
    final data = doc.data();
    if (data != null && data.containsKey('isReported')) {
      setState(() {
        isReported = data['isReported'] ?? false;
      });
    }
  }
}

  void toggleLike() async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(widget.postId);
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
    await postRef.update({'likes': FieldValue.increment(isLiked ? 1 : -1)});
    if (isLiked && widget.currentUserId != widget.postOwnerId) {
      _sendNotification("liked your post.");
    }
  }

  void _submitComment() async {
    String comment = _commentController.text.trim();
    if (comment.isEmpty) return;

    // Fetch latest user profile safely
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.currentUserId).get();
    final userData = userDoc.data() as Map<String, dynamic>?;

    String latestUserName = userData?['firstName'] ?? 'Unknown';
    String latestUserAvatar = userData?['avatar'] ?? 'assets/images/default.jpg';

    await FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').add({
      'user': latestUserName,
      'avatar': latestUserAvatar,
      'comment': comment,
      'time': FieldValue.serverTimestamp(),
      'userId': widget.currentUserId, // Store current user ID here
    });
    
    _commentController.clear();
    if (widget.currentUserId != widget.postOwnerId) {
      _sendNotification("commented on your post.");
    }
  }

  void _sendNotification(String action) {
    FirebaseFirestore.instance.collection('notifications').add({
      'receiver': widget.postOwnerId,
      'senderName': widget.currentUserName,
      'senderAvatar': widget.currentUserAvatar,
      'action': action,
      'preview': widget.postImage,
      'read': false,
      'time': FieldValue.serverTimestamp(),
    });
    
    // Use local notification instead of FCM
    if (widget.currentUserId != widget.postOwnerId) {
      // Import NotificationService at the top of the file
      // NotificationService().sendFeedNotification(
      //   title: widget.currentUserName,
      //   body: action,
      // );
    }
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return "${diff.inDays}d";
  }

  @override
  Widget build(BuildContext context) {
    /*if (isHidden) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("The post is hidden.", style: TextStyle(fontSize: 13)),
              TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('hiddenPosts').doc('${widget.currentUserId}_${widget.postId}').delete();
                  setState(() => isHidden = false);
                },
                child: const Text("Unhide"),
              ),
            ],
          ),
        ),
      );
    }*/

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(widget.postOwnerId).snapshots(),
            builder: (context, snapshot) {
              String displayName = widget.username;
              String displayImage = widget.userImage;

              if (snapshot.hasData && snapshot.data!.exists) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                displayName = data['firstName'] ?? widget.username;
                displayImage = data['avatar'] ?? widget.userImage;
              }

              return _buildHeader(displayName, displayImage);
            },
          ),

          const SizedBox(height: 10),
          Text(widget.caption, style: const TextStyle(fontSize: 12.5)),
          const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(
              alignment: Alignment.center,
                children: [
                widget.postImage.startsWith('http')
                  ? Image.network(widget.postImage, height: 185, width: double.infinity, fit: BoxFit.cover)
                  : Image.asset(widget.postImage, height: 185, width: double.infinity, fit: BoxFit.cover),
      
              if (isReported) ...[
                Positioned.fill(
                  child: Container(
                  color: Colors.black.withOpacity(0.4),
                  ),
                ),
                const Icon(Icons.visibility_off, color: Colors.white, size: 50),
                  ],
                ],
              ),
            ),
          const SizedBox(height: 6),

          Row(
            children: [
              GestureDetector(
                onTap: toggleLike,
                child: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: isLiked ? Colors.red : Colors.black, size: 18),
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
                stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').snapshots(),
                builder: (context, snapshot) {
                  int commentCount = snapshot.data?.docs.length ?? 0;
                  return Text('$commentCount', style: const TextStyle(fontSize: 13));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String name, String image) {
    return Row(
      children: [
        CircleAvatar(radius: 20, backgroundImage: image.startsWith('http') ? NetworkImage(image) : AssetImage(image) as ImageProvider),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.timeAgo, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        const Spacer(),
        IconButton(icon: const Icon(Icons.more_horiz), onPressed: _showOptions),
      ],
    );
  }

  void _showOptions() {
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
                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
              ),
              _buildOptionTile(Icons.report_outlined, 'Report'),
            ],
          ),
        ),
      );
    },
  );
}


  Widget _buildOptionTile(IconData icon, String title) {
  return ListTile(
    leading: Icon(icon, color: Colors.red),
    title: Text(title,
    style: TextStyle(
      color: title == 'Report' ? Colors.red : Colors.black, // <-- Red text for "Report"
      ),
    ),
    onTap: () {
      Navigator.pop(context);
      _showReportReasons();
    },
  );
}

void _showReportReasons() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle Bar
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Title & Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const Text(
                      "Why are you reporting this post?",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Your report is anonymous. If someone is in immediate danger,\ncall the local emergency services – don't wait.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              const Divider(),

              // Scrollable List
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildReportReason("I just don't like it"),
                    const Divider(height: 1),
                    _buildReportReason("Bullying or unwanted contact"),
                    const Divider(height: 1),
                    _buildReportReason("Suicide, self-injury or eating disorders"),
                    const Divider(height: 1),
                    _buildReportReason("Violence, hate or exploitation"),
                    const Divider(height: 1),
                    _buildReportReason("Selling or promoting restricted items"),
                    const Divider(height: 1),
                    _buildReportReason("Nudity or sexual activity"),
                    const Divider(height: 1),
                    _buildReportReason("Scam, fraud or spam"),
                    const Divider(height: 1),
                    _buildReportReason("False information"),
                    const Divider(height: 1),
                    _buildReportReason("Intellectual property"),
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  )
  .then((reason) async {
    // After bottom sheet closed, if user selected reason, show message
    if (reason != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reported for: $reason")),
      );
      // Update Firestore field
      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
        'isReported': true,
    });
    setState(() {
    isReported = true;

    });
    }
  });
}

Widget _buildReportReason(String reason) {
  return ListTile(
    title: Text(reason, style: const TextStyle(fontSize: 14)),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: () {
      Navigator.pop(context, reason); // Return reason to previous screen
    },
  );
}


  void _showCommentPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                  Container(width: 40, height: 5, margin: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
                  const Text("Comments", style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').orderBy('time', descending: true).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                        final comments = snapshot.data!.docs;
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index].data() as Map<String, dynamic>;
                            final time = (comment['time'] as Timestamp).toDate();
                            final userId = comment['userId'] ?? '';
                            
                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                              builder: (context, userSnapshot) {
                                String displayName = comment['user'] ?? 'Unknown';
                                String displayAvatar = comment['avatar'] ?? 'assets/images/default.jpg';
                                
                                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                                  final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                                  displayName = userData['firstName'] ?? comment['user'] ?? 'Unknown';
                                  displayAvatar = userData['avatar'] ?? comment['avatar'] ?? 'assets/images/default.jpg';
                                }
                                
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                    backgroundImage: displayAvatar.startsWith('http')
                                        ? NetworkImage(displayAvatar)
                                        : AssetImage(displayAvatar) as ImageProvider,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                          Text(displayName, 
                                      style:  TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                            color: userId == widget.currentUserId ? Colors.blue : Colors.black,
                                        ),),

                                      const SizedBox(width: 10),
                                      Text(_timeAgo(time), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                      
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(comment['comment'], style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                                );
                              },
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
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(25)),
                            child: TextField(
                              controller: _commentController,
                              decoration: const InputDecoration(hintText: "Add a comment...", border: InputBorder.none, isCollapsed: true),
                              style: const TextStyle(fontSize: 13),
                              onSubmitted: (_) => _submitComment(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(onTap: _submitComment, child: const Icon(Icons.send, size: 22, color: Colors.blue)),
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
  
}


