class Timer {
  int timeInSec = 0;
  int interval = 0;
  int lastTime = millis();
  Rohstoffeld ress;
  Building build;
  Dorf village;
  Spieler player;
  int type = 0; //normal, ress, building, troops
  boolean repeat = false;
  Timer(int time) {
    timeInSec= time;
  }
  Timer() {
    // timeInSec.append(3);
  }

  Timer(boolean repeat) {
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
  }
  void addBuildingTimer(int duration, Building _build) {
    timeInSec = duration;
    interval = duration;
    build = _build;
    type = 2;
  }
  void addCultureTimer(int duration, Spieler player, Dorf village) {
    timeInSec = duration;
    interval = duration;
    type = 3;
    this.player = player;
    this.village = village;
  }

  boolean update() {
    if (timeInSec<=0) {
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
          build.levelUp();
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
      
    pg_overlay.text(text,x, y);
    drawLadebalken(x,y,w,h,timeInSec,interval,false);
  }
}
