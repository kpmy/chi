part of loop;

@Entity()
class Model{
  String name;
  DateTime lastUpdate;
  DateTime birthday;

  Duration get age => new DateTime.now().difference(birthday);

  //for serialization purpose
  Model();

  Model.born(this.name){
    this.birthday = new DateTime.now();
    this.lastUpdate = new DateTime.now();
  }
}