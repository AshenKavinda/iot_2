import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/flow_record_model.dart';
import '../theme/aqua_theme.dart';

class FlowAreaChart extends StatelessWidget {
  final List<FlowRecordModel> records;
  const FlowAreaChart({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Container(
        height: 160,
        alignment: Alignment.center,
        child: const Text('No flow data yet', style: TextStyle(color: AquaColors.textHint)),
      );
    }

    final shown = records.length > 20 ? records.sublist(0, 20) : records;
    final spots = shown.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.flowRateLPM);
    }).toList();

    final maxY = shown.map((r) => r.flowRateLPM).fold(0.0, (a, b) => a > b ? a : b);

    return Container(
      height: 180,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: AquaColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border(top: BorderSide(color: AquaColors.primary, width: 3)),
        boxShadow: [
          BoxShadow(
            color: AquaColors.textHint.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AquaColors.primary.withValues(alpha: 0.08),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (val, _) => Text(
                  val.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AquaColors.textSec,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (shown.length / 4).ceilToDouble(),
                getTitlesWidget: (val, _) {
                  final idx = val.toInt();
                  if (idx < 0 || idx >= shown.length) return const SizedBox.shrink();
                  final t = DateTime.fromMillisecondsSinceEpoch(shown[idx].epochMs);
                  return Text(
                    DateFormat('HH:mm').format(t),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AquaColors.textSec,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: AquaColors.primary.withValues(alpha: 0.1)),
          ),
          minY: 0,
          maxY: maxY * 1.3 + 0.5,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AquaColors.primary,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                  radius: 3,
                  color: AquaColors.primary,
                  strokeWidth: 1.5,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AquaColors.primary.withValues(alpha: 0.22),
                    AquaColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
