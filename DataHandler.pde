void saveJSON() { //<>// //<>// //<>//
  /* For each player */
  for (int p = 0; p < 2; p++) {
    JSONArray pArray = new JSONArray();
    pArray.setJSONObject(0, setPlayerValues(p));
    pArray.setJSONArray(1, setTimeArray(0));
    /* for each village */
    for (int d = 0; d < a_player[p].doerfer.size(); d++) {
      JSONObject villObject = new JSONObject();

      villObject.setInt("village ID", d);
      villObject.setJSONArray("Ress", getRessArray(p, d));
      villObject.setJSONArray("RessQuantity", getRessQuantityArray(p, d));
      for (int r = 0; r < 4; r++)
        villObject.setJSONArray("RessLevel_"+r, getRessLevelArray(byte(r), p, d));
      villObject.setJSONArray("Buildings", getBuildArray(p, d));
      villObject.setInt("Population", a_player[p].doerfer.get(d).population);
      villObject.setInt("CultureVill", a_player[p].doerfer.get(d).c_RessourceManager.culturePointsVill);
      pArray.setJSONObject(d+2, villObject);
      villObject.setJSONArray("Timer", saveVillTimer(p, d));
    }

    saveJSONArray(pArray, "data/Player_"+p+".json");
  }
  println("saved JSON");
}

JSONArray saveVillTimer(int p, int v) {
  JSONArray array = new JSONArray();

  for (int d = 0; d < a_player[p].doerfer.get(v).timer.length; d++) {
    Dorf dorf = a_player[p].doerfer.get(v);
    for (int t = 0; t < dorf.timer.length; t++) {
      String[] names = {"timeInSec", "interval", "lastTime", "type", "repeat", "lvlUp", "Player", "Village", "BuildingID", "RessType", "startLvl","isActive"};
      JSONObject Obj = new JSONObject();
      Obj.setInt(names[0], dorf.timer[t].timeInSec);
      Obj.setInt(names[1], dorf.timer[t].interval);
      //Obj.setDouble(names[2], dorf.timer[t].lastTime);
      Obj.setInt(names[3], dorf.timer[t].type);
      Obj.setBoolean(names[4], dorf.timer[t].repeat);
      Obj.setBoolean(names[5], dorf.timer[t].lvlUp);
      Obj.setInt(names[6], dorf.timer[t].aPlayer);
      Obj.setInt(names[7], dorf.timer[t].aVill);
      Obj.setInt(names[8], dorf.timer[t].buildingID);
      Obj.setInt(names[9], dorf.timer[t].ressType);
      Obj.setInt(names[10], dorf.timer[t].startLvl);
      Obj.setBoolean(names[11], dorf.timer[t].isActive);
      array.setJSONObject(t, Obj);
    }
  }
  return array;
}

void loadVillTimer(int p, int v, JSONArray timer) {
  String[] names = {"timeInSec", "interval", "lastTime", "type", "repeat", "lvlUp", "Player", "Village", "BuildingID", "RessType", "startLvl","isActive"};
  for (int t = 0; t < 3; t++) {
    JSONObject timerObj = timer.getJSONObject(t);
    a_player[p].doerfer.get(v).timer[t].timeInSec = timerObj.getInt(names[0]);
    a_player[p].doerfer.get(v).timer[t].interval = timerObj.getInt(names[1]);
    a_player[p].doerfer.get(v).timer[t].type = timerObj.getInt(names[3]);
    a_player[p].doerfer.get(v).timer[t].repeat = timerObj.getBoolean(names[4]);
    a_player[p].doerfer.get(v).timer[t].lvlUp = timerObj.getBoolean(names[5]);
    a_player[p].doerfer.get(v).timer[t].aPlayer = timerObj.getInt(names[6]);
    a_player[p].doerfer.get(v).timer[t].aVill = timerObj.getInt(names[7]);
    a_player[p].doerfer.get(v).timer[t].buildingID = timerObj.getInt(names[8]);
    a_player[p].doerfer.get(v).timer[t].ressType = timerObj.getInt(names[9]);
    a_player[p].doerfer.get(v).timer[t].startLvl = timerObj.getInt(names[10]);
    a_player[p].doerfer.get(v).timer[t].isActive = timerObj.getBoolean(names[11]);
    setTimerObjects(p, v, t);
  }
}

