import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/theme_manager.dart';

class Action {
  IconData iconData;
  double iconSize;
  void Function() onTap;

  Action({this.iconData, this.iconSize=24.0, this.onTap});
}

// ignore: must_be_immutable
class InterfaceCard extends StatefulWidget {
  // -------------------------------------------------------------------------------------------------
  // attributes
  // -------------------------------------------------------------------------------------------------
  bool expandable, initiallyExpanded;
  int transitionTime;
  Widget Function() secondChild;
  Widget child;
  String title;
  List<Action> actions;

  // -------------------------------------------------------------------------------------------------
  // constructor
  // -------------------------------------------------------------------------------------------------
  InterfaceCard({
    this.transitionTime = 300,
    this.expandable = false,
    this.initiallyExpanded = true,
    this.secondChild,
    this.child,
    this.title,
    this.actions,
  });

  @override
  _InterfaceCardState createState() => _InterfaceCardState();
}

class _InterfaceCardState extends State<InterfaceCard> {
  // -------------------------------------------------------------------------------------------------
  // attributes
  // -------------------------------------------------------------------------------------------------
  bool isExpanded = true;

  // -------------------------------------------------------------------------------------------------
  // functions
  // -------------------------------------------------------------------------------------------------

  Widget buildSecondChild() {
    if (widget.secondChild == null) {
      return Container();
    } else {
      return widget.secondChild();
    }
  }

  Widget getAction({Action action, void Function() onTap, IconData iconData, double iconSize = 24.0}) {
    var theme = Provider.of<ThemeManager>(context).theme;
    if (action != null) {
      onTap = action.onTap;
      iconData = action.iconData;
      iconSize = action.iconSize;
    }
    return InkWell(
      child: Icon(
        iconData,
        color: theme.rollerCardHeadingColor,
        size: iconSize,
      ),
      onLongPress: () {},
      onTap: onTap,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }

  List<Widget> getActions() {
    var actions = <Widget>[];
    if (widget.expandable) {
      actions.add(getAction(
        onTap: () => setState(() => switchExpansion()),
        iconData: isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
      ));
    }
    if (widget.actions == null) return actions;
    for (var action in widget.actions) {
      actions.add(getAction(action: action));
    }
    return actions;
  }

  void switchExpansion() => setState(() => isExpanded = !isExpanded);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title),
                Row(
                  children: getActions(),
                ),
              ],
            ),
            Container(
              child: AnimatedCrossFade(
                firstChild: widget.child,
                secondChild: buildSecondChild(),
                crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: Duration(milliseconds: widget.transitionTime),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
