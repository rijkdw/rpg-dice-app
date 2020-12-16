import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/components/menu_list_tile.dart';
import 'package:rpg_dice/managers/theme_manager.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // widgets
    Widget drawerHeader = DrawerHeader(
      decoration: BoxDecoration(
        color: Provider.of<ThemeManager>(context).theme.drawerHeaderColor,
      ),
    );

    Widget settingsMenuItem = MenuListTile(
      text: "Settings",
      iconData: Icons.settings,
      onTap: () {},
    );

    Widget donateMenuItem = MenuListTile(
      text: "Donate",
      iconData: Icons.monetization_on,
      onTap: () {},
    );

    Widget darkModeMenuItem = MenuListTile(
      text: "${Provider.of<ThemeManager>(context).currentThemeAsString} mode",
      iconData: Icons.lightbulb,
      onTap: () => Provider.of<ThemeManager>(context, listen: false).swapSelection(),
    );

    return Drawer(
      elevation: 0,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            drawerHeader,
            settingsMenuItem,
            donateMenuItem,
            darkModeMenuItem,
          ],
        ),
      ),
    );
  }
}
