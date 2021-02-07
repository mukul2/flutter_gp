import 'package:maulaji/view/patient/counter_bloc.dart';
import 'package:maulaji/view/patient/decrement.dart';
import 'package:maulaji/view/patient/increment.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CounterPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final CounterBlock counterBlock = Provider.of<CounterBlock>(context);
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(counterBlock.counter.toString()),
              IncrementButton(),
              DecrementButton()

            ],
          ),
        ),
      ),
    );
  }

}