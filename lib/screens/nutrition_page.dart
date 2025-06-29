import 'package:flutter/material.dart';
import 'package:asgm1/nutrition_widgets/calorie_summary_section.dart';
import 'package:asgm1/nutrition_widgets/nutrition_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NutritionPage extends StatefulWidget {
  final DateTime? earliestDate;
  final String userId;
  final VoidCallback? onCaloriesUpdated;

  const NutritionPage({
    super.key,
    this.earliestDate,
    required this.userId,
    this.onCaloriesUpdated,
  });

  @override
  State<NutritionPage> createState() => NutritionPageState();
}

class NutritionPageState extends State<NutritionPage> {
  DateTime selectedDate = DateTime.now();
  final GlobalKey<NutritionBottomSheetState> _bottomSheetKey = GlobalKey();

  final int _baseGoal = 2000;
  int _foodCalories = 0;
  int _exerciseCalories = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCalorieData();
  }

  Future<void> _loadCalorieData() async {
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('calorie_logs')
        .doc(dateStr)
        .get();

    if (doc.exists) {
      setState(() {
        _exerciseCalories = doc['exerciseCalories'] ?? 0;
        _foodCalories = doc['foodCalories'] ?? 0;
        _isLoading = false;
      });
    } else {
      setState(() {
        _exerciseCalories = 0;
        _foodCalories = 0;
        _isLoading = false;
      });
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _goToPreviousDay() {
    setState(() {
      final earliest = widget.earliestDate ?? DateTime(2000);
      final prev = selectedDate.subtract(const Duration(days: 1));
      if (prev.isAfter(earliest) || _isSameDay(prev, earliest)) {
        selectedDate = prev;
        _isLoading = true;
      }
    });
    _loadCalorieData();
  }

  void _goToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
      _isLoading = true;
    });
    _loadCalorieData();
  }

  void resetToDefault() {
    setState(() {
      selectedDate = DateTime.now();
      _isLoading = true;
    });
    _bottomSheetKey.currentState?.collapse();
    _loadCalorieData();
  }

  void _updateFoodCalories(int calories) async {
    if (_foodCalories != calories) {
      setState(() {
        _foodCalories = calories;
      });

      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('calorie_logs')
          .doc(dateStr);

      await docRef.set({
        'foodCalories': calories,
        'exerciseCalories': _exerciseCalories,
      }, SetOptions(merge: true));

      widget.onCaloriesUpdated?.call();
    }
  }

  void updateExerciseCalories(int newCalories) async {
  setState(() {
    _exerciseCalories += newCalories;
  });

  final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(widget.userId)
      .collection('calorie_logs')
      .doc(dateStr);

  await docRef.set({
    'exerciseCalories': _exerciseCalories, // ✅ Save accumulated value
    'foodCalories': _foodCalories,
  }, SetOptions(merge: true));

  widget.onCaloriesUpdated?.call();
}

void subtractExerciseCalories(int caloriesToSubtract) async {
  setState(() {
    _exerciseCalories -= caloriesToSubtract;
    if (_exerciseCalories < 0) _exerciseCalories = 0;
  });

  final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(widget.userId)
      .collection('calorie_logs')
      .doc(dateStr);

  await docRef.set({
    'exerciseCalories': _exerciseCalories,
    'foodCalories': _foodCalories,
  }, SetOptions(merge: true));

  widget.onCaloriesUpdated?.call();
}


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Column(
            children: [
              CalorieSummarySection(
                selectedDate: selectedDate,
                onPreviousDay: _goToPreviousDay,
                onNextDay: _goToNextDay,
                baseGoal: _baseGoal,
                foodCalories: _foodCalories,
                exerciseCalories: _exerciseCalories,
                earliestDate: widget.earliestDate,
              )
            ],
          ),
          NutritionBottomSheet(
            key: _bottomSheetKey,
            baseGoal: _baseGoal,
            exerciseCalories: _exerciseCalories,
            onFoodCaloriesUpdate: _updateFoodCalories,
            selectedDate: selectedDate,
            userId: widget.userId,
          ),
        ],
      ),
    );
  }
}
