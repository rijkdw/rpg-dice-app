import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    InputDecoration inputDecoration = InputDecoration(
      hintText: "HINT TEXT",
    );

    void accept() {}

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // the dice collection's name
          TextFormField(
            validator: (value) {
              if (value.isEmpty) return "Name cannot be empty";
              return null;
            },
            decoration: inputDecoration.copyWith(hintText: "Hand name"),
          ),
          // the dice collection's expression
          TextFormField(
            validator: (value) {
              if (value.isEmpty) return "Expression cannot be empty";
              // TODO check if it can successfully parse as a dice expression
              return null;
            },
            decoration: inputDecoration.copyWith(hintText: "Dice expression"),
          ),
          Expanded(child: Container()),
          RaisedButton(
            child: Text("Add"),
            onPressed: _formKey.currentState.validate() ? null : accept,
          ),
        ],
      ),
    );
  }
}
