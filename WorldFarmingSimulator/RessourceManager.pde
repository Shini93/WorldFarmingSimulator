/***********************************
 *Handles all ressource in and output
 ************************************/
class RessourceManager {
  int Player = 0;
  int village = 0;

  //Rohstofffelder
  int[] Ressfields = {4, 4, 4, 6};
  int culturePointsVill;
  Rohstoffeld[][] allRess = new Rohstoffeld[4][];

  Storage storage = new Storage();           //one storage per Village (yet)

  //ressis pro Stunde gesammelt
  int[] a_RohstoffPerHour = {0, 0, 0, 0};    //H,L,E,G,Kultur
  int a_CulturePointsPerDay = 0;

  //Zeit für auffüllen für jede ROhstoffsorte +  culturpunkte
  int[] a_timeSinceUpdate = {second(), second(), second(), second(), second()};

  RessourceManager(int playerID, int villageID, int _Holz, int _Lehm, int _Eisen, int _Getreide) {
    Player = playerID;
    village = villageID;

    allRess[0] = new Rohstoffeld[_Holz];
    allRess[1] = new Rohstoffeld[_Lehm];
    allRess[2] = new Rohstoffeld[_Eisen];
    allRess[3] = new Rohstoffeld[_Getreide];

    SetupRessis();
  }

  //einmaliges erstellen der ressis und rohstoffe pro Stunde
  void SetupRessis() {
    int count = 0;
    count = setupRohstoffelder(allRess[0], byte(0), count);
    count = setupRohstoffelder(allRess[1], byte(1), count);
    count = setupRohstoffelder(allRess[2], byte(2), count);
    setupRohstoffelder(allRess[3], byte(3), count);
  }

  //erstellt rohstofffelder
  int setupRohstoffelder(Rohstoffeld[] rohstoff, byte typ, int count) {
    for (int i=0; i<rohstoff.length; i++) {
      rohstoff[i] = new Rohstoffeld(typ, Player, village);
      a_RohstoffPerHour[typ] += rohstoff[i].RessPerHour;
      // a_AllRess[count] = rohstoff[i];
      count++;
    }
    return count;
  }

  //füllt lager auf.
  void updateStorage() {
    int secondNow = millis();
    for (int i=0; i<4; i++) {
      int RessPlus = int(a_RohstoffPerHour[i]*abs(secondNow-a_timeSinceUpdate[i])/3600000);
      if (RessPlus != 0) {
        storage.Ress[i] += RessPlus;
        a_timeSinceUpdate[i] = millis();
      }
    }
    storage.Update();
  }
  
  void updateCulturePoints(){
    int secondNow = millis();
    int CulturePlus = int( a_CulturePointsPerDay*abs(secondNow-a_timeSinceUpdate[4])/86400000);
    if (CulturePlus != 0) {
        culturePointsVill += CulturePlus;
        a_player[0].CulturPointsGlobal += CulturePlus;
        a_timeSinceUpdate[4] = millis();
      }
  }

  //Searchs for ressifield to open
  Boolean findField() {
   if(view.selView != 0)
     return false;
     println("Field");
     int offsetY = 30;
    for (int r = 0; r < ressName.length; r++) {
      if (mouseX >  250 + (r * (width - 400) / ressName.length) - 0.5 * ((width - 400) / ressName.length) && mouseX <  250 + ((r + 1) * (width - 400) / ressName.length) - 0.5 * ((width - 400) / ressName.length)) {
        for (int i = 0; i < sc_activeRessMgr().allRess[r].length; i++) {
          if (mouseY > 40 + 30 * i + offsetY && mouseY < 40 + 30 * (i + 1) + offsetY) { //<>// //<>//
            a_player[activePlayer].doerfer.get(a_player[activePlayer].activeVillage).activeRessource = sc_activeRessMgr().allRess[r][i];  //<>// //<>//
            view.selView = 1;
            return true;
          }
        }
      }
    }
    return false;
  }
}
