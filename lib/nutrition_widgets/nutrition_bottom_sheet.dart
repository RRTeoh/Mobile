import 'package:flutter/material.dart';
import 'top_stats.dart';
import 'meal_section.dart';
import 'meal_form.dart';

// Nutritional information bottom panel, provide meal data management and statistical display function, support expand/collapse animation
class NutritionBottomSheet extends StatefulWidget {
  final int baseGoal;
  final int exerciseCalories;
  final ValueChanged<int>? onFoodCaloriesUpdate;

  const NutritionBottomSheet({
    super.key,
    this.baseGoal = 2000,
    this.exerciseCalories = 400,
    this.onFoodCaloriesUpdate,
  });
  
  @override
  State<NutritionBottomSheet> createState() => NutritionBottomSheetState();
}

class NutritionBottomSheetState extends State<NutritionBottomSheet> {
  // Status Management
  bool _isExpanded = false;
  final Set<int> _expandedMealIndices = <int>{};
  final Map<int, bool> _formHasData = <int, bool>{};
  
  // Meal type food data storage
  final Map<String, List<FoodItem>> _mealFoodData = {
    'Breakfast': <FoodItem>[],
    'Lunch': <FoodItem>[],
    'Dinner': <FoodItem>[],
    'Snack': <FoodItem>[],
  };

  // Animation and Layout Constants
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const double _collapsedHeightRatio = 0.45;
  static const double _expandedHeightRatio = 0.74;
  static const EdgeInsets _containerPadding = EdgeInsets.fromLTRB(20, 10, 20, 50);
  static const double _statsSpacing = 15.0;

  // Meal type mapping (to avoid duplicate strings)
  static const List<String> _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  // Toggle meal area expansion status
  void _toggleExpand(int index) {
    setState(() {
      if (_expandedMealIndices.contains(index)) {
        _expandedMealIndices.remove(index);
      } else {
        _expandedMealIndices.add(index);
      }
      _isExpanded = _expandedMealIndices.isNotEmpty;
    });
  }

  // Update form data status
  void _updateFormDataStatus(int index, bool hasData) {
    if (_formHasData[index] != hasData) {
      setState(() {
        _formHasData[index] = hasData;
      });
    }
  }
  
  // Update food data for specified meal types
  void _updateMealFoodData(String mealType, List<FoodItem> foodItems) {
    // Validation of meal types
    if (!_mealFoodData.containsKey(mealType)) {
      debugPrint('Warning: Invalid meal type: $mealType');
      return;
    }
    
    setState(() {
      _mealFoodData[mealType] = List.from(foodItems); // Creating copies to avoid referencing problems
    });
    
    // Update the corresponding form status
    final mealIndex = _getMealIndexByType(mealType);
    if (mealIndex != -1) {
      _updateFormDataStatus(mealIndex, foodItems.isNotEmpty);
    }
    
    // Notify parent component of food calorie updates
    final totalCalories = _getTotalCalories();
    widget.onFoodCaloriesUpdate?.call(totalCalories);
    
    // Reserved data persistence interface
    // _saveMealDataToDatabase(mealType, foodItems);
  }
  
  // Get the corresponding index based on the name of the meal type
  int _getMealIndexByType(String mealType) {
    return _mealTypes.indexOf(mealType);
  }
  
  // Getting food data for a given meal type
  // List<FoodItem> _getFoodItemsForMeal(String mealType) {
  //   return _mealFoodData[mealType] ?? <FoodItem>[];
  // }
  
  // Calculate total calories
  int _getTotalCalories() {
    return _mealFoodData.values
        .expand((foodList) => foodList)
        .fold(0, (sum, food) => sum + food.calories);
  }
  
  // Get the calorie total for a given meal type
  int _getMealCalories(String mealType) {
    final foodList = _mealFoodData[mealType];
    if (foodList == null) return 0;
    return foodList.fold(0, (sum, food) => sum + food.calories);
  }

  // Disclosure method: Folded panel
  void collapse() {
    if (_hasActiveState()) {
      setState(() {
        _resetAllStates();
      });
    }
  }
  
  // Check for active status
  bool _hasActiveState() {
    return _isExpanded || 
           _expandedMealIndices.isNotEmpty || 
           _formHasData.isNotEmpty;
  }
  
  // Reset all states
  void _resetAllStates() {
    _isExpanded = false;
    _expandedMealIndices.clear();
    _formHasData.clear();
  }
  
  // Empty all meal types
  void clearAllMealData() {
    setState(() {
      _mealFoodData.updateAll((key, value) => <FoodItem>[]);
      _formHasData.clear();
    });
    // Notify parent component of calorie clearing
    widget.onFoodCaloriesUpdate?.call(0);
  }
  
  // Obtaining an overview of meal type data (for commissioning or statistical display)
  NutritionSummary getNutritionSummary() {
    return NutritionSummary(
      totalCalories: _getTotalCalories(),
      mealCalories: Map.fromEntries(
        _mealTypes.map((type) => MapEntry(type, _getMealCalories(type)))
      ),
      totalFoodItems: _mealFoodData.values
          .fold(0, (sum, list) => sum + list.length),
      activeMeals: _mealFoodData.entries
          .where((entry) => entry.value.isNotEmpty)
          .length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final currentHeightRatio = _isExpanded ? _expandedHeightRatio : _collapsedHeightRatio;
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: Curves.easeInOut,
        height: screenHeight * currentHeightRatio,
        decoration: _buildContainerDecoration(),
        child: _buildContent(),
      ),
    );
  }

  // Building container decorations
  BoxDecoration _buildContainerDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, -5),
        ),
      ],
    );
  }

  // Building content areas
  Widget _buildContent() {
    return ListView(
      padding: _containerPadding,
      children: [
        TopStatsRow(
          baseGoal: widget.baseGoal,
          foodCalories: _getTotalCalories(),
          exerciseCalories: widget.exerciseCalories,
        ),
        const SizedBox(height: _statsSpacing),
        MealSectionList(
          expandedMealIndices: _expandedMealIndices,
          onToggleExpand: _toggleExpand,
          onDataChange: _updateFormDataStatus,
          mealFoodData: _mealFoodData,
          onMealDataUpdate: _updateMealFoodData,
        ),
      ],
    );
  }
}

// Nutrition Data Overview Model
class NutritionSummary {
  final int totalCalories;
  final Map<String, int> mealCalories;
  final int totalFoodItems;
  final int activeMeals;

  const NutritionSummary({
    required this.totalCalories,
    required this.mealCalories,
    required this.totalFoodItems,
    required this.activeMeals,
  });

  @override
  String toString() {
    return 'NutritionSummary(totalCalories: $totalCalories, '
           'totalItems: $totalFoodItems, activeMeals: $activeMeals)';
  }
}