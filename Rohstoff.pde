/******************* //<>// //<>//
 *Rohstofffeld Klasse
 ********************/
class Rohstoffeld {
  int level = 0;
  byte Typ = 0;
  int RessPerHour = 0;
  int realRessPerHour = 3;
  int Player = 0;
  int Village = 0;
  boolean toLvl = false;
  String S_name = "";

  Rohstoffeld(byte Typs, int _Player, int _Village) {
    Typ = Typs;
    Player = _Player;
    Village = _Village;

    //Startproduction for each ress
    if (Typ == Holz) {
      RessPerHour = 3;
      S_name = "Holz";
    } else if (Typ == Lehm) {
      RessPerHour = 3;
      S_name = "Lehm";
    } else if (Typ == Eisen) {
      RessPerHour = 3;
      S_name = "Eisen";
    } else if (Typ == Korn) {
      RessPerHour = 3;
      S_name = "Getreide";
    }
  }

  String Name() {
    int n = Typ;
    return ressName[n];
  }

  float ressPerHourNextLvlDif() {
    return  int(5*pow(0.25*level+0.5, 2.25));
  }
 //<>//
  int ressPerHourNextLvl() {
    return  int(ressPerHourNextLvlDif() + RessPerHour);
  }

  void levelUp() {
    RessPerHour +=  ressPerHourNextLvlDif();
    level++;
    a_player[Player].doerfer.get(Village).c_RessourceManager.a_RohstoffPerHour[Typ] += RessPerHour;
    realRessPerHour += RessPerHour;
    a_player[Player].doerfer.get(Village).c_RessourceManager.a_CulturePointsPerDay += lvlCost()[Kultur];
    a_player[Player].doerfer.get(Village).population += lvlCost()[4];
    a_player[Player].doerfer.get(Village).c_RessourceManager.a_RohstoffPerHour[Korn] -= lvlCost()[Bewohner];

    sc_activeBuildMgr().updateBuildingLvlUp();
  }

  int[] lvlCost(int chosenLevel){
    int[] cost = {0, 0, 0, 0, 0, 0, 0};    //H,L,E,G.B, TimeinSec
    if (Typ == Holz) {
      cost[0] = 40;
      cost[1] = 100;
      cost[2] = 50;
      cost[3] = 60;
      cost[4] = 2;
      cost[5] = 260;
      cost[6] = 1;
    } else if (Typ == Lehm) {
      cost[0] = 80;
      cost[1] = 40;
      cost[2] = 80;
      cost[3] = 50;
      cost[4] = 2;
      cost[5] = 220;
      cost[6] = 1;
    } else if (Typ == Eisen) {
      cost[0] = 100;
      cost[1] = 80;
      cost[2] = 30;
      cost[3] = 60;
      cost[4] = 3;
      cost[5] = 450;
      cost[6] = 1;
    } else if (Typ == Korn) {
      cost[0] = 70;
      cost[1] = 90;
      cost[2] = 80;
      cost[3] = 20;
      cost[4] = 0;
      cost[5] = 150;
      cost[6] = 0;
    }
    for (int i = 1; i < chosenLevel; i++) {
      cost[Holz] = round(cost[Holz]  * 1.66);
      cost[Lehm] = round(cost[Lehm]  * 1.66);
      cost[Eisen] = round(cost[Eisen]  * 1.66);
      cost[Korn] = round(cost[Korn]  * 1.66);
      cost[Bewohner] = round((cost[Bewohner]+round((level )*1.5*cost[Bewohner])));
      cost[Time] = round(sc_activeVillage().TimeFaktor*cost[Time] * ( 1 + floor(level*0.34)));
      cost[Kultur] = round(serverTimeFact*(cost[Kultur]+round((level - 1)*1.5*cost[Kultur])));
    }
    return cost;
  }

  int[] lvlCost() {
    return lvlCost(level);
  }

  boolean canLvlUp() {
    int[] cost = lvlCost();
    return canLvlUp(cost);
  }

  boolean canLvlUp(int[] cost) {
    if (a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[0] < cost[0])
      return false;
    if (a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[1] < cost[1])
      return false;
    if (a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[2] < cost[2])
      return false;
    if (a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[3] < cost[3])
      return false;
    return true;
  }

  /*************************************
   *update storage
   *************************************/
  boolean lvlUpRess() {
    int[] cost = lvlCost();
    if (canLvlUp(cost) == false)
      return false;

    a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[0] -= cost[0];
    a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[1] -= cost[1];
    a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[2] -= cost[2];
    a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[3] -= cost[3];
    //
    //a_player[Player].doerfer.get(Village).c_RessourceManager.a_RohstoffPerHour[Korn] -= cost[Bewohner];
    //a_player[Player].doerfer.get(Village).c_RessourceManager.a_CulturePointsPerDay += cost[Kultur];
    return true;
  }
}
