/****************************** //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
 *Parent Class for all buildings
 ******************************/
class Building {
  int id = -1;      //Building ID
  String S_name = "building";  //Building name
  int level = 0;    //Level of Building
  int Player = 0;   //PlayerID
  int Village = 0;  //VillageID
  boolean toLvl = false;
  boolean canLvlUp = false;
  int[] Cost = new int[6];
  float special = 0.0;
  String specialName;
  Building() {
  }

  //returns update variables for village
  float findUpgrade() {
    return 0.0;
  }

  //Upgrades Building
  void Upgrade() {
  }

  /*******************************
   *cost per level
   *******************************/
  int[] lvlCost() {
    int[] cost = Cost.clone();    //H,L,E,G.B, TimeinSec

    cost[0] = Cost[0] * ( 1 + round(pow(level, 1.4)));
    cost[1] = Cost[1] * ( 1 + round(pow(level, 1.4)));
    cost[2] = Cost[2] * ( 1 + round(pow(level, 1.4)));
    cost[3] = Cost[3] * ( 1 + round(pow(level, 1.4)));
    cost[Bewohner] = Cost[4] * ( 1 + floor(level*0.6));
    cost[Time] = round(sc_activeVillage().TimeFaktor*(Cost[5]+round(level*1.5*Cost[5])));
    cost[Kultur] = round(serverTimeFact*(cost[Kultur]+round((level)*1.5*cost[Kultur])));

    return cost;
  }

  boolean canLvlUp() {
    int[] cost = lvlCost();
    return sc_activeStorage().canBuild(cost);
  }

  /****************
   *update Building
   ****************/
  boolean lvlUpBuilding(int[] cost) {
    if (a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[0] < cost[0])
      return false;
    if (a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[1] < cost[1])
      return false;
    if (a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[2] < cost[2])
      return false;
    if (a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[3] < cost[3])
      return false;

    a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[0] -= cost[0];
    a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[1] -= cost[1];
    a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[2] -= cost[2];
    a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[3] -= cost[3];
    a_player[Player].doerfer.get(Village).population += cost[4];
    a_player[Player].doerfer.get(Village).c_RessourceManager.a_RohstoffPerHour[3] -= cost[4];
    return true;
  }

  boolean lvlUpBuilding() {
    int[] cost = lvlCost();
    return lvlUpBuilding(cost);
  }

  /********************
   *Levels Up Building
   *******************/
  boolean levelUp() {
    if ( lvlUpBuilding(lvlCost())) {
      level++;
      Upgrade();
      sc_activeBuildMgr().updateBuildingLvlUp();
      return true;
    }
    return false;
  }

  /********************
   *Levels Up Building
   *******************/
  void levelUpNoCost() {
    level++;
    Upgrade();
    int[] c = lvlCost();
    a_player[Player].doerfer.get(Village).c_RessourceManager.a_CulturePointsPerDay += c[Kultur];
    a_player[Player].doerfer.get(Village).population += c[Bewohner];
    sc_activeBuildMgr().updateBuildingLvlUp();
  }
}

/**************************************/
class Hauptgebaude extends Building {
  
  Hauptgebaude(int _Player, int _Village) {
    S_name = "Hauptgebaude";
    Player = _Player;
    Village = _Village;
    id = 0;
    special = 0.9;
    specialName = "Bauzeit";
    Cost = getInitCost(id);
  }
  //@Override public
  float findUpgrade() {
    return special;
  }
  ////@Override
  void Upgrade() {
    special-=0.1/(level+1);
  }
}

/************************************/
class Rohstofflager extends Building {
  Rohstofflager(int _Player, int _Village) {
    S_name = "Rohstofflager";
    Player = _Player;
    Village = _Village;
    id = 1;
    special = 400;
    specialName = "Storagesize";
    Cost = getInitCost(id);
  }

  ////@Override
  float findUpgrade() {
    return special;
  }
  ////@Override
  void Upgrade() {
    special+=100*level;
  }
  //@Override
  boolean levelUp() {
    if ( lvlUpBuilding(lvlCost())) {
      level++;
      Upgrade();
      sc_activeRessMgr().storage.maxCapacity += findUpgrade();
      return true;
    }
    return false;
  }
}

/*************************************/
class Kornspeicher extends Building {
  Kornspeicher(int _Player, int _Village) {
    S_name = "Kornspeicher";
    Player = _Player;
    Village = _Village;
    id = 2;
    special = 400;
    specialName = "Kornsize";
    Cost = getInitCost(id);
  }

  //@Override
  float findUpgrade() {
    return special;
  }
  //@Override
  void Upgrade() {
    special+=100*level;
  }
  //@Override
  boolean levelUp() {
    if ( lvlUpBuilding(lvlCost())) {
      level++;
      Upgrade();
      sc_activeRessMgr().storage.maxKorn += findUpgrade();
      return true;
    }
    return false;
  }
}

/**************************************/
class Kaserne extends Building {
  Kaserne(int _Player, int _Village) {
    S_name = "Kaserne";
    Player = _Player;
    Village = _Village;
    special = 0.975;
    specialName = "Troop building speed";
    id = 3;
    Cost = getInitCost(id);
  }
  //@Override
  float findUpgrade() {
    return special;
  }
  //@Override
  void Upgrade() {
    special-=0.05/(level+1);
  }
}

/**************************************/
class Stall extends Building {
  Stall(int _Player, int _Village) {
    S_name = "Stall";
    Player = _Player;
    Village = _Village;
    id = 4;
    special = 0.975;
    specialName = "Horses building speed";
    Cost = getInitCost(id);
  }
  //@Override
  float findUpgrade() {
    return special;
  }
  //@Override
  void Upgrade() {
    special-=0.05/(level+1);
  }
}

/**************************************/
class Schmiede extends Building {
  Schmiede(int _Player, int _Village) {
    S_name = "Schmiede";
    Player = _Player;
    Village = _Village;
    id = 5;
    special = 0.975;
    specialName = "smithery bonus";
    Cost = getInitCost(id);
  }
  //@Override
  float findUpgrade() {
    return special;
  }
  //@Override
  void Upgrade() {
    special-=0.05/(level+1);
  }
}

/**************************************/
class Akademie extends Building {
  Akademie(int _Player, int _Village) {
    S_name = "Akademie";
    Player = _Player;
    Village = _Village;
    id = 6;
    special = 0.975;
    specialName = "Research speed";
    Cost = getInitCost(id);
  }
  //@Override
  float findUpgrade() {
    return special;
  }
  //@Override
  void Upgrade() {
    special-=0.05/(level+1);
  }
}
