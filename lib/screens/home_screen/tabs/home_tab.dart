import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller for the glowing button
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Glow intensity animation (0 → 1)
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 70),
          //name of the app
          const Text(
            'ChatVocab',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          // Subtitle
          const Text(
            'Practice your chat words',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 60),

          // ----------------------------
          // START PRACTICE BUTTON (GLOW)
          // ----------------------------
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withValues(
                        alpha: (0.5 * _glowAnimation.value),
                      ),
                      blurRadius: 20,
                      spreadRadius: 5 * _glowAnimation.value,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    print("Start Practice pressed!");
                    context.pushNamed('practice');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent.withValues(
                      alpha: 0.7,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 25,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Start Practice",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),

          _buildStreakIndicator(),

          const SizedBox(height: 50),

          // ----------------------------
          // THREE STAT CARDS (Accuracy / Words / Weak Words)
          // ----------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatsCard("Accuracy", "95%", Colors.transparent, 43.w),

              _buildStatsCard(
                "Practiced\nToday",
                "20",
                Colors.transparent,
                43.w,
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildStatsCard("Weak Words", "5", Colors.transparent, 90.w),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // CARD: Reusable stat box (Accuracy, Words Today...)
  // --------------------------------------------------
  Widget _buildStatsCard(
    String title,
    String value,
    Color color,
    double width,
  ) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1.0,
        ),
        color: const Color(0xFF2C3E50).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // STREAK BADGE (🔥 3-day streak)
  // --------------------------------------------------
  Widget _buildStreakIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            color: Colors.orangeAccent,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            "3-day streak",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
