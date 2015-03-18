part of loop;

class ModelUpdated {
  Model _m;
  Model get model => _m;
  ModelUpdated(this._m);
}

@Entity()
class Model implements StaticEntity {
  String uuid;
  String name;
  DateTime lastUpdate;
  DateTime birthday;
  num full;
  num fit;

  int get hashCode {
    return uuid.hashCode;
  }

  set fullness (double x){
    full = max(0.0, min(x, 1.0));
  }

  set fitness(double x){
    fit = max(-0.5, min(x, 0.5));
  }

  Duration get age => new DateTime.now().difference(birthday);

  void feed(double x) {
    fullness = full+x;
    fitness = fit+0.01;
  }

  void hunger(double x) {
    fullness = full-x;
    fitness = fit-0.01;
  }



  //for serialization purpose
  Model();

  Model.born(this.name) {
    this.uuid = new Uuid().v5("in:ocsf:dart", "chi");
    this.birthday = new DateTime.now();
    this.lastUpdate = new DateTime.now();
    this.full = 1.0;
    this.fit = 0.0;
  }
Map dartsonEntityEncode(TypeTransformerProvider dson) {
var obj = {};
obj["uuid"] = this.uuid;
obj["name"] = this.name;
if (this.lastUpdate != null) {
  if (dson.hasTransformer(DateTime)) {    obj["lastUpdate"] = dson.getTransformer(DateTime).encode(this.lastUpdate);
  } else {
    obj["lastUpdate"] = (this.lastUpdate as StaticEntity).dartsonEntityEncode(dson);
  }
}
if (this.birthday != null) {
  if (dson.hasTransformer(DateTime)) {    obj["birthday"] = dson.getTransformer(DateTime).encode(this.birthday);
  } else {
    obj["birthday"] = (this.birthday as StaticEntity).dartsonEntityEncode(dson);
  }
}
obj["full"] = this.full;
obj["fit"] = this.fit;
return obj;
}
void dartsonEntityDecode(Map obj, TypeTransformerProvider dson) {
this.uuid = obj["uuid"];
this.name = obj["name"];
if (obj["lastUpdate"] != null) {
  if (dson.hasTransformer(DateTime)) {    this.lastUpdate = dson.getTransformer(DateTime).decode(obj["lastUpdate"]);
  } else {
    this.lastUpdate = new DateTime();
    (this.lastUpdate as StaticEntity).dartsonEntityDecode(obj["lastUpdate"], dson);
  }
}
if (obj["birthday"] != null) {
  if (dson.hasTransformer(DateTime)) {    this.birthday = dson.getTransformer(DateTime).decode(obj["birthday"]);
  } else {
    this.birthday = new DateTime();
    (this.birthday as StaticEntity).dartsonEntityDecode(obj["birthday"], dson);
  }
}
this.full = obj["full"];
this.fit = obj["fit"];
}
Model newEntity() => new Model();
}
