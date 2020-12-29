import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/dice_engine/ast/nodes/die.dart';
import 'package:rpg_dice/dice_engine/roller.dart';
import 'package:rpg_dice/dice_engine/utils.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/dice_engine/state.dart' as state;
import 'package:rpg_dice/utils.dart';

class BalanceScreen extends StatefulWidget {
  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  var face2countMap = <int, int>{};
  var _diceSize = 6;
  var _count = 10000;
  var _progress = 0;

  var _testIsRunning = false;

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
      _testIsRunning = true;
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
    });
  }

  void stopBalanceCheck() async {
    setState(() {
      _testIsRunning = false;
    });
    await Future.delayed(Duration(microseconds: 100));
    setState(() {
      clearMap();
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;

    var appbar = AppBar(
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

    var countViewer = _CountViewer(face2countMap);

    return Scaffold(
      appBar: appbar,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: double.infinity,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              'Dice balance is important!\nEvaluate the app\'s balance when\nrolling a d$_diceSize ${demarcateThousands(_count)} times.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 15),
            RaisedButton(
              elevation: 0,
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: Text(
                  _testIsRunning ? '$_progress' : 'Start test',
                  style: TextStyle(color: theme.newFormFieldButtonTextColor),
                ),
              ),
              color: theme.newFormFieldButtonColor,
              onPressed: () {
                if (_testIsRunning) {
                  stopBalanceCheck();
                } else {
                  startBalanceCheck();
                }
              },
            ),
            SizedBox(height: 15),
            countViewer,
          ],
        ),
      ),
    );
  }
}

class _CountViewer extends StatelessWidget {
  Map<int, int> map;

  _CountViewer(this.map);

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> _getBarGroups() {
      var groups = <BarChartGroupData>[];
      for (var key in map.keys) {
        groups.add(BarChartGroupData(
          x: key,
          barRods: [
            BarChartRodData(
              y: map[key].toDouble(),
              colors: [Color.fromRGBO(180, 0, 0, 1), Colors.red],
              width: 12,
            ),
          ],
          showingTooltipIndicators: [0],
        ));
      }
      return groups;
    }

    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
        width: double.infinity,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxInList(map.values.toList()).toDouble() + 100,
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipBottomMargin: 0,
                getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
                  return BarTooltipItem(
                    rod.y > 0 ? rod.y.round().toString() : '',
                    TextStyle(
                      color: Colors.red,
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
                getTextStyles: (value) => const TextStyle(color: Colors.black),
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
