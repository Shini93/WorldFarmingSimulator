/**************************** //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
 *Manages all Buildings
 *Upgrades
 *accessing right buildings
 *upgrading Village ressources
 *****************************/

class BuildingManager {
  int Player = 0;
  int Village = 0;
  //Has all available buildings inside -> pops out if building is removed from village
  ArrayList <Building> A_buildings = new ArrayList <Building>();

  String[][] requirementNames = new String[buldNames.length][];
  int[][] requirementLevels = new int[buldNames.length][];
  
  int hexSize = 60;

  Timer checkLvlUpTimer = new Timer(true);    //repeats

  //Konstruktor
  BuildingManager(int _Player, int _Village) {
    Player = _Player;
    Village = _Village;
    checkLvlUpTimer.addTimer(10);    //checks every 10 seconds
    fillBuildingReq();
  }

  //Checks if a building can be built. And needed existing buildings exist.
  boolean reqFullfilled(int b) {
    for (int r = 0; r < requirementNames.length; r++) {
      if (requirementNames[b][r] == null)
        return true;
      if (findBuilding(requirementNames[b][r]) < 0)
        return false;
    }
    return true;
  }

  //Sets building requirements for all buildings.
  void fillBuildingReq() {
    for (int i = 0; i < buldNames.length; i ++) {
      requirementNames[i] = new String[3];
      requirementLevels[i] = new int[3];
    }
    setRequirements(0, 0, buldNames[0], 9999);

    setRequirements(1, 0, buldNames[0], 1);

    setRequirements(2, 0, buldNames[0], 1);

    setRequirements(3, 0, buldNames[0], 3);
    setRequirements(3, 1, buldNames[7], 1);

    setRequirements(4, 0, buldNames[6], 5);
    setRequirements(4, 1, buldNames[5], 3);

    setRequirements(5, 0, buldNames[0], 3);
    setRequirements(5, 1, buldNames[6], 1);

    setRequirements(6, 0, buldNames[0], 3);
    setRequirements(6, 1, buldNames[3], 3);

    setRequirements(7, 0, buldNames[0], 1);

    setRequirements(8, 0, buldNames[7], 15);

    setRequirements(9, 0, buldNames[0], 5);
    setRequirements(9, 1, buldNames[6], 10);

    setRequirements(10, 0, buldNames[0], 3);
    setRequirements(10, 1, buldNames[1], 1);
    setRequirements(10, 2, buldNames[2], 1);

    setRequirements(11, 0, buldNames[10], 20);
    setRequirements(11, 1, buldNames[4], 10);

    setRequirements(12, 0, buldNames[0], 5);
    setRequirements(12, 1, buldNames[14], 5);

    setRequirements(13, 0, buldNames[0], 5);

    setRequirements(14, 0, buldNames[0], 5);

    setRequirements(15, 0, buldNames[0], 5);

    setRequirements(16, 0, buldNames[0], 5);

    setRequirements(17, 0, buldNames[0], 5);

    setRequirements(18, 0, buldNames[0], 5);

    setRequirements(19, 0, buldNames[0], 10);
    setRequirements(19, 0, buldNames[6], 10);

    setRequirements(20, 0, buldNames[7], 10);
    setRequirements(20, 0, buldNames[4], 20);

    setRequirements(21, 0, buldNames[0], 10);
    setRequirements(21, 0, buldNames[6], 15);
  }

  void setRequirements(int id, int p, String building, int lvl) {
    requirementNames[id][p] = building;
    requirementLevels[id][p] = lvl;
  }

  void updateBuildings() {
    if (view.selView != view.buildings)
      return;
    if (checkLvlUpTimer.update() == true) {
      updateBuildingLvlUp();
    }
  }

  void updateBuildingLvlUp() {
    for (int b = 0; b < A_buildings.size(); b++) {
      A_buildings.get(b).canLvlUp = A_buildings.get(b).canLvlUp();
    }
  }

  boolean canUpgrade(int building) {
    return A_buildings.get(building).canLvlUp;
  }

  //returns updated skills of upgraded building
  float findUpgrade(String building) {
    int buildingID = findBuilding(building);
    return A_buildings.get(buildingID).findUpgrade();
  }

  //Level Ups given Building
  void levelUp(String Building) {
    int buildingID = findBuilding(Building);
    A_buildings.get(buildingID).levelUp();
  }

