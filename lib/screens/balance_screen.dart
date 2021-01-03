import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/dice_roller_interface/distribution_viewer.dart';
import 'package:rpg_dice/dice_engine/ast/nodes/die.dart';
import 'package:rpg_dice/dice_engine/utils.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/dice_engine/state.dart' as state;
import 'package:rpg_dice/utils.dart' as utils;

class BalanceScreen extends StatefulWidget {
  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  var face2countMap = <int, int>{};
  var _diceSize = 6;
  var _count = 100000;
  var _progress = 0;

  var _testIsRunning = false;
  var _showToolTips = false;

  @override
  void initState() {
    for (var i = 1; i <= _diceSize; i++) {
      face2countMap[i] = 0;
    }
    super.initState();
  }

  void clearMap() {
    for (var i = 1; i <= _diceSize; i++) {
      face2countMap[i] = 0;
    }
  }

  void startBalanceCheck() async {
    setState(() {
      clearMap();
    });
    // await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _testIsRunning = true;
      _showToolTips = false;
    });
    for (var i = 0; i < _count && _testIsRunning; i++) {
      await Future.delayed(Duration(microseconds: 50));
      // var expression = '1d$_diceSize';
      // var value = Roller.roll(expression).total;
      var value = Die.roll(_diceSize).value;
      state.numRollsMade = 0;
      setState(() {
        _progress = i;
        face2countMap[value]++;
      });
    }
    setState(() {
      _testIsRunning = false;
      _showToolTips = true;
    });
  }

  void stopBalanceCheck() async {
    setState(() {
      _testIsRunning = false;
      _showToolTips = false;
    });
    await Future.delayed(Duration(microseconds: 100));
    setState(() {
      clearMap();
      _showToolTips = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;

    var appbar = AppBar(
      backgroundColor: theme.appbarColor,
      elevation: 0,
      title: Text(
        'Balance check',
      ),
      // actions: [
      //   FlatButton.icon(
      //     onPressed: () {},
      //     icon: Icon(
      //       Icons.help,
      //       color: theme.appbarTextColor,
      //     ),
      //     label: Text(
      //       'Help',
      //       style: TextStyle(
      //         color: theme.appbarTextColor,
      //       ),
      //     ),
      //   )
      // ],
    );

    var headingText =
        'Dice balance is important!\nEvaluate the app\'s balance when\nrolling a d$_diceSize ${utils.demarcateThousands(_count)} times.';

    return Scaffold(
      backgroundColor: theme.genericCanvasColor,
      appBar: appbar,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: double.infinity,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              headingText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: theme.genericPrimaryTextColor),
            ),
            SizedBox(height: 15),
            RaisedButton(
              elevation: 0,
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: Text(
                  _testIsRunning ? utils.demarcateThousands(_progress) : 'START TEST',
                  style: TextStyle(color: theme.genericButtonTextColor),
                ),
              ),
              color: theme.genericButtonColor,
              onPressed: () {
                if (_testIsRunning) {
                  stopBalanceCheck();
                } else {
                  startBalanceCheck();
                }
              },
            ),
            SizedBox(height: 15),
            _CountViewer(
              map: face2countMap,
              showTooltips: !_testIsRunning && _showToolTips,
              maxY: _count / _diceSize * 1.2,
            ),
          ],
        ),
      ),
    );
  }
}

class _CountViewer extends StatelessWidget {
  Map<int, int> map;
  double maxY;
  bool showTooltips;

  _CountViewer({this.map, this.maxY, this.showTooltips = true});

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
      var perc = utils.roundToNDecimals(y / (count+1) * 100, 2);
      return utils.demarcateThousands(y.round()) + '\n$perc%';
    }

    return Card(
      color: theme.genericCardColor,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
        width: double.infinity,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY, //maxInList(map.values.toList()).toDouble() + 100,
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipBottomMargin: 0,
                getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
                  return BarTooltipItem(
                    showTooltips ? getToolTip(rod.y.round()) : '',
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
