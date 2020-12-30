import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/count_viewer.dart';
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
    });
    // await Future.delayed(Duration(milliseconds: 500));
    setState(() {
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

    var countViewer = CountViewer(
      map: face2countMap,
      showTooltips: !_testIsRunning,
    );

    var headingText = 'Dice balance is important!\nEvaluate the app\'s balance when\nrolling a d$_diceSize ${utils.demarcateThousands(_count)} times.';

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
              style: TextStyle(fontSize: 18, color: theme.genericTextColor),
            ),
            SizedBox(height: 15),
            RaisedButton(
              elevation: 0,
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: Text(
                  _testIsRunning ? utils.demarcateThousands(_progress) : 'Start test',
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
            countViewer,
          ],
        ),
      ),
    );
  }
}