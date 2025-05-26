import 'package:flutter/material.dart';
// import 'widgets/calorie_summary_section.dart';
// import 'widgets/nutrition_bottom_sheet.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});
  
  @override
  State<NutritionPage> createState() => NutritionPageState();
}

class NutritionPageState extends State<NutritionPage> {
  DateTime selectedDate = DateTime.now();
  // final GlobalKey<NutritionBottomSheetState> _bottomSheetKey = GlobalKey();

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
    // _bottomSheetKey.currentState?.collapse();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      // child: Stack(
      //   children: [
      //     Column(
      //       children: [
      //         CalorieSummarySection(
      //           selectedDate: selectedDate,
      //           onPreviousDay: _goToPreviousDay,
      //           onNextDay: _goToNextDay,
      //           baseGoal: 2000,
      //           foodCalories: 1600,
      //           exerciseCalories: 400,
      //         )
      //       ],
      //     ),
      //     NutritionBottomSheet(key: _bottomSheetKey),
      //   ],
      // ),
    );
  }
}

