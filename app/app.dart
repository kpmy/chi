export 'package:polymer/init.dart';

import 'dart:html';
import 'package:chi/storage.dart';
import 'package:chi/app/loop.dart';
import 'dart:async';

main(){
  if(window.sessionStorage.containsKey(SESSION))
    Future.doWhile((){return new Future.delayed(new Duration(seconds: 1), run);});
  else
    window.location.replace("/");
}