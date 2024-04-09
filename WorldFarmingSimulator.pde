import java.util.Calendar;
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

Timer saveTimer;
float serverTimeFact = 1;
int activePlayer = 0;                      //Player to play

final static Byte windows = 0;
final static Byte android = 1;

final static Byte Holz = 0;
final static Byte Lehm = 1;
final static Byte Eisen = 2;
final static Byte Korn = 3;
final static Byte Bewohner = 4;
final static Byte Time = 5;
final static Byte Kultur =6;

final static int OK = 0;
final static int NO = 1;
final static int ALERT = 2;

Byte operatingSystem = windows;

color[] colorPalette = {#008800,100,#FF0000};

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
  //saveJSON();
  
}

void startGame(){
  loadSavestate();
  setInitValues();
  
  saveTimer = new Timer(true);
  saveTimer.addTimer(10);
}

void loadSavestate(){
  loadJSON();
}

void setInitValues(){
  sc_activeBuildMgr().updateBuildingLvlUp(); 
}

void loadPlayer() {
  a_player[0] = new Spieler("Tobi", 0);
  a_player[1] = new Spieler("Vera", 1);
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
  
  if(saveTimer.update() == true){
    saveJSON();
  }
}
