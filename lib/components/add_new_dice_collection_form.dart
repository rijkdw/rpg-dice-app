import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/dice_engine/ast/objects/lexer.dart';
import 'package:rpg_dice/dice_engine/ast/objects/parser.dart';
import 'package:rpg_dice/managers/collection_manager.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/objects/dice_collection.dart';
import 'package:rpg_dice/objects/my_app_theme.dart';

class AddNewDiceCollectionForm extends StatefulWidget {

  DiceCollection diceCollection;

  AddNewDiceCollectionForm({this.diceCollection});

  @override
  _AddNewDiceCollectionFormState createState() => _AddNewDiceCollectionFormState();
}

class _AddNewDiceCollectionFormState extends State<AddNewDiceCollectionForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController expressionController = TextEditingController();

  @override
  void initState() {
    if (widget.diceCollection != null) {
      nameController.text = widget.diceCollection.name;
      expressionController.text = widget.diceCollection.expression;
    }
    super.initState();
  }

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
                  if (value.isEmpty) return 'Expression cannot be empty';
                  try {
                    Parser(Lexer(value)).parse();
                  } catch (e) {
                    return 'Bad expression';
                  }
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
                // are we creating or editing?
                if (widget.diceCollection != null) {
                  // we are editing
                  DiceCollection diceCollection = DiceCollection(
                    name: nameController.text,
                    expression: expressionController.text,
                    id: widget.diceCollection.id,
                  );
                  collectionManager.editCollection(widget.diceCollection.id, diceCollection);
                  Provider.of<HistoryManager>(context, listen: false).clearHistory(widget.diceCollection.id);
                } else {
                  // we are creating
                  DiceCollection diceCollection = DiceCollection(
                    name: nameController.text,
                    expression: expressionController.text,
                  );
                  collectionManager.addToCollections(diceCollection);
                }
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
