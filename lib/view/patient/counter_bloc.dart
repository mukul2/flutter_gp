import 'package:flutter/cupertino.dart';

class CounterBlock extends ChangeNotifier{
  int _counter = 10 ;
  int get counter => _counter;

  set counter(int val){
    _counter = val ;
    notifyListeners();
  }

  increment(){
    counter  =  counter + 1 ;
  }
  decrement(){
    counter  =  counter - 1 ;
  }
}