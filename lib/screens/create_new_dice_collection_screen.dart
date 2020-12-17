import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/add_new_dice_collection_form.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/my_app_theme.dart';

class CreateNewDiceCollectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyAppTheme theme = Provider.of<ThemeManager>(context).theme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appbarColor,
        elevation: 0,
        title: Text(
          "Create New Hand",
          style: TextStyle(color: theme.appbarTextColor),
        ),
      ),
      backgroundColor: theme.listViewBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: AddNewDiceCollectionForm(),
      ),
    );
  }
}