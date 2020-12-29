import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/collection_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/objects/my_app_theme.dart';

class AddNewDiceCollectionForm extends StatefulWidget {
  @override
  _AddNewDiceCollectionFormState createState() => _AddNewDiceCollectionFormState();
}

class _AddNewDiceCollectionFormState extends State<AddNewDiceCollectionForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController expressionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MyAppTheme theme = Provider.of<ThemeManager>(context).theme;
    CollectionManager collectionManager = Provider.of<CollectionManager>(context, listen: false);

    var inputDecoration = InputDecoration(
      hintText: "HINT TEXT",
      hintStyle: TextStyle(
        color: theme.newFormHintTextColor,
      ),
    );

    var headingTextStyle = TextStyle(
      fontSize: 30,
      color: theme.newFormFieldHeadingColor,
    );

    var formTextStyle = TextStyle(
      color: theme.newFormFieldTextColor,
    );

    var buttonTextStyle = TextStyle(
      color: theme.newFormFieldButtonTextColor,
      fontSize: 16,
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // heading
              Text("New hand", style: headingTextStyle),
              SizedBox(height: 10),
              // the dice collection's name
              TextFormField(
                decoration: inputDecoration.copyWith(hintText: "Hand name"),
                controller: nameController,
                textCapitalization: TextCapitalization.sentences,
                style: formTextStyle,
                validator: (value) {
                  if (value.isEmpty) return "Name cannot be empty";
                  return null;
                },
              ),
              // the dice collection's expression
              TextFormField(
                decoration: inputDecoration.copyWith(hintText: "Dice expression"),
                controller: expressionController,
                style: formTextStyle,
                validator: (value) {
                  if (value.isEmpty) return "Expression cannot be empty";
                  // TODO check if it can successfully parse as a dice expression
                  return null;
                },
              ),
              // TODO an endless selection row for the DiceCollection's icon
              // Expanded(child: Container()),
            ],
          ),
          SizedBox(height: 30),
          RaisedButton(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                "ADD",
                style: buttonTextStyle,
              ),
            ),
            elevation: 0,
            color: theme.newFormFieldButtonColor,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                // if valid contents, accept
                DiceCollection diceCollection = DiceCollection(
                  name: nameController.text,
                  expression: expressionController.text,
                );
                collectionManager.addToCollections(diceCollection);
                Navigator.of(context).pop();
              } else {
                // if invalid contents, reject
              }
            },
          ),
        ],
      ),
    );
  }
}
