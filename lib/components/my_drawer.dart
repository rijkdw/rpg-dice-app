import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/my_app_theme.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyAppTheme theme = Provider.of<ThemeManager>(context).theme;

    // widgets
    Widget drawerHeader = DrawerHeader(
      decoration: BoxDecoration(
        color: theme.drawerHeaderColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 5),
          FaIcon(
            FontAwesomeIcons.diceD20,
            color: theme.drawerHeaderIconColor,
            size: 50,
          ),
          SizedBox(width: 25),
          Text(
            "RPG Dice",
            style: TextStyle(
              letterSpacing: 1.5,
              color: theme.drawerHeaderTextColor,
              fontSize: 30,
            ),
          ),
        ],
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
          color: theme.drawerBodyColor,
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
