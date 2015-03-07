library loop;

import 'dart:html';
import 'package:chi/storage.dart';
import 'package:dartson/dartson.dart';

part 'model.dart';

final codec = new Dartson.JSON();

Model load(){
    var name = window.sessionStorage[SESSION];
    assert(name != null);
    var obj = window.localStorage[name];
    if (obj != null)
      return codec.decode(obj, new Model());
    else
      return new Model.born(name);
}

Model process(Model m){
  print(m.age);
  m.age++;
  return m;
}

void save(Model m){
  var name = window.sessionStorage[SESSION];
  assert(name != null);
  window.localStorage[name] = codec.encode(m);
}

run(){
  save(process(load()));
  return true;
}