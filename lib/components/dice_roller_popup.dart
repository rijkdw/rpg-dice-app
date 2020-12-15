import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';

class DiceRollerPopup extends StatelessWidget {
  DiceCollection _diceCollection;

  DiceRollerPopup({DiceCollection diceCollection}) {
    this._diceCollection = diceCollection;
  }

  void roll() {}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // the header that can be tapped to reroll
            InkWell(
              onTap: roll,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // the DiceCollection's name and dice
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(this._diceCollection.name ?? "DICE"),
                      Text(this._diceCollection.dice),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            // the history
            Text("History"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Consumer<HistoryManager>(
                builder: (context, historyManager, child) {
                  List<Widget> previousResults = [12, 14, 10].map((result) => Text("$result")).toList();
                  return Row(
                    children: previousResults,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
