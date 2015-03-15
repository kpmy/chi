part of loop;

class ModelUpdated {
  Model _m;
  Model get model => _m;
  ModelUpdated(this._m);
}

@Entity()
class Model {
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
}
