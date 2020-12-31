import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/dice_engine/roller.dart';
import 'package:rpg_dice/dice_engine/utils.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/utils.dart' as utils;
import 'dart:math' as math;

class DiceCounter extends StatefulWidget {
  // attributes
  String expression, title;
  int numRepeats;

  DiceCounter({this.expression, this.numRepeats, this.title='Dice Count'});

  @override
  _DiceCounterState createState() => _DiceCounterState();
}

class _DiceCounterState extends State<DiceCounter> {
  Map<int, int> map;
  double maxY;
  bool isShowingMainData = true;

  @override
  void initState() {
    populateMap();
    super.initState();
  }

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

  // @override
  // Widget build(BuildContext context) {
  //   var theme = Provider.of<ThemeManager>(context).theme;
  //
  //   var labelStyle = TextStyle(
  //     color: theme.rollerHistoryLabelColor,
  //     fontSize: 16,
  //   );
  //
  //   List<LineChartBarData> linesBarData1() {
  //     final LineChartBarData lineChartBarData1 = LineChartBarData(
  //       spots: map.keys.map((key) => FlSpot(key.toDouble(), (map[key] / widget.numRepeats))).toList(),
  //       isCurved: false,
  //       colors: [
  //         Colors.red,
  //       ],
  //       barWidth: 8,
  //       isStrokeCapRound: true,
  //       dotData: FlDotData(
  //         show: false,
  //       ),
  //       belowBarData: BarAreaData(
  //         show: false,
  //       ),
  //     );
  //     return [
  //       lineChartBarData1,
  //     ];
  //   }
  //
  //   LineChartData sampleData1() {
  //     return LineChartData(
  //       lineTouchData: LineTouchData(
  //         touchTooltipData: LineTouchTooltipData(
  //           tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
  //         ),
  //         touchCallback: (LineTouchResponse touchResponse) {},
  //         handleBuiltInTouches: true,
  //       ),
  //       gridData: FlGridData(
  //         show: false,
  //       ),
  //       titlesData: FlTitlesData(
  //         bottomTitles: SideTitles(
  //           showTitles: true,
  //           reservedSize: 22,
  //           getTextStyles: (value) => const TextStyle(
  //             color: Colors.black,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 16,
  //           ),
  //           margin: 10,
  //           getTitles: (value) {
  //             return '${value.toInt()}';
  //           },
  //         ),
  //         leftTitles: SideTitles(
  //           showTitles: true,
  //           interval: 0.1,
  //           getTextStyles: (value) => const TextStyle(
  //             color: Colors.black,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 14,
  //           ),
  //         ),
  //       ),
  //       borderData: FlBorderData(
  //         show: true,
  //         border: const Border(
  //           bottom: BorderSide(
  //             color: Colors.black,
  //             width: 4,
  //           ),
  //           left: BorderSide(
  //             color: Colors.transparent,
  //           ),
  //           right: BorderSide(
  //             color: Colors.transparent,
  //           ),
  //           top: BorderSide(
  //             color: Colors.transparent,
  //           ),
  //         ),
  //       ),
  //       minX: 0,
  //       // maxX: 14,
  //       // maxY: 4,
  //       minY: 0,
  //       lineBarsData: linesBarData1(),
  //     );
  //   }
  //
  //   return AspectRatio(
  //     aspectRatio: 1.23,
  //     child: Stack(
  //       children: <Widget>[
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             widget.title != null
  //                 ? Text(
  //                     'Distribution',
  //                     style: labelStyle,
  //                   )
  //                 : Container(),
  //             InkWell(
  //               child: Icon(
  //                 Icons.refresh,
  //                 color: theme.rollerHistoryLabelColor,
  //               ),
  //               onTap: () {
  //                 setState(() {
  //                   populateMap();
  //                 });
  //               },
  //               splashColor: Colors.transparent,
  //             ),
  //           ],
  //         ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: <Widget>[
  //             Expanded(
  //               child: Padding(
  //                 padding: const EdgeInsets.only(right: 16.0, left: 6.0),
  //                 child: LineChart(
  //                   sampleData1(),
  //                   swapAnimationDuration: const Duration(milliseconds: 250),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;

    var labelStyle = TextStyle(
      color: theme.rollerHistoryLabelColor,
      fontSize: 16,
    );

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
                  color: theme.rollerHistoryLabelColor,
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
          Container(
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
          ),
        ],
      ),
    );
  }
}
