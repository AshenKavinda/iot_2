import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/status_provider.dart';
import '../theme/aqua_theme.dart';
import '../widgets/tank_gauge_widget.dart';
import '../widgets/well_status_tile.dart';
import '../widgets/pump_engine_card.dart';
import '../widgets/live_metrics_panel.dart';
import '../widgets/override_toggle_panel.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatusProvider>(
      builder: (context, prov, _) {
        return Scaffold(
          backgroundColor: AquaColors.bg,
          appBar: AppBar(
            title: const Text('AquaFlow'),
            actions: [
              if (prov.lastUpdated != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    child: Text(
                      DateFormat('HH:mm:ss').format(prov.lastUpdated!),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AquaColors.textHint,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: _buildBody(context, prov),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, StatusProvider prov) {
    if (prov.isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AquaColors.primary),
            SizedBox(height: 16),
            Text('Connecting to device…', style: TextStyle(color: AquaColors.textSec)),
          ],
        ),
      );
    }

    if (prov.hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, color: AquaColors.errorColor, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Firebase connection error',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AquaColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Check your network and database rules.',
              style: TextStyle(fontSize: 13, color: AquaColors.textSec),
            ),
          ],
        ),
      );
    }

    final status = prov.status;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        Center(
          child: TankGaugeWidget(sensorA: status.sensorA, sensorB: status.sensorB),
        ),
        const SizedBox(height: 20),
        WellStatusTile(sensorC: status.sensorC),
        const SizedBox(height: 14),
        PumpEngineCard(status: status),
        const SizedBox(height: 14),
        LiveMetricsPanel(status: status),
        const SizedBox(height: 14),
        const OverrideTogglePanel(),
      ],
    );
  }
}
