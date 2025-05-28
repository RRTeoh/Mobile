import 'package:flutter/material.dart';
import 'package:asgm1/nutrition_widgets/calorie_summary_section.dart';
import 'package:asgm1/nutrition_widgets/nutrition_bottom_sheet.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});
  
  @override
  State<NutritionPage> createState() => NutritionPageState();
}

class NutritionPageState extends State<NutritionPage> {
  DateTime selectedDate = DateTime.now();
  final GlobalKey<NutritionBottomSheetState> _bottomSheetKey = GlobalKey();
  
  // 共享的营养数据状态
  int _baseGoal = 2000;
  int _foodCalories = 0; // 从bottom sheet获取实际数据
  int _exerciseCalories = 400;

  void _goToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _goToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
  }

  void resetToDefault() {
    setState(() {
      selectedDate = DateTime.now();
    });
    _bottomSheetKey.currentState?.collapse();
  }

  // 更新食物卡路里的回调方法
  void _updateFoodCalories(int calories) {
    if (_foodCalories != calories) {
      setState(() {
        _foodCalories = calories;
      });
    }
  }

  // 更新基础目标的方法（如果需要动态修改）
  void _updateBaseGoal(int goal) {
    setState(() {
      _baseGoal = goal;
    });
  }

  // 更新运动卡路里的方法（如果需要动态修改）
  void _updateExerciseCalories(int calories) {
    setState(() {
      _exerciseCalories = calories;
    });
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
              )
            ],
          ),
          NutritionBottomSheet(
            key: _bottomSheetKey,
            baseGoal: _baseGoal,
            exerciseCalories: _exerciseCalories,
            onFoodCaloriesUpdate: _updateFoodCalories,
          ),
        ],
      ),
    );
  }
}