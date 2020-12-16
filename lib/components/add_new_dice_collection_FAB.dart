import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpg_dice/screens/create_new_dice_collection_screen.dart';

class AddNewDiceCollectionFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CreateNewDiceCollectionScreen(),
          ),
        );
      },
      child: Icon(Icons.add, size: 35),
      elevation: 0,
      highlightElevation: 0, // no sudden elevation when tapped
    );

    return FloatingActionButton.extended(
      onPressed: () {},
      label: Text("New"),
      icon: FaIcon(FontAwesomeIcons.diceD20),
    );
  }
}
