import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math' as math;

// Calorie data model
class CalorieData {
  final int baseGoal;
  final int foodCalories;
  final int exerciseCalories;

  const CalorieData({
    required this.baseGoal,
    required this.foodCalories,
    required this.exerciseCalories,
  });

  int get netIntakeCalories => math.max(0, foodCalories - exerciseCalories);
  
  double get foodProgress => baseGoal > 0 ? (foodCalories / baseGoal).clamp(0.0, 1.0) : 0.0;
  
  double get netIntakeProgress => baseGoal > 0 ? (netIntakeCalories / baseGoal).clamp(0.0, 1.0) : 0.0;
  
  bool get isNetIntakeExceeded => netIntakeCalories > baseGoal;
  
  // As long as the food calories are greater than 0 it should show an animation
  bool get hasValidFood => foodCalories > 0;
  
  // Validity of net intake value (greater than 0)
  bool get hasValidNetIntake => netIntakeCalories > 0;

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is CalorieData &&
    runtimeType == other.runtimeType &&
    baseGoal == other.baseGoal &&
    foodCalories == other.foodCalories &&
    exerciseCalories == other.exerciseCalories;

  @override
  int get hashCode => Object.hash(baseGoal, foodCalories, exerciseCalories);
}

// Animation Configuration
class AnimationConfig {
  static const Duration foodDuration = Duration(milliseconds: 1000);
  static const Duration netIntakeDuration = Duration(milliseconds: 1000);
  static const Duration redTransitionDuration = Duration(milliseconds: 1000);
  static const Duration disappearDuration = Duration(milliseconds: 1000);
  static const Duration delayBeforeRed = Duration(milliseconds: 500);
  static const Duration delayAfterRed = Duration(milliseconds: 500);
  
  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve easeInOut = Curves.easeInOut;
}

// UI Constants
class UIConstants {
  static double getCircleRadius(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 800) {
      return 80.0;
    } else if (screenHeight > 700) {
      return 75.0;
    } else {
      return 65.0;
    }
  }
  static double getLineWidrh(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 800) {
      return 12.0;
    } else if (screenHeight > 700) {
      return 11.0;
    } else {
      return 10.0;
    }
  }

  static const Color blueColor = Color(0xff41b8d5);
  static const Color redColor = Color.fromARGB(255, 255, 85, 0);
  static const Color yellowColor = Color.fromARGB(255, 255, 186, 59);
  static const Color greyColor = Color(0xff807f7e);
  static const Color textColor = Color(0xff333333);
}

// Calorie Summary Component
class CalorieSummarySection extends StatefulWidget {
  final DateTime selectedDate;
  final VoidCallback onPreviousDay;
  final VoidCallback? onNextDay;
  final int baseGoal;
  final int foodCalories;
  final int exerciseCalories;
  final DateTime? earliestDate;
  final bool isLoading;

  const CalorieSummarySection({
    super.key,
    required this.selectedDate,
    required this.onPreviousDay,
    this.onNextDay,
    required this.baseGoal,
    required this.foodCalories,
    required this.exerciseCalories,
    this.earliestDate,
    this.isLoading = false,
  });

  @override
  State<CalorieSummarySection> createState() => _CalorieSummarySectionState();
}

