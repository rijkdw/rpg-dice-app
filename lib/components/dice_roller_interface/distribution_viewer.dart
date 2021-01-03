import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/dice_engine/roller.dart';
import 'package:rpg_dice/dice_engine/utils.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/utils.dart' as utils;
import 'dart:math' as math;

class DistributionViewer extends StatefulWidget {
  // -------------------------------------------------------------------------------------------------
  // attributes
  // -------------------------------------------------------------------------------------------------
  String expression, title;
  int numRepeats;

  // -------------------------------------------------------------------------------------------------
  // constructor
  // -------------------------------------------------------------------------------------------------
  DistributionViewer({this.expression, this.numRepeats, this.title = 'Dice Count'});

  @override
  _DistributionViewerState createState() => _DistributionViewerState();
}

class _DistributionViewerState extends State<DistributionViewer> {
  // -------------------------------------------------------------------------------------------------
  // attributes
  // -------------------------------------------------------------------------------------------------
  Map<int, int> map;
  double maxY;
  bool isShowingGraph = true;

  @override
  void initState() {
    populateMap();
    super.initState();
  }

  // -------------------------------------------------------------------------------------------------
  // functions
  // -------------------------------------------------------------------------------------------------

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

  // -------------------------------------------------------------------------------------------------
  // build
  // -------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------------------------------
    // variables
    // -------------------------------------------------------------------------------------------------

    var theme = Provider.of<ThemeManager>(context).theme;

    // -------------------------------------------------------------------------------------------------
    // list view tools
    // -------------------------------------------------------------------------------------------------

    TableRow _buildRow(int value) {
      return TableRow(
        children: [
          Container(
            height: 25,
            child: Text(
              '$value',
              style: TextStyle(fontSize: 18, color: theme.genericPrimaryTextColor),
            ),
          ),
          Text(
            '${map[value]}',
            style: TextStyle(fontSize: 18, color: theme.genericPrimaryTextColor),
            textAlign: TextAlign.right,
          ),
          Text(
            '${map[value] / utils.roundToNDecimals(sumList(map.values.toList()) / 100, 3)}%',
            style: TextStyle(fontSize: 18, color: theme.genericPrimaryTextColor),
            textAlign: TextAlign.right,
          ),
        ],
      );
    }

    // var listView = Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: utils.intersperse(
    //     map.keys.map((key) => _buildRow(key)).toList(),
    //     () => SizedBox(height: 2),
    //   ),
    // );

    var listView = Container(
      width: double.infinity,
      child: Table(
        defaultColumnWidth: FlexColumnWidth(),
        children: [
          TableRow(
            children: [
              Container(
                height: 25,
                child: Text(
                  'Value',
                  style: TextStyle(fontSize: 18, color: theme.genericPrimaryTextColor, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Count /${widget.numRepeats}',
                style: TextStyle(fontSize: 18, color: theme.genericPrimaryTextColor, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              Text(
                'Percentage',
                style: TextStyle(fontSize: 18, color: theme.genericPrimaryTextColor, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          ...map.keys.map((key) => _buildRow(key)).toList()
        ],
      ),
    );

    // -------------------------------------------------------------------------------------------------
    // graph view tools
    // -------------------------------------------------------------------------------------------------

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

    // -------------------------------------------------------------------------------------------------
    // return
    // -------------------------------------------------------------------------------------------------

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
                      style: TextStyle(
                        color: theme.rollerCardHeadingColor,
                        fontSize: 20,
                      ),
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
          SizedBox(height: 10),
          InkWell(
            onTap: invertView,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: isShowingGraph ? graphView : listView,
          ),
        ],
      ),
    );
  }
}
