import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PremiumNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PremiumNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<PremiumNavBar> createState() => _PremiumNavBarState();
}

class _PremiumNavBarState extends State<PremiumNavBar> {
  Widget navItem(IconData icon, int index) {
    bool active = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 26,
          color: active ? AppTheme.primary : Colors.grey.shade400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      width: double.infinity,
      height: 60 + bottom,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          /// Background navbar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60 + bottom,
              padding: EdgeInsets.only(bottom: bottom),
              decoration: BoxDecoration(
                color: Colors.white,

                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(0, -3),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  navItem(Icons.home_rounded, 0),
                  navItem(Icons.article_rounded, 1),
                  navItem(Icons.calculate_rounded, 2),
                  navItem(Icons.history_rounded, 3),
                  navItem(Icons.info_rounded, 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
