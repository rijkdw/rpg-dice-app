import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/utils.dart';

var _text = [
  {
    'style': 'heading',
    'contents': 'How does this work?',
  },
  {
    'style': 'body',
    'contents': 'It doesn\'t!',
  },
];

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).theme;

    Widget segment2Widget(Map<String, dynamic> map) {
      var tag2StyleMap = {
        'heading': TextStyle(
          color: theme.genericPrimaryTextColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        'body': TextStyle(
          color: theme.genericPrimaryTextColor,
        ),
      };
      return Text(
        map['contents'],
        style: tag2StyleMap[map['style']],
      );
    }

    return Scaffold(
      backgroundColor: theme.genericCanvasColor,
      appBar: AppBar(
        backgroundColor: theme.appbarColor,
        title: Text('Help', style: TextStyle(color: theme.appbarTextColor)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: intersperse(
              _text.map(segment2Widget).toList(),
              () => SizedBox(height: 10),
            ),
          ),
        ),
      ),
    );
  }
}
