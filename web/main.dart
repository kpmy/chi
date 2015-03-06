// Copyright (c) 2015, <kpmy>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'package:polymer/polymer.dart';
import "dart:html";
import "package:chi/storage.dart";
import "package:chi/tools.dart";

void init(){
  final go = Q("#chi_go");
  final name = Q("#chi_name_new");

  if(window.sessionStorage.containsKey(SESSION))
    name.value = window.sessionStorage[SESSION];

  name
  ..onChange.listen((Event e){
      go.disabled = (name.value == "");
  });

  go
    ..onClick.listen((MouseEvent e){
    window.sessionStorage[SESSION]=name.value;
    window.location.assign("/app");
  });
}

void main() {
  initPolymer().run(() {
    Polymer.onReady.then((_) {
      init();
    });
  });
}
