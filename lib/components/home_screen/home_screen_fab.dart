import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpg_dice/popups/create_new_dice_collection_popup.dart';

class HomeScreenFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(context: context, builder: (_) => CreateNewDiceCollectionPopup());
      },
      child: Icon(Icons.add, size: 35),
    );

    return FloatingActionButton.extended(
      onPressed: () {},
      label: Text("New"),
      icon: FaIcon(FontAwesomeIcons.diceD20),
    );
  }
}
