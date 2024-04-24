/*********************************** //<>// //<>//
 *Handles all ressource in and output
 ************************************/
class RessourceManager {
  int Player = 0;
  int village = 0;
  int ressSize = 50;

  //Rohstofffelder
  int culturePointsVill;
  color[] RessCol = {#FFB564, #FF9664, #A9D1FA, #FAE4A9};
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

  PVector getRessourcePos(int k, int nr) {
    int count = 0;
    for(int i = 0; i < k; i++){
      count += allRess[i].length;
    }
    count += nr;
    PVector pos = getHexPos(count, ressSize);
    return pos;
  }

  void drawRessources() {
    pg_overlay.textSize(ressourceTextSize);
    for (int k = 0; k < 4; k++) {
      pg_overlay.fill(0);
      //pg_overlay.text(ressName[k], int(p.x - 25), int(p.y - 60));
      for ( int nr = 0; nr < allRess[k].length; nr++) {
        PVector pos = getRessourcePos(k, nr);
        color finalCol;
        if(allRess[k][nr].canLvlUp() == true && allRess[k][nr].toLvl == false)
          finalCol = RessCol[k];
        else
          finalCol  = color(0.6*red(RessCol[k]),0.6*green(RessCol[k]),0.6*blue(RessCol[k]));
        hexagon(pos, ressSize, finalCol);
        
        if (sc_activeRessMgr().allRess[k][nr].canLvlUp() == true)
          pg_overlay.fill(colorPalette[OK]);
        else
          pg_overlay.fill(colorPalette[NO]);
        
        pg_overlay.text(allRess[k][nr].level, int(pos.x - 5), int(pos.y + 5));
      }
    }
    pg_overlay.textSize(normalTextSize);
  }

  //einmaliges erstellen der ressis und rohstoffe pro Stunde
  void SetupRessis() {
    int count = 0;
    count = setupRohstoffelder(allRess[0], byte(0), count);
    count = setupRohstoffelder(allRess[1], byte(1), count);
    count = setupRohstoffelder(allRess[2], byte(2), count);
    setupRohstoffelder(allRess[3], byte(3), count);
  }

  void fillStorageAfterTime (long seconds) {
    for (int r = 0; r < 4; r++) {
      int RessPlus = int(a_RohstoffPerHour[r]*seconds/3600);
      ;
      if (RessPlus != 0) {
        storage.Ress[r] += RessPlus;
        a_timeSinceUpdate[r] = millis();
      }
    }
    storage.Update();
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

  void updateCulturePoints() {
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
    if (view.selView != 0)
      return false;
    for (int k = 0; k < 4; k ++) {
      for (int i = 0; i < allRess[k].length; i++) {
        if (findField(k, i) == true) {
          a_player[Player].doerfer.get(village).activeRessource = allRess[k][i];  //<>// //<>// //<>// //<>//
          view.selView = 1;
          return true;
        }
      }
    }
    return false;
  }

  Boolean findField(int k, int i) {
    return hexClicked(getRessourcePos(k, i),ressSize);
  }  
}
