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
  static const double _iconSize = 24.0;
  static const double _spacing = 6.0;
  
  // Text Style Constants
  static const TextStyle _titleStyle = TextStyle(
    fontSize: 10,
    color: Colors.grey,
  );
  
  static const TextStyle _valueStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Color(0xff333333),
  );

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
            size: _iconSize,
          ),
          const SizedBox(width: _spacing),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(stat.title, style: _titleStyle),
              Text(
                '${stat.value} kcal',
                style: _valueStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}