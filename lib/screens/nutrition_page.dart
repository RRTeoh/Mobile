import 'package:flutter/material.dart';
import 'package:asgm1/nutrition_widgets/calorie_summary_section.dart';
import 'package:asgm1/nutrition_widgets/nutrition_bottom_sheet.dart';

class NutritionPage extends StatefulWidget {
  final DateTime? earliestDate;
  final String userId;
  final VoidCallback? onCaloriesUpdated;
  const NutritionPage({super.key, this.earliestDate, required this.userId, this.onCaloriesUpdated});
  
  @override
  State<NutritionPage> createState() => NutritionPageState();
}

class NutritionPageState extends State<NutritionPage> {
  DateTime selectedDate = DateTime.now();
  final GlobalKey<NutritionBottomSheetState> _bottomSheetKey = GlobalKey();
  
  // Shared Nutrition Data Status
  final int _baseGoal = 2000;
  int _foodCalories = 0; // Get the actual data from the bottom sheet
  int _exerciseCalories = 0;
  bool _isLoading = false;

  void _goToPreviousDay() {
    setState(() {
      final earliest = widget.earliestDate ?? DateTime(2000);
      final prev = selectedDate.subtract(const Duration(days: 1));
      if (prev.isAfter(earliest) || _isSameDay(prev, earliest)) {
        selectedDate = prev;
        _isLoading = true;
        _foodCalories = 0;
      }
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  void _goToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
      _isLoading = true;
      _foodCalories = 0;
    });
  }

  void resetToDefault() {
    setState(() {
      selectedDate = DateTime.now();
      _isLoading = true;
      _foodCalories = 0;
    });
    _bottomSheetKey.currentState?.collapse();
  }

  // Updating the callback method for food calories
  void _updateFoodCalories(int calories) {
    if (_foodCalories != calories) {
      setState(() {
        _foodCalories = calories;
      });
      // Notification that parent component calorie data has been updated
      widget.onCaloriesUpdated?.call();
    }
  }

  void updateExerciseCalories(int newCalories) {
    setState(() {
      _exerciseCalories = newCalories;
    });
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