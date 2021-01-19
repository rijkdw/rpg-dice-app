import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/screens/balance_screen.dart';

import 'package:rpg_dice/constants.dart' as constants;
import 'package:rpg_dice/screens/help_screen.dart';
import 'package:rpg_dice/screens/settings_screen.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // the app theme
    var theme = Provider.of<ThemeManager>(context).theme;

    // widgets
    var drawerHeader = DrawerHeader(
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
            'RPG Dice',
            style: TextStyle(
              letterSpacing: 1.5,
              color: theme.drawerHeaderTextColor,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );

    var settingsMenuItem = _MenuListTile(
      text: 'Settings',
      iconData: Icons.settings,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SettingsScreen(),
        ));
      }, // TODO
    );

    var helpMenuItem = _MenuListTile(
      text: 'Help',
      iconData: Icons.help,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HelpScreen(),
        ));
      },
    );

    var balanceMenuItem = _MenuListTile(
      text: 'Balance',
      iconData: Icons.zoom_in,
      onTap: () {
        // Navigator.of(context).pop(); // close the drawer
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BalanceScreen(),
        ));
      },
    );

    var donateMenuItem = _MenuListTile(
      text: 'Donate',
      iconData: Icons.monetization_on,
      onTap: () {}, // TODO
    );

    var bugReportMenuItem = _MenuListTile(
      text: 'Report bug',
      iconData: Icons.bug_report,
      onTap: () {}, // TODO
    );

    var darkModeMenuItem = _MenuListTile(
      text: "${Provider.of<ThemeManager>(context).currentThemeAsString} mode",
      iconData: Icons.lightbulb,
      onTap: () => Provider.of<ThemeManager>(context, listen: false).swapSelection(),
    );

    return Theme(
      data: ThemeData(
        canvasColor: theme.drawerBodyColor,
      ),
      child: Drawer(
        elevation: constants.DRAWER_ELEVATION,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            drawerHeader,
            settingsMenuItem,
            darkModeMenuItem,
            _Divider(),
            helpMenuItem,
            balanceMenuItem,
            _Divider(),
            donateMenuItem,
            bugReportMenuItem,
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;
    return Divider(
      color: theme.drawerDividerColor,
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