class _CalorieSummarySectionState extends State<CalorieSummarySection>
    with TickerProviderStateMixin {
  
  // Animation Controller Group
  late final AnimationController _foodController;
  late final AnimationController _netIntakeController;
  late final AnimationController _redTransitionController;
  late final AnimationController _disappearController;
  
  // Animation Object Group
  late Animation<double> _foodAnimation;
  late Animation<double> _netIntakeAnimation;
  late Animation<double> _redTransitionAnimation;
  late Animation<double> _disappearAnimation;
  
  // Data Cache
  CalorieData? _cachedData;

  double getDateFontSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 24;
    } else if (screenHeight > 750) {
      return 22;
    } else {
      return 20;
    }
  }

  EdgeInsets getCalorieCirclePadding(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return const EdgeInsets.fromLTRB(35,7,35,0);
    } else if (screenHeight > 750) {
      return const EdgeInsets.fromLTRB(30,5,30,0);
    } else {
      return const EdgeInsets.fromLTRB(25,3,25,0);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimationControllers();
    _updateAnimationsAndStart();
  }

  @override
  void didUpdateWidget(covariant CalorieSummarySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newData = _createCalorieData();
    if (_cachedData != newData || widget.selectedDate != oldWidget.selectedDate) {
      _updateAnimationsAndStart();
    }
  }

  @override
  void dispose() {
    _foodController.dispose();
    _netIntakeController.dispose();
    _redTransitionController.dispose();
    _disappearController.dispose();
    super.dispose();
  }

  void _initializeAnimationControllers() {
    _foodController = AnimationController(
      vsync: this,
      duration: AnimationConfig.foodDuration,
    );
    _netIntakeController = AnimationController(
      vsync: this,
      duration: AnimationConfig.netIntakeDuration,
    );
    _redTransitionController = AnimationController(
      vsync: this,
      duration: AnimationConfig.redTransitionDuration,
    );
    _disappearController = AnimationController(
      vsync: this,
      duration: AnimationConfig.disappearDuration,
    );
  }

  CalorieData _createCalorieData() {
    return CalorieData(
      baseGoal: widget.baseGoal,
      foodCalories: widget.foodCalories,
      exerciseCalories: widget.exerciseCalories,
    );
  }

  void _setupAnimations(CalorieData data) {
    _foodAnimation = Tween<double>(
      begin: 0.0, 
      end: data.foodProgress,
    ).animate(CurvedAnimation(
      parent: _foodController, 
      curve: AnimationConfig.easeOutCubic,
    ));
    
    _netIntakeAnimation = Tween<double>(
      begin: 0.0, 
      end: data.netIntakeProgress,
    ).animate(CurvedAnimation(
      parent: _netIntakeController, 
      curve: AnimationConfig.easeOutCubic,
    ));
    
    _redTransitionAnimation = Tween<double>(
      begin: 0.0, 
      end: data.foodProgress,
    ).animate(CurvedAnimation(
      parent: _redTransitionController, 
      curve: AnimationConfig.easeInOut,
    ));
    
    _disappearAnimation = Tween<double>(
      begin: data.foodProgress, 
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _disappearController, 
      curve: AnimationConfig.easeInOut,
    ));
  }

  void _updateAnimationsAndStart() {
    final data = _createCalorieData();
    _cachedData = data;
    _setupAnimations(data);
    _startAnimationSequence(data);
  }

  Future<void> _startAnimationSequence(CalorieData data) async {
    _resetAllAnimations();
    
    // Animation as long as there's food
    if (!data.hasValidFood) return;
    
    // The food animation is always executed, the net intake animation is only executed when it is valid
    List<Future> animations = [_foodController.forward()];
    if (data.hasValidNetIntake) {
      animations.add(_netIntakeController.forward());
    }
    
    await Future.wait(animations);
    
    // Starts red transition animation after a delay
    await Future.delayed(AnimationConfig.delayBeforeRed);
    await _redTransitionController.forward();
    
    await Future.delayed(AnimationConfig.delayAfterRed);
    
    await _disappearController.forward();
  }

  void _resetAllAnimations() {
    _foodController.reset();
    _netIntakeController.reset();
    _redTransitionController.reset();
    _disappearController.reset();
  }

  bool _isToday() {
    final now = DateTime.now();
    return widget.selectedDate.year == now.year &&
           widget.selectedDate.month == now.month &&
           widget.selectedDate.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const SizedBox.shrink();
    }
    final data = _cachedData ?? _createCalorieData();
    final formattedDate = DateFormat('MMM d, yyyy').format(widget.selectedDate);
    final isToday = _isToday();
    final netIntakeColor = data.isNetIntakeExceeded 
        ? UIConstants.yellowColor 
        : UIConstants.blueColor;
    final isEarliest = widget.earliestDate != null && widget.selectedDate.year == widget.earliestDate!.year && widget.selectedDate.month == widget.earliestDate!.month && widget.selectedDate.day == widget.earliestDate!.day;

    return Column(
      children: [
        Text(
          isToday ? 'Today' : formattedDate,
          style: TextStyle(fontSize: getDateFontSize(context)),
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ArrowButton(
              icon: Icons.chevron_left,
              onPressed: isEarliest ? null : widget.onPreviousDay,
              opacity: isEarliest ? 0.0 : 1.0,
            ),
            Padding(
              padding: getCalorieCirclePadding(context),
              child: SizedBox(
                child: data.hasValidFood  // Checking for valid food data
                    ? _AnimatedCircleWidget(
                        data: data,
                        netIntakeColor: netIntakeColor,
                        foodAnimation: _foodAnimation,
                        netIntakeAnimation: _netIntakeAnimation,
                        redTransitionAnimation: _redTransitionAnimation,
                        disappearAnimation: _disappearAnimation,
                        redTransitionController: _redTransitionController,
                        disappearController: _disappearController,
                        controllers: [
                          _foodController,
                          _netIntakeController,
                          _redTransitionController,
                          _disappearController,
                        ],
                      )
                    : _StaticCircleWidget(data: data),
              ),
            ),
            
            _ArrowButton(
              icon: Icons.chevron_right,
              onPressed: isToday ? null : widget.onNextDay,
              opacity: isToday ? 0.0 : 1.0,
            ),
          ],
        ),
      ],
    );
  }
}

