import 'package:flutter/material.dart';
import 'meal_card.dart';
import 'meal_form.dart';

// Meal list component, manages the display and interaction of multiple meal areas, supports expand/collapse animation.
class MealSectionList extends StatelessWidget {
  final Set<int> expandedMealIndices;
  final void Function(int) onToggleExpand;
  final void Function(int, bool) onDataChange;
  final Map<String, List<FoodItem>> mealFoodData;
  final void Function(String, List<FoodItem>) onMealDataUpdate;

  const MealSectionList({
    super.key,
    required this.expandedMealIndices,
    required this.onToggleExpand,
    required this.onDataChange,
    required this.mealFoodData,
    required this.onMealDataUpdate,
  });

  // Meal configuration data
  static const List<MealConfig> _mealConfigs = [
    MealConfig(
      title: 'Breakfast',
      image: 'assets/images/food/breakfast.jpg',
      calories: 'Recommended 400~500 kcal',
    ),
    MealConfig(
      title: 'Lunch',
      image: 'assets/images/food/lunch.jpg',
      calories: 'Recommended 600~700 kcal',
    ),
    MealConfig(
      title: 'Dinner',
      image: 'assets/images/food/dinner.jpg',
      calories: 'Recommended 600~700 kcal',
    ),
    MealConfig(
      title: 'Snack',
      image: 'assets/images/food/snack.jpg',
      calories: 'Recommended 200~300 kcal',
    ),
  ];

  // Layout Constants
  static const double _sectionSpacing = 15.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildMealSections(),
    );
  }

  // Build a list of meal areas
  List<Widget> _buildMealSections() {
    final sections = <Widget>[];
    
    for (int i = 0; i < _mealConfigs.length; i++) {
      sections.add(
        MealSection(
          key: ValueKey('meal_section_$i'),
          index: i,
          config: _mealConfigs[i],
          onCardTap: () => onToggleExpand(i),
          isExpanded: expandedMealIndices.contains(i),
          onDataChange: (hasData) => onDataChange(i, hasData),
          foodItems: mealFoodData[_mealConfigs[i].title] ?? <FoodItem>[],
          onFoodItemsUpdate: (items) => onMealDataUpdate(_mealConfigs[i].title, items),
        ),
      );
      
      // Add spacing (except for the last one)
      if (i < _mealConfigs.length - 1) {
        sections.add(const SizedBox(height: _sectionSpacing));
      }
    }
    
    return sections;
  }
}

/// Meal Configuration Data Model
class MealConfig {
  final String title;
  final String image;
  final String calories;

  const MealConfig({
    required this.title,
    required this.image,
    required this.calories,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MealConfig &&
        other.title == title &&
        other.image == image &&
        other.calories == calories;
  }

  @override
  int get hashCode => Object.hash(title, image, calories);
}

// Meal Section components, including meal cards and expandable forms, to manage the complete interaction of individual meals.
class MealSection extends StatefulWidget {
  final int index;
  final MealConfig config;
  final VoidCallback onCardTap;
  final bool isExpanded;
  final Function(bool) onDataChange;
  final List<FoodItem> foodItems;
  final Function(List<FoodItem>) onFoodItemsUpdate;

  const MealSection({
    required Key key,
    required this.index,
    required this.config,
    required this.onCardTap,
    required this.isExpanded,
    required this.onDataChange,
    required this.foodItems,
    required this.onFoodItemsUpdate,
  }) : super(key: key);

  @override
  State<MealSection> createState() => _MealSectionState();
}

class _MealSectionState extends State<MealSection> 
    with SingleTickerProviderStateMixin {
  
  // Animation Controller
  late final AnimationController _animationController;
  late final Animation<double> _sizeAnimation;
  late final Animation<Offset> _slideAnimation;
  
  // Forms Controller
  late final TextEditingController _foodNameController;
  late final TextEditingController _caloriesController;
  late final GlobalKey<FormState> _formKey;
  
  // Status Management
  bool _hasDataCached = false;
  bool _isUpdatingWidget = false;

  // Animation Constants
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const Curve _animationCurve = Curves.easeInOut;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
    _initializeState();
  }

  @override
  void didUpdateWidget(covariant MealSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isUpdatingWidget = true;
    
    _handleExpandStateChange(oldWidget);
    _handleFoodItemsChange(oldWidget);
    
    _isUpdatingWidget = false;
  }

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  // Initialising the controller
  void _initializeControllers() {
    _formKey = GlobalKey<FormState>();
    _foodNameController = TextEditingController();
    _caloriesController = TextEditingController();
    
    // Adding a Listener
    _foodNameController.addListener(_handleFormChange);
    _caloriesController.addListener(_handleFormChange);
  }

  // Setting up an animation
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    _sizeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: _animationCurve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: _animationCurve,
    ));
  }

  // Initialisation state
  void _initializeState() {
    _hasDataCached = _calculateHasData();
    
    // Setting the initial animation state
    if (widget.isExpanded) {
      _animationController.value = 1.0;
    }
    
    // Delayed notification of initial data state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onDataChange(_hasDataCached);
      }
    });
  }

  // Handling of unfolding state changes
  void _handleExpandStateChange(MealSection oldWidget) {
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  // Handling of food data changes
  void _handleFoodItemsChange(MealSection oldWidget) {
    if (!_listEquals(widget.foodItems, oldWidget.foodItems)) {
      _scheduleDataChangeCheck();
    }
  }

  // Calculate the availability of data
  bool _calculateHasData() {
    return _foodNameController.text.trim().isNotEmpty ||
           _caloriesController.text.trim().isNotEmpty ||
           widget.foodItems.isNotEmpty;
  }

  // Handling form changes
  void _handleFormChange() {
    if (_isUpdatingWidget) return;
    _scheduleDataChangeCheck();
  }

  // Movement control data change check
  void _scheduleDataChangeCheck() {
    Future.microtask(() {
      if (mounted) {
        final hasData = _calculateHasData();
        if (hasData != _hasDataCached) {
          _hasDataCached = hasData;
          widget.onDataChange(hasData);
        }
      }
    });
  }

  // Handling of food data updates
  void _handleFoodItemsUpdate(List<FoodItem> updatedItems) {
    Future.microtask(() {
      if (mounted) {
        widget.onFoodItemsUpdate(updatedItems);
        _scheduleDataChangeCheck();
      }
    });
  }

  // Compare two lists for equality
  bool _listEquals(List<FoodItem> list1, List<FoodItem> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  // Release of resources
  void _disposeResources() {
    _animationController.dispose();
    _foodNameController.removeListener(_handleFormChange);
    _caloriesController.removeListener(_handleFormChange);
    _foodNameController.dispose();
    _caloriesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMealCard(),
        _buildExpandableForm(),
      ],
    );
  }

  // Constructing Meal Cards
  Widget _buildMealCard() {
    return MealCard(
      title: widget.config.title,
      imageAsset: widget.config.image,
      recommendedCalories: widget.config.calories,
      isExpanded: widget.isExpanded,
      onTap: widget.onCardTap,
    );
  }

  // Building Expandable Forms
  Widget _buildExpandableForm() {
    return SizeTransition(
      sizeFactor: _sizeAnimation,
      axisAlignment: -1.0,
      child: ClipRect(
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildMealForm(),
        ),
      ),
    );
  }

  // Constructing Meal Forms
  Widget _buildMealForm() {
    return MealForm(
      formKey: _formKey,
      foodNameController: _foodNameController,
      caloriesController: _caloriesController,
      mealType: widget.config.title,
      initialFoodItems: widget.foodItems,
      onFoodItemsUpdate: _handleFoodItemsUpdate,
    );
  }
}