import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/settings_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';

class SettingsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var settingsManager = Provider.of<SettingsManager>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Heading(text: 'General'),
        _SwitchTile(
          text: 'Vibration',
          value: settingsManager.isVibrationOn,
          onChanged: (newVal) {
            settingsManager.invertVibration();
          },
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class _Heading extends StatelessWidget {
  String text;
  _Heading({this.text});
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;
    return Text(
      text,
      style: Theme.of(context).textTheme.headline5.copyWith(
            color: theme.genericPrimaryTextColor,
          ),
    );
  }
}

// ignore: must_be_immutable
class _SwitchTile extends StatelessWidget {
  String text;
  bool value;
  void Function(bool) onChanged;

  _SwitchTile({this.text, this.value, this.onChanged});

  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(color: theme.genericPrimaryTextColor),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
