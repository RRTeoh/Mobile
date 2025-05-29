import 'package:flutter/material.dart';

// Nutrition statistics data model
class NutritionStat {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const NutritionStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

// Top Statistical Row
class TopStatsRow extends StatelessWidget {
  final int baseGoal;
  final int foodCalories;
  final int exerciseCalories;
  
  const TopStatsRow({
    super.key,
    required this.baseGoal,
    required this.foodCalories,
    required this.exerciseCalories,
  });

  static const EdgeInsets _cardSpacing = EdgeInsets.only(right: 5);

  @override
  Widget build(BuildContext context) {
    final stats = _buildStats();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: stats.map((stat) => Padding(
        padding: _cardSpacing,
        child: TopStatCard(stat: stat),
      )).toList(),
    );
  }

  List<NutritionStat> _buildStats() {
    return [
      NutritionStat(
        title: 'Base Goal',
        value: baseGoal,
        icon: Icons.flag,
        color: Colors.orange,
      ),
      NutritionStat(
        title: 'Food',
        value: foodCalories,
        icon: Icons.restaurant,
        color: Colors.blue,
      ),
      NutritionStat(
        title: 'Exercise',
        value: exerciseCalories,
        icon: Icons.local_fire_department,
        color: Colors.red,
      ),
    ];
  }
}

// Statistical cards
class TopStatCard extends StatelessWidget {
  final NutritionStat stat;
  
  const TopStatCard({
    super.key,
    required this.stat,
  });

  // Style Constants
  static const EdgeInsets _containerPadding = EdgeInsets.fromLTRB(0, 0, 3, 0);
  static const BorderRadius _borderRadius = BorderRadius.all(Radius.circular(12));
  static const double _spacing = 6.0;

  double getIconSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 32;
    } else if (screenHeight > 750) {
      return 28;
    } else {
      return 24;
    }
  }

  double getTitleFontSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 12;
    } else if (screenHeight > 750) {
      return 11;
    } else {
      return 10;
    }
  }

  double getValueFontSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 14;
    } else if (screenHeight > 750) {
      return 13;
    } else {
      return 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _containerPadding,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: _borderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            stat.icon,
            color: stat.color,
            size: getIconSize(context),
          ),
          const SizedBox(width: _spacing),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                stat.title, 
                style: TextStyle(
                  fontSize: getTitleFontSize(context),
                  color: Colors.grey,
                )
              ),
              Text(
                '${stat.value} kcal',
                style: TextStyle(
                  fontSize: getValueFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: Color(0xff333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}