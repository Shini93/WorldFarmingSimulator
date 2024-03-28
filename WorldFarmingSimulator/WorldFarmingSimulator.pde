/**********************
 *Glob Variablen
 **********************/
Spieler[] a_player = new Spieler[2];      //Vera & Tobi
String[] ressName = {"Holz", "Lehm", "Eisen", "Korn"};
PGraphics pg_overlay;                      //Oberfläche
//PImage pi_ressourceField;
Button btn_levelUp;                         //Button für lvlUps
Button btn_back;                         //Button für lvlUps
Button btn_switchPlayer;                         //Button für lvlUp
Button btn_toggleVillRess;                         //Button für lvlUps
Button btn_AddBuilding;                         //Button für lvlUps
float serverTimeFact = 1;
int activePlayer = 0;                      //Player to play
Byte windows = 0;
Byte android = 1;

Byte Holz = 0;
Byte Lehm = 1;
Byte Eisen = 2;
Byte Korn = 3;
Byte Bewohner = 4;
Byte Time = 5;
Byte Kultur =6;


Byte operatingSystem = windows;

color[] colorPalette = {#00FF00,200,#FF0000};
final static int OK = 0;
final static int NO = 1;
final static int ALERT = 2;

View view;

void settings() {
  if (operatingSystem == windows)
    size(1280, 720);
  else
    fullScreen();
}

void setup() {
  //fullScreen(1);
  view = new View(0);
  loadPlayer();
  pg_overlay = createGraphics(width, height);
  //pi_ressourceField.resize(width,height);

  debugAddValues();
  initInterface();
  
  startGame();
}

void startGame(){
  loadSavestate();
  setInitValues();
}

void loadSavestate(){
}

void setInitValues(){
  sc_activeBuildMgr().updateBuildingLvlUp(); 
}

void loadPlayer() {
  a_player[0] = new Spieler("Tobi", 0);
  a_player[1] = new Spieler("Vera-Chan", 1);
}
void debugAddValues() {
  //sc_activeVillage().c_BuildingManager.addBuilding("Rohstofflager");
  //sc_activeVillage().c_BuildingManager.levelUp("Rohstofflager");
  //sc_activeVillage().c_BuildingManager.levelUp("Hauptgebaude");
}

void initInterface() {
  /***********************
   *Adds User Interface
   ************************/
  pg_overlay.beginDraw();
  btn_switchPlayer = new Button(10, height - 40, a_player[(activePlayer+1)%2].Name);
  btn_back = new Button(width-400, height - 40, "back");
  btn_toggleVillRess = new Button(10, 200, "Village");
  btn_levelUp = new Button(10, 500, "upgrade");
  btn_AddBuilding = new Button (10, 250, "Neues Gebäude");
  btn_AddBuilding.boxSizeX = 150;
  btn_toggleVillRess.boxSizeX = 150;
  pg_overlay.endDraw();
}

void draw() {
  fill(125);
  rect(0, 0, width, height);

  //Updates the players
  for (Spieler s : a_player) {
    s.updatePlayer();
  }

  //Updates the user interface
  updatepg_overlay();
}
