import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/theme_manager.dart';


const htmlData = """
  <body>
  <h1>Welcome to RPG Dice</h1>
  An app for creating, rolling, and examining highly customisable, user-configured hands of dice.
  <br><br>
  
  <h2>Why would I use RPG Dice?</h2>
  RPG Dice allows you to quickly and effortlessly roll any combination of dice you can imagine.
  Don't have 20d6 for that <i>Meteor Swarm</i> spell?
  Get a damage roll within seconds with RPG Dice!
  Need to roll a new character?
  Roll six ability scores as fast as you can tap your screen!
  <br>
  RPG Dice breaks down more complex dice configurations' outputs, tracks your roll history,
  and gives you the odds of rolling each output.
  <br><br>
  
  <h2>How do I use the app?</h2>
  Start by creating a new Hand.
  Give it a <b>name</b> and an <b>expression</b>, like "Fireball" and "8d6".
  Once created, you can access it to roll 8d6, and see what the odds of rolling max damage is (it's pretty low).
  <br><br>
  
  <h2>How do dice expressions work?</h2>
  A <b>dice expression</b> represent dice and operations that can be performed thereon.
  The notation is compact, using singular characters where possible.
  <br>
  The various characters and subexpressions that dice expressions may consist of are listed below:
  </body>
""";

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var theme = Provider.of<ThemeManager>(context).theme;

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
          child: Html(
            data: htmlData,
            style: {
              'p': Style(fontSize: FontSize.large, color: theme.genericPrimaryTextColor),
              'body': Style(fontSize: FontSize.large, color: theme.genericPrimaryTextColor),
              'h1': Style(color: theme.genericPrimaryTextColor),
              'h2': Style(color: theme.genericPrimaryTextColor),
              'table': Style(
                backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
              ),
              'tr': Style(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              'th': Style(
                padding: EdgeInsets.all(6),
                backgroundColor: Colors.grey,
              ),
              'td': Style(
                padding: EdgeInsets.all(6),
              ),
            },
          ),
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisSize: MainAxisSize.min,
          //   children: intersperse(
          //     _text.map(segment2Widget).toList(),
          //     () => SizedBox(height: 10),
          //   ),
          // ),
        ),
      ),
    );
  }
}
