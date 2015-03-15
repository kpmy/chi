library elem;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:chi/tools.dart';
import 'package:chi/app/loop.dart';

Model feed(Model m) {
  m.feed(0.01);
  return m;
}

@CustomTag("chi-controls")
class ChiControls extends PolymerElement implements ChiEventListener {

  int _hm;

  @override
  void listen(event) {
    if (event is AppStart) {
      bus.fire(new ModelComponentRegister());
    } else if (event is ModelComponentInit) {
      if (_hm == null) _hm = event.model.hashCode;
    } else if (_hm != null) {
      if (event is ModelUpdated) {

      }
    }
  }

  void doFeed(Event e, var detail, Node target) {
    bus.fire(new ModelUpdateRequest(feed));
  }

  ChiControls.created() : super.created() {
    listenTo(this);
  }
}
