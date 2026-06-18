import 'package:flutter/material.dart';
import '../theme/aqua_theme.dart';

class TankGaugeWidget extends StatelessWidget {
  final int sensorA;
  final int sensorB;

  const TankGaugeWidget({super.key, required this.sensorA, required this.sensorB});

  String get _levelLabel {
    if (sensorA == 0 && sensorB == 0) return 'FULL';
    if (sensorA == 0 && sensorB == 1) return 'HALF';
    return 'EMPTY';
  }

  double get _fillFraction {
    if (sensorA == 0 && sensorB == 0) return 1.0;
    if (sensorA == 0 && sensorB == 1) return 0.5;
    return 0.05;
  }

  Color get _fillColor {
    if (sensorA == 0 && sensorB == 0) return AquaColors.success;
    if (sensorA == 0 && sensorB == 1) return AquaColors.primaryLight;
    return AquaColors.errorColor;
  }

  @override
  Widget build(BuildContext context) {
    const double diameter = 160;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AquaColors.primary, width: 3),
            color: AquaColors.cardAlt,
          ),
          child: ClipOval(
            child: Stack(
              children: [
                // fill layer
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    height: diameter * _fillFraction,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _fillColor.withValues(alpha: 0.7),
                          _fillColor,
                        ],
                      ),
                    ),
                  ),
                ),
                // label overlay
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(_fillFraction * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AquaColors.textPrimary,
                        ),
                      ),
                      Text(
                        _levelLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AquaColors.textSec,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SensorPill(label: 'A', active: sensorA == 0),
            const SizedBox(width: 8),
            _SensorPill(label: 'B', active: sensorB == 0),
          ],
        ),
      ],
    );
  }
}

class _SensorPill extends StatelessWidget {
  final String label;
  final bool active;
  const _SensorPill({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active
            ? AquaColors.success.withValues(alpha: 0.15)
            : AquaColors.errorColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? AquaColors.success : AquaColors.errorColor,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: active ? AquaColors.success : AquaColors.errorColor,
        ),
      ),
    );
  }
}
