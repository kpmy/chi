part of loop;

class ModelUpdated{
  Model _m;
  Model get model => _m;
  ModelUpdated(this._m);
}

@Entity()
class Model{
  String uuid;
  String name;
  DateTime lastUpdate;
  DateTime birthday;
  num fullness;

  int get hashCode{
    return uuid.hashCode;
  }

  Duration get age => new DateTime.now().difference(birthday);

  void feed(double x){
    fullness = max(0.0, min(fullness+x, 1.0));
  }

  void hunger(double x){
    feed(-x);
  }


  //for serialization purpose
  Model();

  Model.born(this.name){
    this.uuid = new Uuid().v5("in:ocsf:dart", "chi");
    this.birthday = new DateTime.now();
    this.lastUpdate = new DateTime.now();
    this.fullness = 1.0;
  }
}