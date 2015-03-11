library loop;

import 'dart:html';
import 'dart:math';
import 'package:chi/storage.dart';
import 'package:dartson/dartson.dart';
import 'package:dartson/transformers/date_time.dart';

part 'model.dart';
part 'demo_updater.dart';

final codec = new Dartson.JSON();

Model load(){
    var name = window.sessionStorage[SESSION];
    assert(name != null);
    var obj = window.sessionStorage[name];
    print(obj);
    if (obj != null)
      return codec.decode(obj, new Model());
    else
      return new Model.born(name);
}

Model process(Model m){
  update(m);
  return m;
}

void save(Model m){
  var name = window.sessionStorage[SESSION];
  assert(name != null);
  window.sessionStorage[name] = codec.encode(m);
}

run(){
  codec.addTransformer(new DateTimeParser(), DateTime);
  save(process(load()));
  return true;
}