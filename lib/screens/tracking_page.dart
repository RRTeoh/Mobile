import 'package:flutter/material.dart';
import 'nutrition_page.dart';
import 'workout_page.dart';

// TrackerPage
class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  // NutritionPage Controller
  final GlobalKey<NutritionPageState> _nutritionKey = GlobalKey();

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
            const SizedBox(height: 40),
            _buildSwitchBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: _onPageChanged,
                children: [
                  const WorkoutPage(),
                  NutritionPage(key: _nutritionKey),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitchBar() {
    return Container(
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
        padding: const EdgeInsets.symmetric(horizontal: 30),
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
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}


// class TrackingPage extends StatelessWidget {
//   const TrackingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/images/travel.jpg',
//               width: 200,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//             const SizedBox(height: 30),
//             const Text(
//               "Discover, Wander, Experience: Your Journey Begins Here!",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Embark on unforgettable adventures with our premier tourist agency.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
