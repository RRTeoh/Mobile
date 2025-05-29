import 'package:flutter/material.dart';

// Meal card component that displays meal info, supports expand/collapse on tap, and provides visual feedback
class MealCard extends StatelessWidget {
  // Meal title
  final String title;

  // Image asset path
  final String imageAsset;

  // Recommended calories text
  final String recommendedCalories;

  // Whether the card is currently expanded
  final bool isExpanded;

  // Tap callback
  final VoidCallback onTap;

  const MealCard({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.recommendedCalories,
    required this.isExpanded,
    required this.onTap,
  });

  // Style constants
  static const EdgeInsets _contentPadding = EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0);
  static const double _imageOpacity = 0.5;
  static const double _arrowIconSize = 20.0;
  static const Duration _animationDuration = Duration(milliseconds: 300);


  @override
  Widget build(BuildContext context) {
    double getCardHeight(BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;

      if (screenHeight > 850) {
        return 100;
      } else if (screenHeight > 750) {
        return 90;
      } else {
        return 80;
      }
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: getCardHeight(context),
        decoration: _buildCardDecoration(),
        child: Row(
          children: [
            _buildContentSection(context),
            _buildImageSection(),
          ],
        ),
      ),
    );
  }

  // Build card decoration
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  // Build content section (title and calorie info)
  Widget _buildContentSection(BuildContext context) {
    double getTitleFontSize(BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;

      if (screenHeight > 850) {
        return 26;
      } else if (screenHeight > 750) {
        return 24;
      } else {
        return 22;
      }
    }

    double getRecommendFontSize(BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;

      if (screenHeight > 850) {
        return 12;
      } else if (screenHeight > 750) {
        return 11;
      } else {
        return 10;
      }
    }

    return Expanded(
      flex: 3,
      child: Padding(
        padding: _contentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title, 
              style: TextStyle(
                fontSize: getTitleFontSize(context), 
                fontWeight: FontWeight.bold,
              )
            ),
            const SizedBox(height: 2), // Add spacing for readability
            Text(
              recommendedCalories, 
              style: TextStyle(
                color: Colors.grey, 
                fontSize: getRecommendFontSize(context),
              )
            ),
          ],
        ),
      ),
    );
  }

  // Build image section (with mask and arrow icon)
  Widget _buildImageSection() {
    return Expanded(
      flex: 2,
      child: Stack(
        children: [
          _buildMaskedImage(),
          _buildArrowIcon(),
        ],
      ),
    );
  }

  // Build masked image
  Widget _buildMaskedImage() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.transparent, Colors.black],
          stops: [0.0, 0.3],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: Opacity(
        opacity: _imageOpacity,
        child: Image.asset(
          imageAsset,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          // Error handling for image loading
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(
                Icons.restaurant,
                color: Colors.grey,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }

  // Build arrow icon
  Widget _buildArrowIcon() {
    return Positioned(
      right: 10,
      bottom: 8,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white70,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: AnimatedRotation(
            duration: _animationDuration,
            turns: isExpanded ? 0.5 : 0,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[500],
              size: _arrowIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
