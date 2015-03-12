library loop;

import 'dart:html';
import 'dart:math';
import 'package:chi/storage.dart';
import 'package:chi/tools.dart';
import 'package:dartson/dartson.dart';
import 'package:uuid/uuid.dart';

part 'model.dart';
part 'demo_updater.dart';

class ModelComponentInit{
  Model _m;
  Model get model => _m;
  ModelComponentInit(this._m);
}

class ModelComponentRegister{}

class AppStart{}

Model load(){
    var name = window.sessionStorage[SESSION];
    assert(name != null);
    var obj = window.sessionStorage[name];
    print(obj);
    if (obj != null)
      return codec.decode(obj, new Model());
    else{
      Model m = new Model.born(name);
      save(m);
      return m;
    }
}

Model process(Model m){
  update(m);
  return m;
}

Model notify(Model m){
  bus.fire(new ModelUpdated(m));
  return m;
}

void save(Model m){
  var name = window.sessionStorage[SESSION];
  assert(name != null);
  window.sessionStorage[name] = codec.encode(m);
}

run(){
  save(notify(process(load())));
  return true;
}

void handle(event){
  if(event is ModelComponentRegister){
    bus.fire(new ModelComponentInit(load()));
  }else if(event is ModelUpdateRequest){
    assert(event.upd != null);
    save(notify(event.upd(load())));
  }
}