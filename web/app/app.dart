import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:chi/storage.dart';
import 'package:chi/app/loop.dart' as loop;
import 'package:chi/tools.dart';

main() {
  initTools();
  if (window.sessionStorage.containsKey(SESSION)) {
    initPolymer().then((z) {
      Polymer.onReady.then((_) {
        bus.on().listen(loop.handle);
        bus.fire(new loop.AppStart());
        var m = loop.load();
        (Q("#chi_name") as SpanElement).appendText(m.name);
        Future.doWhile(() {
          return new Future.delayed(new Duration(seconds: 1), loop.run);
        });
      });
    });
  } else window.location.replace("/");
}
