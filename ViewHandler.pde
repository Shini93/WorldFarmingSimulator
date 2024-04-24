class View {
  final Byte ressFields = 0;
  final Byte ressSelect = 1;
  final Byte buildings = 2;
  final Byte buildingSelect = 3;
  final Byte newBuildingSel = 4;
  final Byte newbuildingSelect = 5;
  final Byte mapSelect = 6;

  Byte selView = 0;

  View(int view) {
    selView = byte(view);
    //drawView();
  }

  void setView (int view) {
    selView = byte(view);
    drawView();
  }

  void drawView() {
    if (selView == ressFields)
      drawRessFields();
    else if (selView == ressSelect)
      drawRessSel();
    else if (selView == buildings)
      drawBuildings();
    else if (selView == buildingSelect)
      drawBuildingSel();
    else if (selView == newBuildingSel)
      drawNewBuildingSel();
    else if (selView == newbuildingSelect)
      drawnewBuildingSel();
    else if (selView == mapSelect)
      drawMap();
  }
  
  void drawMap(){
    map.drawMap(sc_activeVillage().coord);
  }

  void drawRessFields() {
    sc_activeRessMgr().drawRessources();
  }

  void drawRessSel() {
    drawCost(sc_activeRessource().S_name, sc_activeRessource().lvlCost(sc_activeRessource().level + 1), sc_activeRessource().level, true);
    pg_overlay.text(sc_activeRessource().realRessPerHour + "  ->  " +( sc_activeRessource().ressPerHourNextLvl() + sc_activeRessource().realRessPerHour), 200,200);
  }

  void drawBuildings() {
    sc_activeBuildMgr().drawBuildings();
  }

  void drawCost(String name, int[] cost, int lvl, boolean RessFields) {
    btn_levelUp.DrawButton();      //Updates actual RessiField
    pg_overlay.text(name, 300, 100);
    pg_overlay.text("HolzKosten : " + cost[0], 20, 260);
    pg_overlay.text("LehmKosten : " + cost[1], 20, 280);
    pg_overlay.text("EisenKosten : " + cost[2], 20, 300);
    pg_overlay.text("GetreidKosten : " + cost[3], 20, 320);
    pg_overlay.text("Einwohner : " + cost[4], 20, 340);
    if(RessFields == true)
    pg_overlay.text("Stufe : " + lvl + "  ->  "+ (lvl + 1), 20, 360);
    else
    pg_overlay.text("Stufe : " + (lvl - 1)+ "  ->  "+ (lvl ), 20, 360);
    
    pg_overlay.text("Dauer+ : " + cost[5], 20, 420);
    pg_overlay.text("Kulturpunkte / Day+ : " + cost[Kultur], 20, 440);
  }

  void drawBuildingSel() {
    drawCost(sc_activeBuilding().S_name, sc_activeBuilding().lvlCost(), sc_activeBuilding().level, true);
  }

  void drawnewBuildingSel() {
    drawCost(sc_activeBuilding().S_name, sc_activeBuilding().lvlCost(), sc_activeBuilding().level, false);
    sc_activeBuildMgr().drawRequirements();
  }

  void drawNewBuildingSel() {
    pg_overlay.text("Gebäudeauswahl", 300, 60);
    int rows = 6;
    for (int col = 0; col < float(buldNames.length) / float(rows); col ++) {
      for (int i = 0; i < rows; i++) {
        if(i + col * rows > buldNames.length - 1)
          return;
        if (sc_activeStorage().canBuild(getInitCost(i + rows * col)) == true && sc_activeBuildMgr().checkAllRequirements(i + col * rows) == true )
          pg_overlay.fill(colorPalette[OK]);
        else
          pg_overlay.fill(colorPalette[NO]);
        pg_overlay.rect(200 + 200 * col, 110 + (i) * 30, 180, 30);
        pg_overlay.fill(0);
        pg_overlay.text(buldNames[i + rows * col] + "  ", 200 + 200*col + 10, 100 + (i+1) * 30);
      }
    }
  }
}
