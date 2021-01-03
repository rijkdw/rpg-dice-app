import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rpg_dice/popups/create_new_dice_collection_popup.dart';

class AddNewDiceCollectionFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => CreateNewDiceCollectionPopup()
        );
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (_) => CreateNewDiceCollectionScreen(),
        //   ),
        // );
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
