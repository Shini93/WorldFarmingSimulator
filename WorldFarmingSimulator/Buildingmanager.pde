/**************************** //<>// //<>//
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
  
  void updateBuildings(){
    if (view.selView != view.buildings)
      return;
    if(checkLvlUpTimer.update() == true){
      updateBuildingLvlUp();
    }
  }

  void updateBuildingLvlUp(){
     for(int b = 0; b < A_buildings.size(); b++){
        A_buildings.get(b).canLvlUp = A_buildings.get(b).canLvlUp();
     }
  }
  
  boolean canUpgrade(int building){
    return A_buildings.get(building).canLvlUp;
  }

  //returns updated skills of upgraded building
  float findUpgrade(String building) {
    int buildingID = findBuilding(building);
    println(building);
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
          println(A_buildings.get(b).S_name);
          return true;
        }
      }
    }
    return false;
  }

  //adds Building to village
  void addBuilding(String building) {
    Building dummy = new Hauptgebaude(Player, Village);
    Boolean canBuild = false;
    if (building == "Hauptgebaude") {
      dummy = new Hauptgebaude(Player, Village);
      sc_activeVillage().TimeFaktor = dummy.findUpgrade();
    } else if (building == "Rohstofflager") {
      dummy = new Rohstofflager(Player, Village);
    } else if (building == "Kornspeicher") {
      dummy = new Kornspeicher(Player, Village);
    } else if (building == "Kaserne") {
      dummy = new Kaserne(Player, Village);
    } else if (building == "Stall") {
      dummy = new Stall(Player, Village);
    } else if (building == "Schmiede") {
      dummy = new Schmiede(Player, Village);
    } else if (building == "Akademie") {
      dummy = new Akademie(Player, Village);
    }
    int[] c = getInitCost(dummy.id);
    canBuild = sc_activeStorage().canBuild(c);
    
    if (canBuild == true) {
      A_buildings.add(dummy);
      sc_activeStorage().substractCost(c);
      sc_activeRessMgr().a_CulturePointsPerDay += c[Kultur];
      if(building == "Rohstofflager")
        sc_activeRessMgr().storage.maxCapacity += int(dummy.findUpgrade());
      else if (building == "Kornspeicher") 
        sc_activeRessMgr().storage.maxKorn += int(dummy.findUpgrade());
      updateBuildingLvlUp();
    }
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
    cost[5] = 200;
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