  //returns buildings ID
  int findBuilding(String building) {
    for (int i=0; i<A_buildings.size(); i++) {
      if (A_buildings.get(i).S_name == building)
        return i;
    }
    return -1;
  }

  Boolean openBuilding() {
    if (view.selView != 2)
      return false;
    for (int b = 0; b < A_buildings.size(); b++) {
      PVector pos = getBuildingPos(b, 60);
      if (hexClicked(pos, hexSize) == true) {
        a_player[activePlayer].doerfer.get(a_player[activePlayer].activeVillage).activeBuilding = A_buildings.get(b);
        view.selView = 3;
        return true;
      }
    }
    return false;
  }

  //adds Building to village
  void addBuilding(String building) {
    Building dummy = getBuildingClass(building);
    int[] c = getInitCost(dummy.id);
    Boolean canBuild = false;
    println("build");
    canBuild = sc_activeStorage().canBuild(c);
    if (A_buildings.size() > 0) {
      if (reqFullfilled(dummy.id) == false)
        return;
    }
    if (canBuild == true) {                //each building can only be built once (for now)
      if(findBuilding(building) > -1)      
        return;
      sc_activeVillage().activateTimer(dummy, false);
      sc_activeStorage().substractCost(c);
      updateBuildingLvlUp();
    }
  }

  Building addBuildingWithCost(String building) {
    Building newBuilding = getBuildingClass(building);
    int[] c = getInitCost(findNameID(building));
    a_player[Player].doerfer.get(Village).c_BuildingManager.A_buildings.add(newBuilding);
    a_player[Player].doerfer.get(Village).population += c[Bewohner];
    a_player[Player].doerfer.get(Village).c_RessourceManager.culturePointsVill += c[Kultur];
    return newBuilding;
  }

  void addBuildingFromSave(String building, int neededLevel) {
    Building newBuilding = addBuildingWithCost(building);

    if (building.equals("Rohstofflager"))
      a_player[Player].doerfer.get(Village).c_RessourceManager.storage.maxCapacity += int(newBuilding.findUpgrade());
    else if (building.equals("Kornspeicher"))
      a_player[Player].doerfer.get(Village).c_RessourceManager.storage.maxKorn += int(newBuilding.findUpgrade());


    for (int l = 1; l < neededLevel; l++) {
      a_player[Player].doerfer.get(Village).c_BuildingManager.A_buildings.get(a_player[Player].doerfer.get(Village).c_BuildingManager.A_buildings.size()-1).levelUpNoCost();

      if (building.equals("Rohstofflager"))
        a_player[Player].doerfer.get(Village).c_RessourceManager.storage.maxCapacity += int(newBuilding.findUpgrade());
      else if (building.equals("Kornspeicher"))
        a_player[Player].doerfer.get(Village).c_RessourceManager.storage.maxKorn += int(newBuilding.findUpgrade());
    }
  }

  Building getBuildingClass(String building) {
    Building dummy = new Hauptgebaude(Player, Village);
    if (building.equals("Hauptgebaude")) {
      dummy = new Hauptgebaude(Player, Village);
      sc_activeVillage().TimeFaktor = dummy.findUpgrade();
    } else if (building.equals("Rohstofflager")) {
      dummy = new Rohstofflager(Player, Village);
    } else if (building.equals("Kornspeicher")) {
      dummy = new Kornspeicher(Player, Village);
    } else if (building.equals("Kaserne")) {
      dummy = new Kaserne(Player, Village);
    } else if (building.equals("Stall")) {
      dummy = new Stall(Player, Village);
    } else if (building.equals("Schmiede")) {
      dummy = new Schmiede(Player, Village);
    } else if (building.equals("Turnierplatz")) {
      dummy = new Turnierplatz(Player, Village);
    } else if (building.equals("Werkstatt")) {
      dummy = new Werkstatt(Player, Village);
    } else if (building.equals("Marktplatz")) {
      dummy = new Marktplatz(Player, Village);
    } else if (building.equals("Handelskontor")) {
      dummy = new Handelskontor(Player, Village);
    } else if (building.equals("Baeckerei")) {
      dummy = new Baeckerei(Player, Village);
    } else if (building.equals("Eisengießerei")) {
      dummy = new Eisengießerei(Player, Village);
    } else if (building.equals("Getreidemuehle")) {
      dummy = new Getreidemuehle(Player, Village);
    } else if (building.equals("Lehmbrennerei")) {
      dummy = new Lehmbrennerei(Player, Village);
    } else if (building.equals("Saegewerk")) {
      dummy = new Saegewerk(Player, Village);
    } else if (building.equals("Residenz")) {
      dummy = new Residenz(Player, Village);
    } else if (building.equals("Palast")) {
      dummy = new Palast(Player, Village);
    } else if (building.equals("Rathaus")) {
      dummy = new Rathaus(Player, Village);
    } else if (building.equals("Pferdetraenke")) {
      dummy = new Pferdetraenke(Player, Village);
    } else if (building.equals("Hospital")) {
      dummy = new Hospital(Player, Village);
    } else if (building.equals("Versammlungsplatz")) {
      dummy = new Versammlungsplatz(Player, Village);
    } else if (building.equals("Akademie")) {
      dummy = new Akademie(Player, Village);
    }
    return dummy;
  }

