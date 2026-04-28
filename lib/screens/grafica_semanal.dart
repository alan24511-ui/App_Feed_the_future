import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficaSemanal extends StatelessWidget {
  final List<double> caloriasSemana;
  final Function(int) onBarTap;

  const GraficaSemanal({
    super.key,
    required this.caloriasSemana,
    required this.onBarTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            touchCallback: (event, response) {
              if (response != null && response.spot != null) {
                onBarTap(response.spot!.touchedBarGroupIndex);
              }
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const dias = ["L", "M", "M", "J", "V", "S", "D"];
                  return Text(dias[value.toInt()]);
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: caloriasSemana
              .asMap()
              .entries
              .map(
                (e) => BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value,
                  borderRadius: BorderRadius.circular(6),
                )
              ],
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}