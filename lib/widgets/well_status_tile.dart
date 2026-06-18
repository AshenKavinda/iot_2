import 'package:flutter/material.dart';
import '../theme/aqua_theme.dart';

class WellStatusTile extends StatelessWidget {
  final int sensorC;
  const WellStatusTile({super.key, required this.sensorC});

  bool get _wellOk => sensorC == 0;

  @override
  Widget build(BuildContext context) {
    final color = _wellOk ? AquaColors.success : AquaColors.warning;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _wellOk ? Icons.water : Icons.warning_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            _wellOk ? 'WELL OK' : 'WELL DRY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
