class Timer { //<>// //<>// //<>// //<>// //<>// //<>// //<>//
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
  boolean isActive = false;
  int ressType = -1;
  int startLvl = 0;

  Timer(int time) {
    timeInSec= time;
    isActive = true;
  }
  Timer(int p, int v) {
    aPlayer = p;
    aVill = v;
    isActive = true;
  }

  Timer( boolean repeat) {
    this.repeat = repeat;
    isActive = true;
  }

  void addTimer(int duration) {
    timeInSec = duration;
    interval = duration;
    type = 0;
    isActive = true;
  }
  void addRessTimer(int duration, Rohstoffeld _ress, boolean fromSave) {
    timeInSec = duration;
    interval = duration;
    ress = _ress;
    type = 1;
    ressType = ress.Typ;
    startLvl = ress.level;
    isActive = true; //<>//
    if(fromSave == false)
      saveJSON();
  }
  void addBuildingTimer(int duration, Building _build, Dorf vill, boolean lvlUp, boolean fromSave) {
    timeInSec = duration;
    interval = duration;
    build = _build;
    village = vill;
    this.lvlUp = lvlUp;
    type = 2;
    buildingID = build.id;
    isActive = true;
    if(fromSave == false)
      saveJSON();
  }
  void addCultureTimer(int duration, Spieler player, Dorf village, boolean fromSave) {
    timeInSec = duration;
    interval = duration;
    type = 3;
    this.player = player;
    isActive = true;
    this.village = village;
    if(fromSave == false)
      saveJSON();
  }

  boolean update() {
    if (isActive == false)
      return false;
    if (timeInSec<=0) {
      if (repeat == true) {
        //timeInSec = interval;
        return intervalRestarted();
      }
    }
    if (millis() - lastTime >= 1000) {
      timeInSec--;
      lastTime = millis();
    }
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
      isActive = false;
     saveJSON();
    }
    return false;
  }

  boolean intervalRestarted() {

    return true;
  }

  void drawTimer(int x, int y, int w, int h) {
    int hours = floor(timeInSec /  3600);
    int minutes = floor((timeInSec - hours * 3600) / 60);
    int seconds = timeInSec - minutes * 60 - hours * 3600;
    String text = "";
    
    if (type == 0)
      text = "generic Timer";
    else if (type == 1)
      text = ress.Name() + " " + (ress.level + 1) + " " + hours + ":"+minutes+":"+seconds;
    else if (type ==2 && lvlUp == true)
      text = build.S_name + " " + (build.level + 1) + " " + hours + ":"+minutes+":"+seconds;
    else if(type == 2)
      text = build.S_name + " " + (build.level) + " " + hours + ":"+minutes+":"+seconds;

    pg_overlay.fill(255);
    
    pg_overlay.rect(x, y -15  , w,15 + h);
    pg_overlay.fill(0);
    pg_overlay.text(text, x, y);
    drawLadebalken(x, y, w, h, timeInSec, interval, false);
  }
}
