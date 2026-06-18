import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../providers/status_provider.dart';
import '../theme/aqua_theme.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AquaColors.bg,
      appBar: AppBar(title: const Text('Config')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          _SectionLabel(label: 'CONNECTION'),
          const SizedBox(height: 8),
          Consumer<StatusProvider>(
            builder: (context, prov, _) {
              final String stateLabel;
              final Color stateColor;
              final IconData stateIcon;

              if (prov.isLoading) {
                stateLabel = 'Connecting…';
                stateColor = AquaColors.textHint;
                stateIcon = Icons.sync;
              } else if (prov.hasError) {
                stateLabel = 'Connection error';
                stateColor = AquaColors.errorColor;
                stateIcon = Icons.cloud_off_outlined;
              } else {
                stateLabel = 'Live — Firebase RTDB';
                stateColor = AquaColors.success;
                stateIcon = Icons.cloud_done_outlined;
              }

              return _InfoCard(
                children: [
                  _InfoRow(
                    icon: stateIcon,
                    iconColor: stateColor,
                    label: 'Status',
                    value: stateLabel,
                    valueColor: stateColor,
                  ),
                  const Divider(height: 1),
                  _InfoRow(
                    icon: Icons.device_hub_outlined,
                    iconColor: AquaColors.textSec,
                    label: 'Database path',
                    value: '/status',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          _SectionLabel(label: 'TANK THRESHOLDS'),
          const SizedBox(height: 8),
          _InfoCard(
            children: [
              _InfoRow(
                icon: Icons.water_drop,
                iconColor: AquaColors.success,
                label: 'Full',
                value: 'Sensor A=0, B=0',
              ),
              const Divider(height: 1),
              _InfoRow(
                icon: Icons.water_drop_outlined,
                iconColor: AquaColors.primaryLight,
                label: 'Half',
                value: 'Sensor A=0, B=1',
              ),
              const Divider(height: 1),
              _InfoRow(
                icon: Icons.water_drop_outlined,
                iconColor: AquaColors.errorColor,
                label: 'Empty',
                value: 'Sensor A=1, B=1',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionLabel(label: 'DATA'),
          const SizedBox(height: 8),
          Consumer<HistoryProvider>(
            builder: (context, prov, _) {
              return _InfoCard(
                children: [
                  _InfoRow(
                    icon: Icons.history,
                    iconColor: AquaColors.textSec,
                    label: 'Sessions recorded',
                    value: '${prov.sessions.length}',
                  ),
                  const Divider(height: 1),
                  _InfoRow(
                    icon: Icons.timeline,
                    iconColor: AquaColors.textSec,
                    label: 'Flow records',
                    value: '${prov.flowRecords.length}',
                  ),
                  const Divider(height: 1),
                  _ActionRow(
                    icon: Icons.delete_sweep_outlined,
                    iconColor: AquaColors.errorColor,
                    label: 'Clear all history',
                    onTap: prov.sessions.isEmpty && prov.flowRecords.isEmpty
                        ? null
                        : () => _confirmClear(context, prov),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          _SectionLabel(label: 'ABOUT'),
          const SizedBox(height: 8),
          _InfoCard(
            children: [
              const _InfoRow(
                icon: Icons.water,
                iconColor: AquaColors.primary,
                label: 'App',
                value: 'AquaFlow',
              ),
              const Divider(height: 1),
              const _InfoRow(
                icon: Icons.build_outlined,
                iconColor: AquaColors.textSec,
                label: 'Platform',
                value: 'Flutter + Firebase RTDB',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, HistoryProvider prov) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear All History?'),
        content: const Text('This will permanently delete all sessions and flow records from Firebase.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AquaColors.errorColor),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (ok == true) prov.clearHistory();
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AquaColors.textHint,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AquaColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AquaColors.textHint.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: AquaColors.textSec),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AquaColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback? onTap;

  const _ActionRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: onTap != null ? iconColor : AquaColors.textHint, size: 18),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: onTap != null ? iconColor : AquaColors.textHint,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: onTap != null ? AquaColors.textHint : AquaColors.divider,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
