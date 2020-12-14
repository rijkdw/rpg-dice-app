import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // widgets
    Widget drawerHeader = DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
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
      text: "Dark mode",
      iconData: Icons.lightbulb,
      onTap: () {},
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
    return ListTile(
      onTap: this._onTap,
      leading: Icon(this._iconData),
      title: Text(this._text),
    );
  }
}
