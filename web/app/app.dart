import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:chi/storage.dart';
import 'package:chi/app/loop.dart' as loop;


main(){
  if(window.sessionStorage.containsKey(SESSION)){
    initPolymer().run(() {
        Polymer.onReady.then((_) {
          Future.doWhile((){return new Future.delayed(new Duration(seconds: 1), loop.run);});
        });
    });
 }else window.location.replace("/");
}