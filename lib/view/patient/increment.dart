
import 'package:maulaji/view/patient/counter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncrementButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final CounterBlock counterBlock = Provider.of<CounterBlock>(context);

    return FlatButton.icon(
        icon : Icon(Icons.add),
        onPressed: ()=>counterBlock.increment(),
        label: Text("Add"),);
  }

}