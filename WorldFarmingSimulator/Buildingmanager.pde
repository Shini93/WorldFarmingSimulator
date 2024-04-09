/**************************** //<>// //<>// //<>// //<>//
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
  String[] buldNames = {"Hauptgebaude", "Rohstofflager", "Kornspeicher", "Kaserne", "Stall", "Schmiede", "Akademie"};
  
  Timer checkLvlUpTimer = new Timer(true);    //repeats

  //Konstruktor
  BuildingManager(int _Player, int _Village) {
    Player = _Player;
    Village = _Village;
    checkLvlUpTimer.addTimer(10);    //checks every 10 seconds
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
      PVector pos = getBuildingPos(b);
      if (mouseX > pos.x - 50 && mouseY < pos.x + 50) {
        if (mouseY > pos.y - 20 && mouseY < pos.y + 20) {
          a_player[activePlayer].doerfer.get(a_player[activePlayer].activeVillage).activeBuilding = A_buildings.get(b);
          view.selView = 3;
          return true;
        }
      }
    }
    return false;
  }

  //adds Building to village
  void addBuilding(String building) {
    Building dummy = getBuildingClass(building);
    int[] c = getInitCost(dummy.id);
    Boolean canBuild = false;
    canBuild = sc_activeStorage().canBuild(c);

    if (canBuild == true) {
      sc_activeVillage().activateTimer(dummy, false);
      sc_activeStorage().substractCost(c);
      updateBuildingLvlUp();
    }
  }

  void addBuildingFromSave(String building, int neededLevel) {
    Building newBuilding = getBuildingClass(building);
    a_player[Player].doerfer.get(Village).c_BuildingManager.A_buildings.add(newBuilding);
    
    if (building.equals("Rohstofflager"))
        a_player[Player].doerfer.get(Village).c_RessourceManager.storage.maxCapacity += int(newBuilding.findUpgrade());
      else if (building.equals("Kornspeicher"))
        a_player[Player].doerfer.get(Village).c_RessourceManager.storage.maxKorn += int(newBuilding.findUpgrade());
    
     //<>// //<>//
    for (int l = 0; l < neededLevel; l++) {
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
    } else if (building.equals("Akademie")) {
      dummy = new Akademie(Player, Village);
    }
    return dummy;
  }
  
  Building getBuildingClass(int ID) {
    return getBuildingClass(buldNames[ID]);
  }
}

  

int[] getInitCost(int id) {
  int[] cost = new int[7];
  if (id == 0) {
    cost[0] = 200;
    cost[1] = 250;
    cost[2] = 150;
    cost[3] = 170;
    cost[4] = 2;
    cost[5] = 200;
    cost[Kultur] = 3;
  } else if (id == 1) {
    cost[0] = 200;
    cost[1] = 250;
    cost[2] = 150;
    cost[3] = 170;
    cost[4] = 2;
    cost[5] = 10;
    cost[Kultur] = 3;
  } else if (id == 2) {
    cost[0] = 200;
    cost[1] = 250;
    cost[2] = 150;
    cost[3] = 170;
    cost[4] = 2;
    cost[5] = 200;
    cost[Kultur] = 3;
  } else if (id == 3) {
    cost[0] = 200;
    cost[1] = 250;
    cost[2] = 150;
    cost[3] = 170;
    cost[4] = 2;
    cost[5] = 200;
    cost[Kultur] = 3;
  } else if (id == 4) {
    cost[0] = 200;
    cost[1] = 250;
    cost[2] = 150;
    cost[3] = 170;
    cost[4] = 2;
    cost[5] = 200;
    cost[Kultur] = 3;
  } else if (id == 5) {
    cost[0] = 200;
    cost[1] = 250;
    cost[2] = 150;
    cost[3] = 170;
    cost[4] = 2;
    cost[5] = 200;
    cost[Kultur] = 3;
  } else if (id == 6) {
    cost[0] = 200;
    cost[1] = 250;
    cost[2] = 150;
    cost[3] = 170;
    cost[4] = 2;
    cost[5] = 200;
    cost[Kultur] = 3;
  } else if (id == 7) {
    cost[0] = 200;
    cost[1] = 250;
    cost[2] = 150;
    cost[3] = 170;
    cost[4] = 2;
    cost[5] = 200;
    cost[Kultur] = 3;
  } else if (id == 8) {
    cost[0] = 200;
    cost[1] = 250;
    cost[2] = 150;
    cost[3] = 170;
    cost[4] = 2;
    cost[5] = 200;
    cost[Kultur] = 3;
  } else if (id == 9) {
    cost[0] = 200;
    cost[1] = 250;
    cost[2] = 150;
    cost[3] = 170;
    cost[4] = 2;
    cost[5] = 200;
    cost[Kultur] = 3;
  } else if (id == 10) {
    cost[0] = 200;
    cost[1] = 250;
    cost[2] = 150;
    cost[3] = 170;
    cost[4] = 2;
    cost[5] = 200;
    cost[Kultur] = 3;
  }
  return cost;
}