// Arrow Button Component
class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double opacity;

  const _ArrowButton({
    required this.icon,
    required this.onPressed,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: opacity,
        child: IconButton(
          icon: Icon(icon, size: 60, color: UIConstants.greyColor),
          onPressed: onPressed,
        ),
      );
  }
}

// Circular Progress Indicator Assembly
class _CircularIndicator extends StatelessWidget {
  final double percent;
  final Color progressColor;

  const _CircularIndicator({
    required this.percent,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final circleRadius = UIConstants.getCircleRadius(context);
    final lineWidth = UIConstants.getLineWidrh(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Border
        CircularPercentIndicator(
          radius: circleRadius + 1,
          lineWidth: 1,
          percent: 1.0,
          backgroundColor: Colors.transparent,
          progressColor: Colors.grey.shade300,
          center: Container(),
        ),
        // Inner Border
        CircularPercentIndicator(
          radius: circleRadius - lineWidth,
          lineWidth: 1,
          percent: 1.0,
          backgroundColor: Colors.transparent,
          progressColor: Colors.grey.shade300,
          center: Container(),
        ),
        // Main Progress Indicators
        CircularPercentIndicator(
          radius: circleRadius,
          lineWidth: lineWidth,
          percent: percent,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: Colors.transparent,
          progressColor: progressColor,
          center: Container(),
        ),
      ],
    );
  }
}

// Central Content Component
class _CenterContent extends StatelessWidget {
  final int netIntakeCalories;
  final CalorieData? data;
  final List<AnimationController>? controllers;

  const _CenterContent({
    required this.netIntakeCalories,
    this.data,
    this.controllers,
  });

