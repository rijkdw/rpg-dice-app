import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/dice_engine/roller.dart';
import 'package:rpg_dice/dice_engine/utils.dart';
import 'package:rpg_dice/managers/distribution_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/utils.dart' as utils;
import 'dart:math' as math;

class DiceCounter extends StatefulWidget {
  // attributes
  String expression, title;
  int numRepeats;

  DiceCounter({this.expression, this.numRepeats, this.title = 'Dice Count'});

  @override
  _DiceCounterState createState() => _DiceCounterState();
}

class _DiceCounterState extends State<DiceCounter> {
  Map<int, int> map;
  double maxY;
  bool isShowingGraph = true;

  @override
  void initState() {
    populateMap();
    super.initState();
  }

  void invertView() => setState(() => isShowingGraph = !isShowingGraph);

  void populateMap() {
    map = <int, int>{};
    for (var i = 0; i < widget.numRepeats; i++) {
      var value = Roller.roll(widget.expression).total;
      if (!map.keys.contains(value)) {
        map[value] = 0;
      }
      map[value]++;
    }
    var mapKeys = map.keys.toList();
    mapKeys.sort();
    var newMap = <int, int>{};
    for (var key in mapKeys) {
      newMap[key] = map[key];
    }
    map = newMap;
    maxY = maxInList(map.values.toList()).toDouble() * 1.1;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;

    var labelStyle = TextStyle(
      color: theme.rollerCardHeadingColor,
      fontSize: 20,
    );

    // =================================================================================================
    // List view
    // =================================================================================================

    Widget _buildRow(int value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            child: Text(
              '$value:',
              style: TextStyle(fontSize: 18, color: theme.genericPrimaryTextColor),
            ),
          ),
          Container(
            width: 100,
            child: Text(
              '${map[value]}/${widget.numRepeats}',
              style: TextStyle(fontSize: 18, color: theme.genericPrimaryTextColor),
            ),
          ),
          Text(
            '${map[value] / utils.roundToNDecimals(sumList(map.values.toList()) / 100, 3)}%',
            style: TextStyle(fontSize: 18, color: theme.genericPrimaryTextColor),
          ),
        ],
      );
    }

    var listView = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: utils.intersperse(
        map.keys.map((key) => _buildRow(key)).toList(),
        () => SizedBox(height: 2),
      ),
    );

    // =================================================================================================
    // Graph view
    // =================================================================================================

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

    var graphView = Container(
      width: double.infinity,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: false,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.transparent,
              tooltipPadding: const EdgeInsets.all(0),
              tooltipBottomMargin: 0,
              getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
                return BarTooltipItem(
                  '', //rod.y.round().toString(),
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
    );

    // =================================================================================================
    // Return
    // =================================================================================================

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.title != null
                  ? Text(
                      'Distribution',
                      style: labelStyle,
                    )
                  : Container(),
              InkWell(
                child: Icon(
                  Icons.refresh,
                  color: theme.rollerCardHeadingColor,
                ),
                onTap: () {
                  setState(() {
                    populateMap();
                  });
                },
                splashColor: Colors.transparent,
              ),
            ],
          ),
          SizedBox(height: 4),
          InkWell(
            onTap: invertView,
            child: isShowingGraph ? graphView : listView,
          ),
        ],
      ),
    );
  }
}
