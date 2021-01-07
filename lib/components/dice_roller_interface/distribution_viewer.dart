import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/dice_engine/roller.dart';
import 'package:rpg_dice/dice_engine/utils.dart';
import 'package:rpg_dice/managers/distribution_manager.dart';
import 'package:rpg_dice/managers/preferences_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/utils.dart' as utils;

Map<int, int> _callback(Map<String, dynamic> values) {
  int numRepeats = values['numRepeats'];
  String expression = values['expression'];
  var map = <int, int>{};
  for (var i = 0; i < numRepeats; i++) {
    var value = Roller.roll(expression).total;
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
  return map;
}

Future<Map<int, int>> populateMap(String expression, int numRepeats) async {
  return await compute(_callback, {'numRepeats': numRepeats, 'expression': expression});
}

double getMaxYFromMap(Map<int, int> map) => maxInList(map.values.toList()).toDouble() * 1.1;

class DistributionViewer extends StatefulWidget {
  // -------------------------------------------------------------------------------------------------
  // attributes
  // -------------------------------------------------------------------------------------------------
  DiceCollection diceCollection;
  int numRepeats;
  ScrollController pageViewController;

  // -------------------------------------------------------------------------------------------------
  // constructor
  // -------------------------------------------------------------------------------------------------
  DistributionViewer({this.diceCollection, this.numRepeats, this.pageViewController});

  @override
  _DistributionViewerState createState() => _DistributionViewerState();
}

class _DistributionViewerState extends State<DistributionViewer> {
  // -------------------------------------------------------------------------------------------------
  // attributes
  // -------------------------------------------------------------------------------------------------
  bool isShowingGraph = true;
  bool isHidden = false;
  Future distributionFuture;

  @override
  void initState() {
    // get the graph/list view from the PreferencesManager
    Provider.of<PreferencesManager>(context, listen: false).getDistributionViewPreference().then((value) {
      setState(() {
        isShowingGraph = value;
      });
    });
    // get the distribution if it exists from the DistributionManager
    var distributionManager = Provider.of<DistributionManager>(context, listen: false);
    if (distributionManager.hasDistribution(widget.diceCollection.id)) {
      distributionFuture = Future.delayed(Duration(microseconds: 1), () {
        return distributionManager.getDistribution(widget.diceCollection.id);
      });
    } else {
      refreshDistribution();
    }
    super.initState();
  }

  // -------------------------------------------------------------------------------------------------
  // functions
  // -------------------------------------------------------------------------------------------------

  void invertView() {
    setState(() => isShowingGraph = !isShowingGraph);
    Provider.of<PreferencesManager>(context, listen: false).setDistributionViewPreference(isShowingGraph);
  }

  void refreshDistribution() {
    print('Refreshing distribution');
    setState(() {
      distributionFuture = populateMap(widget.diceCollection.expression, widget.numRepeats);
    });
    var distributionManager = Provider.of<DistributionManager>(context, listen: false);
    distributionFuture.then((value) => distributionManager.setDistribution(widget.diceCollection.id, value));
  }

  // -------------------------------------------------------------------------------------------------
  // build
  // -------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: distributionFuture,
      builder: (context, snapshot) {
        // -------------------------------------------------------------------------------------------------
        // variables
        // -------------------------------------------------------------------------------------------------

        var theme = Provider.of<ThemeManager>(context).theme;

        // -------------------------------------------------------------------------------------------------
        // widgets
        // -------------------------------------------------------------------------------------------------

        Widget theView;
        if (snapshot.connectionState == ConnectionState.done) {
          var map = Map<int, int>.from(snapshot.data);
          var maxY = getMaxYFromMap(map);

          // Build a row in the table.
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

          // Make the bars for the bar chart.
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

          if (isShowingGraph) {
            // Make a graph view.
            theView = Container(
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
          } else {
            // Make a list view.
            theView = Container(
              width: double.infinity,
              child: Table(
                defaultColumnWidth: FlexColumnWidth(),
                children: [
                  // Make a header for the table: value | #/count | percentage
                  TableRow(
                    children: [
                      Container(
                        height: 25,
                        child: Text(
                          'Value',
                          style: TextStyle(
                              fontSize: 18, color: theme.genericPrimaryTextColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '# /${utils.demarcateThousands(widget.numRepeats)}',
                        style:
                            TextStyle(fontSize: 18, color: theme.genericPrimaryTextColor, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        '%',
                        style:
                            TextStyle(fontSize: 18, color: theme.genericPrimaryTextColor, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  ...map.keys.map((key) => _buildRow(key)).toList()
                ],
              ),
            );
          }
        } else {
          // If no data to show, just return a circular progress thing.
          theView = Container(
            width: double.infinity,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 101),
                child: SpinKitFoldingCube(
                  color: theme.rollerReadyIconColor,
                ),
              ),
            ),
          );
        }

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
                  Text(
                    'Distribution',
                    style: TextStyle(
                      color: theme.rollerCardHeadingColor,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.refresh,
                            color: theme.rollerCardHeadingColor,
                          ),
                        ),
                        onTap: () {
                          refreshDistribution();
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      InkWell(
                        child: Container(
                          child: Icon(
                            isHidden ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                            size: 30,
                            color: theme.rollerCardHeadingColor,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isHidden = !isHidden;
                          });
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ],
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: Column(
                  children: [
                    SizedBox(height: 10),
                    InkWell(
                      onTap: invertView,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: theView,
                    ),
                  ],
                ),
                secondChild: Container(),
                crossFadeState: isHidden ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 300),
              ),
            ],
          ),
        );
      },
    );
  }
}
