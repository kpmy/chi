part of loop;

@Entity()
class Model{
  String name;

  DateTime lastUpdate;
  DateTime birthday;
  num fullness;

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
    this.birthday = new DateTime.now();
    this.lastUpdate = new DateTime.now();
    this.fullness = 1.0;
  }
}