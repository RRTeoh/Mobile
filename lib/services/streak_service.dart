import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreakService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current streak for a user
  static Future<int> getCurrentStreak() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 0;

      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('streak')
          .doc('current')
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.data()!['streak'] ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error getting streak: $e');
      return 0;
    }
  }

  // Increment streak when user posts content
  static Future<void> incrementStreak() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('streak')
          .doc('current');

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        
        int currentStreak = 0;
        if (doc.exists && doc.data() != null) {
          currentStreak = doc.data()!['streak'] ?? 0;
        }

        // Increment streak by 1 for every post (no daily limit)
        transaction.set(docRef, {
          'streak': currentStreak + 1,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      print('Error incrementing streak: $e');
    }
  }

  // Reset streak (for testing or admin purposes)
  static Future<void> resetStreak() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('streak')
          .doc('current')
          .set({
        'streak': 0,
        'lastPostedDate': null,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error resetting streak: $e');
    }
  }

  // Get streak display string
  static Future<String> getStreakDisplay() async {
    final streak = await getCurrentStreak();
    return '$streak 🔥';
  }
} 