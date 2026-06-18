import 'package:flutter/material.dart';
import '../models/status_model.dart';
import '../theme/aqua_theme.dart';

class PumpEngineCard extends StatefulWidget {
  final StatusModel status;
  const PumpEngineCard({super.key, required this.status});

  @override
  State<PumpEngineCard> createState() => _PumpEngineCardState();
}

class _PumpEngineCardState extends State<PumpEngineCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinCtrl;

  @override
  void initState() {
    super.initState();
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.status.pumpRunning) _spinCtrl.repeat();
  }

  @override
  void didUpdateWidget(PumpEngineCard old) {
    super.didUpdateWidget(old);
    if (widget.status.pumpRunning && !_spinCtrl.isAnimating) {
      _spinCtrl.repeat();
    } else if (!widget.status.pumpRunning && _spinCtrl.isAnimating) {
      _spinCtrl.stop();
    }
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final running = widget.status.pumpRunning;
    final borderColor = running ? AquaColors.primary : AquaColors.divider;

    return Container(
      decoration: BoxDecoration(
        color: AquaColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border(top: BorderSide(color: borderColor, width: 3)),
        boxShadow: [
          BoxShadow(
            color: AquaColors.textHint.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          _PumpRing(running: running, spinCtrl: _spinCtrl),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ModePill(label: widget.status.modeLabel, running: running),
                const SizedBox(height: 4),
                Text(
                  running ? 'Pump is active' : widget.status.stopReasonLabel,
                  style: const TextStyle(
                    fontSize: 13,
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

class _PumpRing extends StatelessWidget {
  final bool running;
  final AnimationController spinCtrl;
  const _PumpRing({required this.running, required this.spinCtrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (running)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.1),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeInOut,
              builder: (_, scale, _) => Transform.scale(
                scale: scale,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AquaColors.pumpGlow.withValues(alpha: 0.35),
                      width: 6,
                    ),
                  ),
                ),
              ),
            ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: running
                  ? AquaColors.primary.withValues(alpha: 0.12)
                  : AquaColors.cardAlt,
            ),
            child: Center(
              child: RotationTransition(
                turns: spinCtrl,
                child: Icon(
                  running ? Icons.rotate_right : Icons.pause_circle_outlined,
                  color: running ? AquaColors.primary : AquaColors.textHint,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  final String label;
  final bool running;
  const _ModePill({required this.label, required this.running});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: running
            ? AquaColors.primary.withValues(alpha: 0.1)
            : AquaColors.cardAlt,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: running ? AquaColors.primary : AquaColors.textSec,
        ),
      ),
    );
  }
}
