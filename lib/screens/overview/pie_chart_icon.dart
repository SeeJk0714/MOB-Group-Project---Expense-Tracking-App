import 'package:flutter/material.dart';

class PieChartIcon extends StatelessWidget {
  const PieChartIcon({
    super.key,
    required this.icon,
    required this.size,
    required this.borderColor,
  });

  final IconData icon;
  final double size;
  final Color borderColor;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.long1,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2.0,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black,
            offset: Offset(3.0, 3.0),
            blurRadius: 3.0,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.15),
      child: Center(
        child: Icon(icon),
      ),
    );
  }
}
