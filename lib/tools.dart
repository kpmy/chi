library tools;

import 'dart:html';
import 'package:event_bus/event_bus.dart';
import 'package:dartson/transformers/date_time.dart';
import 'package:dartson/dartson.dart';

final codec = new Dartson.JSON();
final EventBus bus = new EventBus();

abstract class ChiEventListener{
  void listen(event);
}

Function listenerOf(ChiEventListener e){
  return (event){
    e.listen(event);
  };
}

void listenTo(ChiEventListener e){
  bus.on().listen(listenerOf(e));
}

//алиас для селектора, чтобы как в джыкуере
final Q = querySelector;

class Tuple2<T1, T2> {
  T1 i1;
  T2 i2;

  Tuple2(this.i1, this.i2);

  String toString() => '[$i1, $i2]';

  int get hashCode {
      int result = 17;
      result = 37 * result + i1.hashCode;
      result = 37 * result + i2.hashCode;
      return result;
    }

    // You should generally implement operator == if you
    // override hashCode.
    bool operator ==(other) {
      if (other is! Tuple2) return false;
      Tuple2 t = other;
      return (t.i1 == i1 &&
          t.i2 == i2);
    }
}

void initTools(){
  print("init tools");
  codec.addTransformer(new DateTimeParser(), DateTime);
}