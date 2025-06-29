import 'package:flutter/material.dart';
import 'nutrition_page.dart';
import 'package:asgm1/screens/workout_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

// TrackerPage
class TrackingPage extends StatefulWidget {
  final VoidCallback? onCaloriesUpdated;
  const TrackingPage({super.key, this.onCaloriesUpdated});

  @override
  State<TrackingPage> createState() => TrackerPageState();
}

class TrackerPageState extends State<TrackingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  // NutritionPage Controller
  final GlobalKey<NutritionPageState> _nutritionKey = GlobalKey();

  DateTime? _earliestDate;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserId = user.uid;
        _earliestDate = user.metadata.creationTime;
      });
    }
  }

  EdgeInsets getSwitchBarMargin(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return const EdgeInsets.only(top: 45, bottom: 10);
    } else if (screenHeight > 750) {
      return const EdgeInsets.only(top: 40, bottom: 10);
    } else {
      return const EdgeInsets.only(top: 35, bottom: 10);
    }
  }

  EdgeInsets getSwitchBarPadding(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return const EdgeInsets.symmetric(horizontal: 30);
    } else if (screenHeight > 750) {
      return const EdgeInsets.symmetric(horizontal: 28);
    } else {
      return const EdgeInsets.symmetric(horizontal: 24);
    }
  }

  double getSwitchBarFontSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 18;
    } else if (screenHeight > 750) {
      return 17;
    } else {
      return 16;
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
      // If switching to the Nutrition page, the status is reset.
      if (index == 1) {
        _nutritionKey.currentState?.resetToDefault();
      }
    });
  }

  void _handleCaloriesUpdated() {
    widget.onCaloriesUpdated?.call();
  }

  // Method to switch to nutrition tab
  void switchToNutrition() {
    _onTabTapped(1); // Switch to nutrition tab (index 1)
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background gradient
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff8fd4e8), Colors.white],
              ),
            ),
          ),
        ),

        // White background
        Positioned(
          top: MediaQuery.of(context).size.height * 0.6,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(color: Colors.white),
        ),

        Column(
          children: [
            _buildSwitchBar(context),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: _onPageChanged,
                children: [
                  WorkoutPage(nutritionPageKey: _nutritionKey),
                  NutritionPage(
                    key: _nutritionKey,
                    earliestDate: _earliestDate,
                    userId: _currentUserId ?? 'anonymous',
                    onCaloriesUpdated: _handleCaloriesUpdated,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitchBar(BuildContext context) {
    return Container(
      margin: getSwitchBarMargin(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabButton('Workout', 0),
          _buildTabButton('Nutrition', 1),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        padding: getSwitchBarPadding(context),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff004aad) : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(index == 0 ? 20 : 0),
            right: Radius.circular(index == 1 ? 20 : 0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: getSwitchBarFontSize(context),
          ),
        ),
      ),
    );
  }
}
