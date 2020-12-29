import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/dice_engine/roller.dart';
import 'package:rpg_dice/dice_engine/utils.dart';
import 'package:rpg_dice/managers/theme_manager.dart';

class BalanceScreen extends StatefulWidget {
  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  var face2countMap = <int, int>{};
  var _diceSize = 6;

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

  void startBalanceCheck({int count = 10000}) async {
    setState(() {
      clearMap();
    });
    for (var i = 0; i < count; i++) {
      await Future.delayed(Duration(microseconds: 100));
      var expression = '1d$_diceSize';
      var value = Roller.roll(expression).total;
      setState(() {
        face2countMap[value]++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;

    var appbar = AppBar(
      elevation: 0,
      title: Text(
        'Balance check',
      ),
      actions: [
        FlatButton.icon(
          onPressed: () {},
          icon: Icon(
            Icons.help,
            color: theme.appbarTextColor,
          ),
          label: Text(
            'Help',
            style: TextStyle(
              color: theme.appbarTextColor,
            ),
          ),
        )
      ],
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
            Text('Balance is important!'),
            FlatButton(
              child: Text('Test balance'),
              onPressed: () => startBalanceCheck(),
            ),
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
          x: map[key],
          barRods: [
            BarChartRodData(y: map[key].toDouble(), colors: [Colors.red]),
          ],
          showingTooltipIndicators: [0],
        ));
      }
      return groups;
    }

    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxInList(map.values.toList()).toDouble() * 1.3,
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipBottomMargin: 8,
                getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  return BarTooltipItem(
                    rod.y.round().toString(),
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
