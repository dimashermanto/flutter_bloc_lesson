import 'dart:async';


enum counterAction{
  Increment,
  Decrement,
  Reset
}


class CounterBloc{

  int counter;

  final _stateStreamController = StreamController<int>.broadcast();
  StreamSink<int> get _counterSink => _stateStreamController.sink;
  Stream<int> get counterStream => _stateStreamController.stream;


  final _eventStreamController = StreamController<counterAction>();
  StreamSink<counterAction> get eventSink => _eventStreamController.sink;
  Stream<counterAction> get _eventStream => _eventStreamController.stream;


  CounterBloc(){

    counter = 0;

    _eventStream.listen((event) {
      if(event == counterAction.Increment) counter++;
      else if(event == counterAction.Decrement) counter--;
      else if(event == counterAction.Reset) counter = 0;

      _counterSink.add(counter);

    });
  }

  void disposeBloc(){
    // Close all stream controller on dispose
    _stateStreamController.close();
    _eventStreamController.close();
  }

}