void setTimerObjects(int p, int v, int t) {
  // ress
  if (a_player[p].doerfer.get(v).timer[t].isActive == false)
    return;
  if (a_player[p].doerfer.get(v).timer[t].type == 1) {
    for (int r = 0; r <  a_player[p].doerfer.get(v).c_RessourceManager.allRess[a_player[p].doerfer.get(v).timer[t].ressType].length; r++) {
      if (a_player[p].doerfer.get(v).c_RessourceManager.allRess //<>//
        [a_player[p].doerfer.get(v).timer[t].ressType] //<>//
        [r].level == a_player[p].doerfer.get(v).timer[t].startLvl) { //<>//
        a_player[p].doerfer.get(v).timer[t].addRessTimer(a_player[p].doerfer.get(v).timer[t].timeInSec, a_player[p].doerfer.get(v).c_RessourceManager.allRess[a_player[p].doerfer.get(v).timer[t].ressType][r], true);
        return;
      }
    }
  } else if (a_player[p].doerfer.get(v).timer[t].type == 2) {  //<>// //<>// //<>//
    if(a_player[p].doerfer.get(v).timer[t].timeInSec < 0.01 * millis() + 2) {
      a_player[p].doerfer.get(v).timer[t].timeInSec = int(0.01 * millis() + 2);
      a_player[p].doerfer.get(v).timer[t].interval = a_player[p].doerfer.get(v).timer[t].timeInSec;
    } //<>// //<>//
    if (a_player[p].doerfer.get(v).timer[t].lvlUp == false) {      //new Building //<>//
      a_player[p].doerfer.get(v).timer[t].addBuildingTimer(
        a_player[p].doerfer.get(v).timer[t].timeInSec, a_player[p].doerfer.get(v).c_BuildingManager.getBuildingClass(
        a_player[p].doerfer.get(v).timer[t].buildingID)
        , a_player[p].doerfer.get(v),
        false, true);
    } else {    //lvlup Building
      for (int b = 0; b < a_player[p].doerfer.get(v).c_BuildingManager.A_buildings.size(); b++) { //<>//
        if ( a_player[p].doerfer.get(v).c_BuildingManager.A_buildings.get(b).level == a_player[p].doerfer.get(v).timer[t].startLvl) { //<>//
          if ( a_player[p].doerfer.get(v).c_BuildingManager.A_buildings.get(b).id == a_player[p].doerfer.get(v).timer[t].buildingID) {
            a_player[p].doerfer.get(v).timer[t].addBuildingTimer(a_player[p].doerfer.get(v).timer[t].timeInSec, a_player[p].doerfer.get(v).c_BuildingManager.A_buildings.get(b), a_player[p].doerfer.get(v), true, true); //<>//
            return;
          }
        }
      }
    }
  }
}

void loadJSON() {
  for (int p = 0; p < 2; p++) {
    a_player[p].doerfer.clear();
    JSONArray pArray = loadJSONArray("data/Player_"+p+".json");
    JSONObject player = pArray.getJSONObject(0);
    setPlayerAttributes(p, player);

    for (int v = 0; v < a_player[p].doerfer.size(); v++) {
      JSONObject vill = pArray.getJSONObject(v+2);
      JSONArray ressQuant = vill.getJSONArray("RessQuantity");
      //println(ressQuant);
      JSONObject quant = ressQuant.getJSONObject(0);
      a_player[p].doerfer.get(v).addRessources(quant.getInt("Holz"), quant.getInt("Lehm"), quant.getInt("Eisen"), quant.getInt("Getreide"));
      JSONArray build = vill.getJSONArray("Buildings");
      addBuildings(p, v, build);
      lvlUpRess(p, v, vill);
      loadVillTimer(p, v, vill.getJSONArray("Timer"));
      fillStorage(p, v, vill);
      a_player[p].doerfer.get(v).c_BuildingManager.updateBuildingLvlUp();
      applyPassedTime(p, v, pArray);
    }
  }
}