  double getCalorieDataFontSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 32;
    } else if (screenHeight > 750) {
      return 30;
    } else {
      return 26;
    }
  }

  int _calculateDynamicCalories() {
    if (data == null || controllers == null) {
      return netIntakeCalories;
    }

    final foodController = controllers![0];
    final netIntakeController = controllers![1];
    final redTransitionController = controllers![2];
    final disappearController = controllers![3];

    if (disappearController.status == AnimationStatus.forward || 
        disappearController.status == AnimationStatus.completed) {
      return data!.netIntakeCalories;
    }

    if (redTransitionController.status == AnimationStatus.forward || 
        redTransitionController.status == AnimationStatus.completed) {
      final progress = redTransitionController.value;
      final currentValue = data!.foodCalories - (data!.foodCalories - data!.netIntakeCalories) * progress;
      return currentValue.round().clamp(data!.netIntakeCalories, data!.foodCalories);
    }

    if (foodController.status == AnimationStatus.forward || 
        foodController.status == AnimationStatus.completed) {
      return (data!.foodCalories * foodController.value).round();
    }

    return data!.netIntakeCalories;
  }

  @override
  Widget build(BuildContext context) {
    final dynamicCalories = _calculateDynamicCalories();
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$dynamicCalories',
          style: TextStyle(
            fontSize: getCalorieDataFontSize(context),
            fontWeight: FontWeight.bold,
            color: UIConstants.textColor,
          ),
        ),
        const Text(
          'kcal Net Intake',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

// Static Circle Component
class _StaticCircleWidget extends StatelessWidget {
  final CalorieData data;

  const _StaticCircleWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _CircularIndicator(
          percent: 1.0,
          progressColor: Colors.grey.shade200,
        ),
        _CenterContent(netIntakeCalories: data.netIntakeCalories),
      ],
    );
  }
}

// Animated Circle Component
class _AnimatedCircleWidget extends StatelessWidget {
  final CalorieData data;
  final Color netIntakeColor;
  final Animation<double> foodAnimation;
  final Animation<double> netIntakeAnimation;
  final Animation<double> redTransitionAnimation;
  final Animation<double> disappearAnimation;
  final AnimationController redTransitionController;
  final AnimationController disappearController;
  final List<AnimationController> controllers;

  const _AnimatedCircleWidget({
    required this.data,
    required this.netIntakeColor,
    required this.foodAnimation,
    required this.netIntakeAnimation,
    required this.redTransitionAnimation,
    required this.disappearAnimation,
    required this.redTransitionController,
    required this.disappearController,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(controllers),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Basic Grey Background
            _CircularIndicator(
              percent: 1.0,
              progressColor: Colors.grey.shade200,
            ),
            
            // Food Animation Layer
            ..._buildFoodAnimationLayers(),
            
            // Net Intake Layer - Displayed only when net intake is valid
            if (data.hasValidNetIntake && data.netIntakeProgress > 0)
              _CircularIndicator(
                percent: netIntakeAnimation.value,
                progressColor: netIntakeColor,
              ),
            
            // Centre Content
            _CenterContent(
              netIntakeCalories: data.netIntakeCalories,
              data: data,
              controllers: controllers,
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildFoodAnimationLayers() {
    final isDisappearing = disappearController.status == AnimationStatus.forward || 
                          disappearController.status == AnimationStatus.completed;
    final isTransitioningRed = redTransitionController.status == AnimationStatus.forward || 
                              redTransitionController.status == AnimationStatus.completed;

    if (isDisappearing) {
      return [
        _CircularIndicator(
          percent: disappearAnimation.value,
          progressColor: UIConstants.redColor,
        ),
      ];
    } else if (isTransitioningRed) {
      return [
        // Blue Residual
        if (foodAnimation.value > redTransitionAnimation.value)
          _CircularIndicator(
            percent: foodAnimation.value - redTransitionAnimation.value,
            progressColor: UIConstants.blueColor,
          ),
        // Red Part
        Transform.rotate(
          angle: 2 * 3.14159 * (foodAnimation.value - redTransitionAnimation.value),
          child: _CircularIndicator(
            percent: redTransitionAnimation.value,
            progressColor: UIConstants.redColor,
          ),
        ),
      ];
    } else {
      return [
        _CircularIndicator(
          percent: foodAnimation.value,
          progressColor: UIConstants.blueColor,
        ),
      ];
    }
  }
}