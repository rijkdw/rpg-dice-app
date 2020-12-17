import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNewDiceCollectionForm extends StatefulWidget {
  @override
  _AddNewDiceCollectionFormState createState() => _AddNewDiceCollectionFormState();
}

class _AddNewDiceCollectionFormState extends State<AddNewDiceCollectionForm> {

  GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // the dice collection's name
            TextFormField(
              validator: (value) {
                if (value.isEmpty) return "Name cannot be empty";
                return null;
              },
            ),
            // the dice collection's expression
            TextFormField(
              validator: (value) {
                if (value.isEmpty) return "Expression cannot be empty";
                // TODO check if it can successfully parse as a dice expression
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}