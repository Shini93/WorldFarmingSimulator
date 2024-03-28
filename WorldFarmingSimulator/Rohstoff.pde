/*******************
*Rohstofffeld Klasse
********************/
class Rohstoffeld{
  int level = 0;
  byte Typ = 0;
  int RessPerHour = 0;
  int Player = 0;
  int Village = 0;
  boolean toLvl = false;

  
  Rohstoffeld(byte Typs, int _Player, int _Village){
    Typ = Typs;
    Player = _Player;
    Village = _Village;
    
    //Startproduction for each ress
    if(Typ == Holz)
      RessPerHour = 300;
    else if(Typ == Lehm)
      RessPerHour = 300;
    else if(Typ == Eisen)
      RessPerHour = 300;
    else if(Typ == Korn)
      RessPerHour = 500;
  }

  String Name(){
    int n = Typ;
    return ressName[n];
  }

  void levelUp(){
    RessPerHour = round(RessPerHour*0.8+(level+1)*2);
    level++;
    a_player[Player].doerfer.get(Village).c_RessourceManager.a_RohstoffPerHour[Typ] += RessPerHour;
    a_player[Player].doerfer.get(Village).c_RessourceManager.a_CulturePointsPerDay += lvlCost()[Kultur];
    a_player[Player].doerfer.get(Village).population += lvlCost()[4];
  }
  
  int levelPlus(){
    return round(RessPerHour*0.8+(level+1)*2);
  }
  
  int[] lvlCost(){
     int[] cost = {0,0,0,0,0,0,0};    //H,L,E,G.B, TimeinSec
     if (Typ == Holz){
       cost[0] = 50;
       cost[1] = 110;
       cost[2] = 130;
       cost[3] = 70;
       cost[4] = 2;
       cost[5] = 12;
       cost[6] = 1;
     }
     else if (Typ == Lehm){
       cost[0] = 100;
       cost[1] = 40;
       cost[2] = 150;
       cost[3] = 75;
       cost[4] = 2;
       cost[5] = 12;
       cost[6] = 1;
     }
     else if (Typ == Eisen){
       cost[0] = 120;
       cost[1] = 110;
       cost[2] = 60;
       cost[3] = 80;
       cost[4] = 3;
       cost[5] = 12;
       cost[6] = 1;
     }
     else if (Typ == Korn){
       cost[0] = 120;
       cost[1] = 110;
       cost[2] = 130;
       cost[3] = 30;
       cost[4] = 0;
       cost[5] = 12;
       cost[6] = 1;
     }
     cost[Holz] = cost[Holz]  * ( 1+ round(pow(level,1.5)));
     cost[Lehm] = cost[1] * ( 1 + round(pow(level,1.5)));
     cost[Eisen] = cost[2] * ( 1 + round(pow(level,1.5)));
     cost[Korn] = cost[3] * ( 1 + round(pow(level,1.5)));
     cost[Bewohner] = round(sc_activeVillage().TimeFaktor*(cost[Bewohner]+round((level - 1 )*1.5*cost[Bewohner])));
     cost[Time] = cost[Time] * ( 1 + floor(level*0.34));
     cost[Kultur] = round(serverTimeFact*(cost[Kultur]+round((level - 1)*1.5*cost[Kultur])));
     return cost;
  }
  
  boolean canLvlUp(){
    int[] cost = lvlCost();
    return canLvlUp(cost);
  }
  
  boolean canLvlUp(int[] cost){
    if(a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[0] < cost[0])
       return false;
     if(a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[1] < cost[1])
       return false;
     if(a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[2] < cost[2])
       return false;
     if(a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[3] < cost[3])
       return false; 
     return true;
  }
  
  /*************************************
  *update storage
  *************************************/
  boolean lvlUpRess(){
    int[] cost = lvlCost();
     if(canLvlUp(cost) == false)
       return false;
       
     a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[0] -= cost[0];
     a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[1] -= cost[1];
     a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[2] -= cost[2];
     a_player[Player].doerfer.get(Village).c_RessourceManager.storage.Ress[3] -= cost[3];
     //
     a_player[Player].doerfer.get(Village).c_RessourceManager.a_RohstoffPerHour[Korn] -= cost[Bewohner];
     //a_player[Player].doerfer.get(Village).c_RessourceManager.a_CulturePointsPerDay += cost[Kultur];
     return true;
  }
 

}