void addBuildings(int p, int v, JSONArray build) {
  a_player[p].doerfer.get(v).c_BuildingManager.A_buildings.clear();
  JSONObject buildObj = build.getJSONObject(0);
  int count = buildObj.getInt("buildingCount");
  for (int b = 0; b < count; b++) {
    String[] cut = split(buildObj.getString(str(b)), "_");
    a_player[p].doerfer.get(v).c_BuildingManager.addBuildingFromSave(cut[0], int(cut[1]));
  }
}

void applyPassedTime(int p, int v, JSONArray time) {
  long passedSeconds = getTimeArray(time);
  a_player[p].doerfer.get(v).c_RessourceManager.fillStorageAfterTime(passedSeconds);
  updateTimerFromSave(p, v, passedSeconds);
}

void updateTimerFromSave(int p, int v, long passedSeconds) {
  for (int t = 0; t < 3; t++) {
    a_player[p].doerfer.get(v).timer[t].timeInSec -= passedSeconds ;
  }
  a_player[p].doerfer.get(v).c_RessourceManager.a_timeSinceUpdate[4] = int(passedSeconds);
  //a_player[p].doerfer.get(v).c_RessourceManager.culturePointsVill += round( a_player[p].doerfer.get(v).c_RessourceManager.a_CulturePointsPerDay * ( passedSeconds / float(60 * 60 * 24)));
}

long getTimeArray(JSONArray time) {
  JSONArray timeArr = time.getJSONArray(1);

  JSONObject timeObj = timeArr.getJSONObject(0);
  Calendar startDate = Calendar.getInstance();
  Calendar endDate = Calendar.getInstance();

  startDate.set(year(), month(), day(), hour(), minute(), second()); // January 1, 2023, 00:00:00
  endDate.set(timeObj.getInt("Year"), timeObj.getInt("Month"), timeObj.getInt("Day"), timeObj.getInt("Hour"), timeObj.getInt("Minute"), timeObj.getInt("Second")); // January 1, 2023, 00:00:00

  long secondsSinceSave = startDate.getTimeInMillis() - endDate.getTimeInMillis();
  return secondsSinceSave /= 1000;
}

void fillStorage(int p, int v, JSONObject vill) {
  JSONArray storArr = vill.getJSONArray("Ress");
  JSONObject storObj = storArr.getJSONObject(0);
  String[] ressNames = {"Holz", "Lehm", "Eisen", "Getreide"};
  for (int r = 0; r < 4; r++) {
    a_player[p].doerfer.get(v).c_RessourceManager.storage.Ress[r] = storObj.getInt(ressNames[r]);
  }
}

void lvlUpRess(int p, int v, JSONObject vill) {

  for (int i = 0; i < 4; i ++) {
    JSONArray lvlArr = vill.getJSONArray("RessLevel_"+i);
    JSONObject lvlObj = lvlArr.getJSONObject(0);
    for (int r = 0; r < a_player[p].doerfer.get(v).c_RessourceManager.allRess[i].length; r++) {
      int lvl = lvlObj.getInt("ID_"+r);
      for (int l = 0; l < lvl; l++)
        a_player[p].doerfer.get(v).c_RessourceManager.allRess[i][r].levelUp();
    }
  }
}

void setPlayerAttributes(int p, JSONObject player) {
  int villages = player.getInt("villages");
  for (int v = 0; v < villages; v++) {
    a_player[p].doerfer.add(new Dorf(p, v));
    a_player[p].CulturPointsGlobal = player.getInt("culture");
    a_player[p].fallenTroops = player.getInt("fallenTroops");
  }
}

JSONObject setPlayerValues(int p) {
  JSONObject obj = new JSONObject();
  obj.setInt("villages", a_player[p].doerfer.size());
  obj.setInt("culture", a_player[p].CulturPointsGlobal);
  obj.setInt("fallenTroops", a_player[p].fallenTroops);
  return obj;
}

