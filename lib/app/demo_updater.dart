part of loop;

const daySec = 24*60*60;

const launchCount = 2; //два раза в сутки надо кормить, то есть, полностью оголодает за 12 часов
const deltaHunger = 1 / (daySec ~/ launchCount);

void update(Model m){
  Duration delta = new DateTime.now().difference(m.lastUpdate);
  double hunger = delta.inSeconds * deltaHunger;
  m.hunger(hunger);

  m.lastUpdate = new DateTime.now();
}

typedef Model UpdateFunction(Model m);

class ModelUpdateRequest{
  UpdateFunction upd;
  ModelUpdateRequest(this.upd);
}