  Building getBuildingClass(int ID) {
    return getBuildingClass(buldNames[ID]);
  }

  void drawBuildings() {
    btn_AddBuilding.DrawButton();
    pg_overlay.textSize(buildingTextSize);
    for (int b = 0; b < sc_activeBuildMgr().A_buildings.size(); b++) {
      PVector pos = getBuildingPos(b, hexSize);
      color c;
      pg_overlay.fill(200);
      if (sc_activeBuildMgr().canUpgrade(b) == true)
        c = colorPalette[OK];
      else
        c = colorPalette[NO];
      hexagon(pos, hexSize, #BBBBBB);
      pg_overlay.fill(c);
      float tw = pg_overlay.textWidth(sc_activeBuildMgr().A_buildings.get(b).S_name);
      float lw = 2 * hexSize - tw;

      pg_overlay.text(sc_activeBuildMgr().A_buildings.get(b).S_name, pos.x - hexSize + 0.5 * lw, pos.y + 10);
      pg_overlay.text(sc_activeBuildMgr().A_buildings.get(b).level, pos.x-10, pos.y - 15);
    }
  }

  PVector getBuildingPos(int nr, int size) {
    PVector pos = getHexPos(nr, size);
    return pos;
  }

  int findNameID(String name) {
    for (int i = 0; i < buldNames.length; i++)
      if (buldNames[i].equals(name) == true)
        return i;
    return -1;
  }

  void drawRequirements() {
    int id = findNameID(sc_activeBuilding().S_name); //<>//
    int offsetX = 200;
    int offsetY = 200;

    pg_overlay.text("Required:", offsetX, offsetY); //<>//

    for (int i = 0; i < requirementNames[id].length; i++) {
      if ( requirementNames[id][i] == null)
        return;
      if (checkBuildingLvlOk( requirementNames[id][i], requirementLevels[id][i] ) == true)
        pg_overlay.fill(colorPalette[OK]);
      else
        pg_overlay.fill(colorPalette[ALERT]);
      pg_overlay.text(requirementNames[id][i] + "   " + requirementLevels[id][i], offsetX, offsetY + (i + 1) * 30);
    }
  }

  boolean checkAllRequirements (int id) {
    for (int i = 0; i < requirementNames[id].length; i++) {
      if ( requirementNames[id][i] == null)
        return true;
      if (checkBuildingLvlOk( requirementNames[id][i], requirementLevels[id][i] ) == false)
        return false;
    }
    return true;
  }

  boolean checkBuildingLvlOk ( String name, int level) {
    int nr =  findBuilding(name);
    if (nr < 0)
      return false;
    if (A_buildings.get(nr).level < level)
      return false;
    return true;
  }
}


int[] getInitCost(int id) {
  int[] cost = new int[7];
  if (id == 0) {
    cost[0] = 70;
    cost[1] = 400;
    cost[2] = 60;
    cost[3] = 20;
    cost[4] = 2;
    cost[5] = 2460;
    cost[Kultur] = 2;
  } else if (id == 1) {
    cost[0] = 130;
    cost[1] = 160;
    cost[2] = 90;
    cost[3] = 40;
    cost[4] = 1;
    cost[5] = 1800;
    cost[Kultur] = 3;
  } else if (id == 2) {
    cost[0] = 80;
    cost[1] = 100;
    cost[2] = 70;
    cost[3] = 20;
    cost[4] = 1;
    cost[5] = 1560;
    cost[Kultur] = 1;
  } else if (id == 3) {
    cost[0] = 210;
    cost[1] = 140;
    cost[2] = 260;
    cost[3] = 120;
    cost[4] = 4;
    cost[5] = 4;
    cost[Kultur] = 1;
  } else if (id == 4) {
    cost[0] = 260;
    cost[1] = 140;
    cost[2] = 220;
    cost[3] = 100;
    cost[4] = 5;
    cost[5] = 2160;
    cost[Kultur] = 2;
  } else if (id == 5) {
    cost[0] = 180;
    cost[1] = 250;
    cost[2] = 500;
    cost[3] = 160;
    cost[4] = 4;
    cost[5] = 1980;
    cost[Kultur] = 2;
  } else if (id == 6) {
    cost[0] = 220;
    cost[1] = 160;
    cost[2] = 90;
    cost[3] = 40;
    cost[4] = 4;
    cost[5] = 1980;
    cost[Kultur] = 5;
  } else if (id == 7) {
    cost[0] = 110;
    cost[1] = 160;
    cost[2] = 90;
    cost[3] = 70;
    cost[4] = 1;
    cost[5] = 2000;
    cost[Kultur] = 1;
  } else if (id == 8) {
    cost[0] = 1750;
    cost[1] = 2250;
    cost[2] = 1530;
    cost[3] = 240;
    cost[4] = 1;
    cost[5] = 3480;
    cost[Kultur] = 1;
  } else if (id == 9) {
    cost[0] = 460;
    cost[1] = 510;
    cost[2] = 600;
    cost[3] = 320;
    cost[4] = 3;
    cost[5] = 3000;
    cost[Kultur] = 4;
  } else if (id == 10) {
    cost[0] = 80;
    cost[1] = 70;
    cost[2] = 120;
    cost[3] = 70;
    cost[4] = 4;
    cost[5] = 1800;
    cost[Kultur] = 4;
  } else if (id == 11) {
    cost[0] = 1400;
    cost[1] = 1330;
    cost[2] = 1200;
    cost[3] = 400;
    cost[4] = 3;
    cost[5] = 3000;
    cost[Kultur] = 4;
  } else if (id == 12) {
    cost[0] = 1200;
    cost[1] = 1480;
    cost[2] = 870;
    cost[3] = 1600;
    cost[4] = 4;
    cost[5] = 3680;
    cost[Kultur] = 1;
  } else if (id == 13) {
    cost[0] = 200;
    cost[1] = 450;
    cost[2] = 510;
    cost[3] = 120;
    cost[4] = 6;
    cost[5] = 4080;
    cost[Kultur] = 1;
  } else if (id == 14) {
    cost[0] = 500;
    cost[1] = 440;
    cost[2] = 380;
    cost[3] = 1240;
    cost[4] = 3;
    cost[5] = 1800;
    cost[Kultur] = 1;
  } else if (id == 15) {
    cost[0] = 440;
    cost[1] = 480;
    cost[2] = 320;
    cost[3] = 50;
    cost[4] = 3;
    cost[5] = 2840;
    cost[Kultur] = 1;
  } else if (id == 16) {
    cost[0] = 520;
    cost[1] = 380;
    cost[2] = 290;
    cost[3] = 90;
    cost[4] = 4;
    cost[5] = 3000;
    cost[Kultur] = 1;
  } else if (id == 17) {
    cost[0] = 580;
    cost[1] = 460;
    cost[2] = 350;
    cost[3] = 180;
    cost[4] = 1;
    cost[5] = 2000;
    cost[Kultur] = 2;
  } else if (id == 18) {
    cost[0] = 550;
    cost[1] = 800;
    cost[2] = 750;
    cost[3] = 250;
    cost[4] = 1;
    cost[5] = 5000;
    cost[Kultur] = 6;
  } else if (id == 19) {
    cost[0] = 1250;
    cost[1] = 1110;
    cost[2] = 1260;
    cost[3] = 600;
    cost[4] = 4;
    cost[5] = 12500;
    cost[Kultur] = 6;
  } else if (id == 20) {
    cost[0] = 780;
    cost[1] = 420;
    cost[2] = 660;
    cost[3] = 540;
    cost[4] = 5;
    cost[5] = 2200;
    cost[Kultur] = 4;
  } else if (id == 21) {
    cost[0] = 320;
    cost[1] = 280;
    cost[2] = 420;
    cost[3] = 360;
    cost[4] = 3;
    cost[5] = 3000;
    cost[Kultur] = 5;
  }
  return cost;
}