JSONArray getBuildArray(int p, int d) {
  String[] names = new String[a_player[p].doerfer.get(d).c_BuildingManager.A_buildings.size() + 1];
  String[] level = new String[a_player[p].doerfer.get(d).c_BuildingManager.A_buildings.size() + 1];
  for (int b = 0; b < names.length - 1; b++) {
    names[b] = str(b);
    level[b] = a_player[p].doerfer.get(d).c_BuildingManager.A_buildings.get(b).S_name+"_"+a_player[p].doerfer.get(d).c_BuildingManager.A_buildings.get(b).level+"_"+b;
  }
  names[names.length - 1] = "buildingCount";
  level[names.length - 1] = str(a_player[p].doerfer.get(d).c_BuildingManager.A_buildings.size());

  return getArray(d, names, level);
}

JSONArray getRessArray(int p, int d) {
  String[] names = {"Holz", "Lehm", "Eisen", "Getreide"};
  int[] values = {a_player[p].doerfer.get(d).c_RessourceManager.storage.Ress[Holz],
    a_player[p].doerfer.get(d).c_RessourceManager.storage.Ress[Lehm],
    a_player[p].doerfer.get(d).c_RessourceManager.storage.Ress[Eisen],
    a_player[p].doerfer.get(d).c_RessourceManager.storage.Ress[Korn]};

  return getArray(d, names, values);
}

JSONArray setTimeArray(int p) {
  String[] names = {"Year", "Month", "Day", "Hour", "Minute", "Second"};
  int[] values = {year(), month(), day(), hour(), minute(), second()};
  return getArray(p, names, values);
}

JSONArray getRessQuantityArray(int p, int d) {
  String[] names = {"Holz", "Lehm", "Eisen", "Getreide"};
  int[] values = {a_player[p].doerfer.get(d).c_RessourceManager.allRess[Holz].length,
    a_player[p].doerfer.get(d).c_RessourceManager.allRess[Lehm].length,
    a_player[p].doerfer.get(d).c_RessourceManager.allRess[Eisen].length,
    a_player[p].doerfer.get(d).c_RessourceManager.allRess[Korn].length};

  return getArray(d, names, values);
}

JSONArray getRessLevelArray(Byte kind, int p, int d) {
  String[] names = new String[a_player[p].doerfer.get(d).c_RessourceManager.allRess[kind].length];
  int[] values = new int[a_player[p].doerfer.get(d).c_RessourceManager.allRess[kind].length];

  for (int r = 0; r < a_player[p].doerfer.get(d).c_RessourceManager.allRess[kind].length; r++) {
    names[r] = "ID_"+r;
    values[r] = a_player[p].doerfer.get(d).c_RessourceManager.allRess[kind][r].level;
  }

  return getArray(d, names, values);
}

JSONArray getArray(int d, String[] names, int[] numbers) {
  JSONArray arr = new JSONArray();
  JSONObject Obj = new JSONObject();
  for (int i = 0; i < numbers.length; i++) {
    Obj.setInt(names[i], numbers[i]);
  }
  arr.setJSONObject(d, Obj);
  return arr;
}

JSONArray getArray(int d, String[] names, int[] numbers, JSONArray arr) {
  JSONObject Obj = new JSONObject();
  for (int i = 0; i < numbers.length; i++) {
    Obj.setInt(names[i], numbers[i]);
  }
  arr.setJSONObject(d, Obj);
  return arr;
}

JSONArray getArray(int d, String[] names, String[] numbers) {
  JSONArray arr = new JSONArray();
  JSONObject Obj = new JSONObject();
  for (int i = 0; i < numbers.length; i++) {
    Obj.setString(names[i], numbers[i]);
  }
  arr.setJSONObject(d, Obj);
  return arr;
}

JSONArray getArray(int d, String[] names, float[] numbers) {
  JSONArray arr = new JSONArray();
  JSONObject Obj = new JSONObject();

  for (int i = 0; i < numbers.length; i++) {
    Obj.setFloat(names[i], numbers[i]);
  }
  arr.setJSONObject(d, Obj);
  return arr;
}
