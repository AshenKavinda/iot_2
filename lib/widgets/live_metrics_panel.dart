import 'package:flutter/material.dart';
import '../models/status_model.dart';
import '../theme/aqua_theme.dart';

class LiveMetricsPanel extends StatelessWidget {
  final StatusModel status;
  const LiveMetricsPanel({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AquaColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border(top: BorderSide(color: AquaColors.primaryLight, width: 3)),
        boxShadow: [
          BoxShadow(
            color: AquaColors.textHint.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MetricRow(
            icon: Icons.speed,
            iconColor: AquaColors.primary,
            label: 'Flow Rate',
            value: status.flowRateLPM.toStringAsFixed(1),
            unit: 'L/min',
          ),
          const Divider(height: 1),
          _MetricRow(
            icon: Icons.opacity,
            iconColor: AquaColors.primaryLight,
            label: 'This Session',
            value: status.sessionLitres.toStringAsFixed(1),
            unit: 'L',
          ),
          const Divider(height: 1),
          _MetricRow(
            icon: Icons.storage,
            iconColor: AquaColors.textSec,
            label: 'Total Since Boot',
            value: status.totalLitresSinceBoot.toStringAsFixed(1),
            unit: 'L',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;
  final bool isLast;

  const _MetricRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, isLast ? 12 : 14, 16, isLast ? 14 : 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AquaColors.textSec,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AquaColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AquaColors.textSec,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
