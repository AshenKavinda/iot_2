import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/session_model.dart';
import '../theme/aqua_theme.dart';

class SessionTile extends StatelessWidget {
  final SessionModel session;
  final int sessionNumber;

  const SessionTile({super.key, required this.session, required this.sessionNumber});

  Color get _borderColor {
    if (!session.isComplete) return AquaColors.textHint;
    if (session.isSuccess) return AquaColors.success;
    if (session.isWellDry) return AquaColors.warning;
    if (session.isManual) return Colors.purple;
    return AquaColors.textHint;
  }

  IconData get _outcomeIcon {
    if (!session.isComplete) return Icons.help_outline;
    if (session.isSuccess) return Icons.check_circle;
    if (session.isWellDry) return Icons.warning;
    return Icons.stop_circle;
  }

  Color get _outcomeColor {
    if (!session.isComplete) return AquaColors.textHint;
    if (session.isSuccess) return AquaColors.success;
    if (session.isWellDry) return AquaColors.warning;
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    final startTime = session.startMs > 1000000000000
        ? DateFormat('MMM d, HH:mm').format(
            DateTime.fromMillisecondsSinceEpoch(session.startMs))
        : '—';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AquaColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: _borderColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: AquaColors.textHint.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // session number badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _borderColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '#$sessionNumber',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: _borderColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // middle info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        startTime,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AquaColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: session.isManual ? Colors.purple : AquaColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    session.hasTiming ? session.durationLabel : session.startReasonLabel,
                    style: const TextStyle(fontSize: 12, color: AquaColors.textSec),
                  ),
                ],
              ),
            ),
            // right: litres + outcome icon
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${session.litresPumped.toStringAsFixed(1)} L',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AquaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(_outcomeIcon, color: _outcomeColor, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
