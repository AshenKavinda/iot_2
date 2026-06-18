import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../theme/aqua_theme.dart';
import '../widgets/flow_area_chart.dart';
import '../widgets/session_tile.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (context, prov, _) {
        return Scaffold(
          backgroundColor: AquaColors.bg,
          appBar: AppBar(
            title: const Text('Activity'),
            actions: [
              if (prov.sessions.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  tooltip: 'Clear history',
                  onPressed: () => _confirmClear(context, prov),
                ),
            ],
          ),
          body: _buildBody(prov),
        );
      },
    );
  }

  Widget _buildBody(HistoryProvider prov) {
    if (prov.hasError) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: AquaColors.errorColor, size: 44),
            SizedBox(height: 12),
            Text(
              'Failed to load history',
              style: TextStyle(fontSize: 15, color: AquaColors.textPrimary, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
    }

    final sessions = prov.sessions;
    final flowRecords = prov.flowRecords;

    if (sessions.isEmpty && flowRecords.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_toggle_off_outlined, color: AquaColors.textHint, size: 52),
            SizedBox(height: 14),
            Text(
              'No activity yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AquaColors.textSec),
            ),
            SizedBox(height: 6),
            Text(
              'Pump sessions will appear here.',
              style: TextStyle(fontSize: 13, color: AquaColors.textHint),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        if (flowRecords.isNotEmpty) ...[
          const _SectionHeader(title: 'Flow Rate'),
          const SizedBox(height: 10),
          FlowAreaChart(records: flowRecords),
          const SizedBox(height: 24),
        ],
        if (sessions.isNotEmpty) ...[
          _SectionHeader(
            title: 'Sessions',
            trailing: Text(
              '${sessions.length} total',
              style: const TextStyle(fontSize: 12, color: AquaColors.textHint, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          ...sessions.asMap().entries.map((e) => SessionTile(
                session: e.value,
                sessionNumber: sessions.length - e.key,
              )),
        ],
      ],
    );
  }

  Future<void> _confirmClear(BuildContext context, HistoryProvider prov) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear All History?'),
        content: const Text('This will permanently delete all sessions and flow records.'),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AquaColors.textSec,
            letterSpacing: 0.8,
          ),
        ),
        const Spacer(),
        if (trailing case final t?) t,
      ],
    );
  }
}
