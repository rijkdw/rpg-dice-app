import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/utils.dart' as utils;

class CountViewer extends StatelessWidget {
  Map<int, int> map;
  bool showTooltips;

  CountViewer({this.map, this.showTooltips = true});

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;

    List<BarChartGroupData> _getBarGroups() {
      var groups = <BarChartGroupData>[];
      for (var key in map.keys) {
        groups.add(BarChartGroupData(
          x: key,
          barRods: [
            BarChartRodData(
              y: map[key].toDouble(),
              colors: theme.balanceBarColors,
              width: 12,
            ),
          ],
          showingTooltipIndicators: [0],
        ));
      }
      return groups;
    }

    String getToolTip(int y) {
      var count = utils.sumList(map.values.toList());
      var perc = utils.roundToNDecimals(y / count * 100, 2);
      return utils.demarcateThousands(y.round()) + '\n$perc%';
    }

    return Card(
      color: theme.balanceCardColor,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
        width: double.infinity,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 2000, //maxInList(map.values.toList()).toDouble() + 100,
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipBottomMargin: 0,
                getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
                  return BarTooltipItem(
                    rod.y > 0 ? getToolTip(rod.y.round()) : '',
                    TextStyle(
                      color: theme.balanceHeadingColor,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => TextStyle(color: theme.balanceAxesTextColor),
                margin: 10,
                getTitles: (double value) => '${value.toInt()}',
              ),
              leftTitles: SideTitles(showTitles: false),
            ),
            borderData: FlBorderData(show: false),
            barGroups: _getBarGroups(),
          ),
        ),
      ),
    );
  }
}
