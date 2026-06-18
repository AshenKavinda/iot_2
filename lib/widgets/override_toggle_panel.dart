import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/status_provider.dart';
import '../theme/aqua_theme.dart';

class OverrideTogglePanel extends StatelessWidget {
  const OverrideTogglePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatusProvider>(
      builder: (context, prov, _) {
        final status = prov.status;
        final isOn = status.manualOverride;
        final wellDry = status.sensorC == 1;
        final tankFull = status.sensorA == 0 && status.sensorB == 0;
        final disabled = wellDry || tankFull;

        return Container(
          decoration: BoxDecoration(
            color: AquaColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AquaColors.textHint.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manual Override',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AquaColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Directly control the pump',
                          style: TextStyle(fontSize: 12, color: AquaColors.textSec),
                        ),
                      ],
                    ),
                  ),
                  _AquaToggle(
                    value: isOn,
                    disabled: disabled,
                    onChanged: disabled
                        ? null
                        : (val) => _confirm(context, prov, val),
                  ),
                ],
              ),
              if (wellDry) ...[
                const SizedBox(height: 12),
                _WarningStrip(
                  color: AquaColors.errorColor,
                  icon: Icons.block_outlined,
                  text: 'Well is dry — pump disabled for safety',
                ),
              ] else if (tankFull) ...[
                const SizedBox(height: 12),
                _WarningStrip(
                  color: AquaColors.primaryLight,
                  icon: Icons.check_circle_outline,
                  text: 'Tank is full — pump not needed',
                ),
              ] else if (isOn) ...[
                const SizedBox(height: 12),
                _WarningStrip(
                  color: AquaColors.warning,
                  icon: Icons.warning_amber_outlined,
                  text: 'Manual override active — device safety still applies',
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirm(
      BuildContext context, StatusProvider prov, bool val) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(val ? 'Enable Manual Override?' : 'Disable Manual Override?'),
        content: Text(
          val
              ? 'The pump will run manually. Device safety limits still apply.'
              : 'Returning to automatic control.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (ok == true) prov.setManualOverride(val);
  }
}

class _AquaToggle extends StatelessWidget {
  final bool value;
  final bool disabled;
  final ValueChanged<bool>? onChanged;

  const _AquaToggle({
    required this.value,
    required this.disabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = disabled ? AquaColors.textHint : AquaColors.primary;
    return GestureDetector(
      onTap: disabled ? null : () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        width: 52,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value && !disabled
              ? activeColor
              : AquaColors.textHint.withValues(alpha: 0.3),
        ),
        padding: const EdgeInsets.all(3),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _WarningStrip extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;

  const _WarningStrip({required this.color, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 4)),
        color: color.withValues(alpha: 0.06),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
