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

    Widget settingsMenuItem = _MenuListTile(
      text: "Settings",
      iconData: Icons.settings,
      onTap: () {},
    );

    Widget donateMenuItem = _MenuListTile(
      text: "Donate",
      iconData: Icons.monetization_on,
      onTap: () {},
    );

    Widget darkModeMenuItem = _MenuListTile(
      text: "${Provider.of<ThemeManager>(context).currentThemeAsString} mode",
      iconData: Icons.lightbulb,
      onTap: () => Provider.of<ThemeManager>(context, listen: false).swapSelection(),
    );

    return Drawer(
      elevation: 0,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Provider.of<ThemeManager>(context).theme.drawerBodyColor,
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
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

class _MenuListTile extends StatelessWidget {
  String _text;
  IconData _iconData;
  VoidCallback _onTap;

  _MenuListTile({String text, IconData iconData, VoidCallback onTap}) {
    this._text = text;
    this._iconData = iconData;
    this._onTap = onTap;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Provider.of<ThemeManager>(context).theme.drawerBodyTextColor,
    );

    return ListTile(
      onTap: this._onTap,
      leading: Icon(
        this._iconData,
        color: Provider.of<ThemeManager>(context).theme.drawerBodyIconColor,
      ),
      title: Text(
        this._text,
        style: textStyle,
      ),
    );
  }
}
