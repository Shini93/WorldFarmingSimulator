/***********************************
*Handles everything inside a village
************************************/
class Dorf{
  int id = 0;                                //villageid (from player)
  int population = 0;                        //startpop  
  int Player = 0;        
  float TimeFaktor = 1.0;                    //speed mul for buildings and ressis
  float TimeFactorTroops = 1.0;              //Time faktor Troops infantery
  float TimeFactorHorses = 1.0;              //Time faktor Troops infantery
  float BonusSchmiede = 1.0;                 //Schmiede bonus for troops
  float TimeFactorResearch = 1.0;
  String name = "";
  Timer[] timer = new Timer[3];              //Timer when Buildings or ressis are updated
  Rohstoffeld activeRessource = new Rohstoffeld(byte(0),0,0);    //button used to lvl up this one.
  Building activeBuilding = new Building();
  RessourceManager c_RessourceManager;                           //handles all Ressources
  BuildingManager c_BuildingManager;                             //handles all Buildings
  
  Dorf(int _Player, int _id, int _Holz, int _Lehm, int _Eisen, int _Getreide){
    id = _id;
    Player = _Player;
    name = "Dorf "+_id;
    c_RessourceManager = new RessourceManager(Player, id, _Holz, _Lehm, _Eisen, _Getreide);
    c_BuildingManager = new BuildingManager(Player,id);
    activeRessource = c_RessourceManager.allRess[0][0];
    
    
    Building dummy = new Hauptgebaude(Player, id);
    c_BuildingManager.A_buildings.add(dummy);
    TimeFaktor = c_BuildingManager.findUpgrade("Hauptgebaude");
    
    //Timer instances
    for(int i=0;i<3;i++) //<>//
      timer[i] = new Timer();
  }
  
  //updates storage and timer
  void updateVillage(){
    c_RessourceManager.updateStorage();
    c_RessourceManager.updateCulturePoints();
    c_BuildingManager.updateBuildings();
    for(Timer t: timer)
      t.update();
  }
}
