class Timer { //<>//
  int timeInSec = 0;
  int interval = 0;
  double lastTime = millis();
  Rohstoffeld ress;
  Building build;
  Dorf village;
  Spieler player;
  int aPlayer = 0;
  int aVill = 0;
  int buildingID = 0;
  int type = 0; //normal, ress, building, troops
  boolean repeat = false;
  boolean lvlUp = false;
  int ressType = -1;
  int startLvl = 0;
  
  Timer(int time) {
    timeInSec= time;

  }
  Timer(int p, int v) {
    aPlayer = p;
    aVill = v;
  }

  Timer( boolean repeat) {
    this.repeat = repeat;

  }

  void addTimer(int duration) {
    timeInSec = duration;
    interval = duration;
    type = 0;
  }
  void addRessTimer(int duration, Rohstoffeld _ress) {
    timeInSec = duration;
    interval = duration;
    ress = _ress;
    type = 1;
    ressType = ress.Typ;
    startLvl = ress.level;
  }
  void addBuildingTimer(int duration, Building _build, Dorf vill, boolean lvlUp) {
    timeInSec = duration;
    interval = duration;
    build = _build;
    village = vill;
    this.lvlUp = lvlUp;
    type = 2;
    buildingID = build.id;
    startLvl = build.level;
  }
  void addCultureTimer(int duration, Spieler player, Dorf village) {
    timeInSec = duration;
    interval = duration;
    type = 3;
    this.player = player;
    this.village = village;
  }

  boolean update() {
    if (timeInSec<=0) { //<>//
      if (repeat == true) {
        timeInSec = interval;
        return intervalRestarted();
      } else
        return false;
    }
    if (millis()-lastTime>1000) {
      timeInSec--;
      lastTime = millis();
      if (timeInSec<=0) {
        if (type == 1) {
          ress.levelUp();
          ress.toLvl = false;
        } else if (type == 2) {
          if (lvlUp == false) {
            village.c_BuildingManager.A_buildings.add(build);
            int[] c = getInitCost(build.id);
            //village.c_RessourceManager.storage.substractCost(c);
            village.c_RessourceManager.a_CulturePointsPerDay += c[Kultur];
            village.c_BuildingManager.updateBuildingLvlUp();
            village.population += c[Bewohner];
          } else {
            build.levelUp();
          }
          if (build.S_name == "Rohstofflager")
            village.c_RessourceManager.storage.maxCapacity += int(build.findUpgrade());
          else if (build.S_name == "Kornspeicher")
            village.c_RessourceManager.storage.maxKorn += int(build.findUpgrade());
          build.toLvl = false;
        }
      }
    }
    return false;
  }

  boolean intervalRestarted() {
    
    return true;
  }

  void drawTimer(int x, int y, int w, int h) {
    String text = "";
    if (type == 0)
      text = "generic Timer";
    else if (type == 1)
      text = ress.Name() + " " + ress.level + 1 + " " + timeInSec;
    else if (type ==2)
      text = build.S_name + " " + build.level + 1 + " " + timeInSec;

    pg_overlay.text(text, x, y);
    drawLadebalken(x, y, w, h, timeInSec, interval, false);
  }
}
