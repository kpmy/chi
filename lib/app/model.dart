part of loop;

@Entity()
class Model{
  String name;
  int age;

  Model();

  Model.born(this.name){
    this.age = 0;
  }
}