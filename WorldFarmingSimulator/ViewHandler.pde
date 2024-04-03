class View {
  final Byte ressFields = 0;
  final Byte ressSelect = 1;
  final Byte buildings = 2;
  final Byte buildingSelect = 3;
  final Byte newBuildingSel = 4;
  final Byte newbuildingSelect = 5;

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
  }

  void drawRessFields() {
    int offsetY = 30;
    pg_overlay.noStroke();
    pg_overlay.textSize(20);
    for (int r = 0; r < ressName.length; r++) {
      pg_overlay.text(ressName[r], 250 + (r * (width - 400) / ressName.length), 30 + offsetY);
      for (int i = 0; i < sc_activeRessMgr().allRess[r].length; i++) {
        if (sc_activeRessMgr().allRess[r][i].canLvlUp() == true)
          pg_overlay.fill(colorPalette[OK]);
        else
          pg_overlay.fill(colorPalette[NO]);
        pg_overlay.ellipse(4+250 + (r * (width - 400) / ressName.length), 70 + 30 * i - 6 + offsetY, 20, 20);
        pg_overlay.fill(0);
        if (sc_activeRessMgr().allRess[r][i].toLvl == true)
          pg_overlay.fill(colorPalette[ALERT]);
        pg_overlay.text(sc_activeRessMgr().allRess[r][i].level, 250 + (r * (width - 400) / ressName.length), 70 + 30 * i + offsetY);
        pg_overlay.fill(0);
      }
    }
  }

  void drawRessSel() {
    drawCost(sc_activeRessource().S_name,sc_activeRessource().lvlCost());
  }

  void drawBuildings() {
    btn_AddBuilding.DrawButton();
    for (int b = 0; b < sc_activeBuildMgr().A_buildings.size(); b++) {
      PVector pos = getBuildingPos(b);
      pg_overlay.fill(200);
      if (sc_activeBuildMgr().canUpgrade(b) == true)
        pg_overlay.fill(#00FF00);
      pg_overlay.text(sc_activeBuildMgr().A_buildings.get(b).level, pos.x - 20, pos.y);
      pg_overlay.text(sc_activeBuildMgr().A_buildings.get(b).S_name, pos.x, pos.y);
    }
  }

  void drawCost(String name, int[] cost) {
    btn_levelUp.DrawButton();      //Updates actual RessiField
    pg_overlay.text(name, 300, 100);
    pg_overlay.text("HolzKosten : " + cost[0], 20, 260);
    pg_overlay.text("LehmKosten : " + cost[1], 20, 280);
    pg_overlay.text("EisenKosten : " + cost[2], 20, 300);
    pg_overlay.text("GetreidKosten : " + cost[3], 20, 320);
    pg_overlay.text("Einwohner : " + cost[4], 20, 340);
    pg_overlay.text("Dauer+ : " + cost[5], 20, 420);
    pg_overlay.text("Kulturpunkte / Day+ : " + cost[Kultur], 20, 440);
  }

  void drawBuildingSel() {
    drawCost(sc_activeBuilding().S_name,sc_activeBuilding().lvlCost());
  }
  
  void drawnewBuildingSel() {
    drawCost(sc_activeBuilding().S_name,sc_activeBuilding().lvlCost());
  }

  void drawNewBuildingSel() {
    pg_overlay.text("Gebäudeauswahl", 300, 60);

    for (int i = 0; i < sc_activeBuildMgr().buldNames.length; i++) {
      if(sc_activeStorage().canBuild(getInitCost(i)) == true)
        pg_overlay.fill(colorPalette[OK]);
      else
        pg_overlay.fill(colorPalette[NO]);
      pg_overlay.text(sc_activeBuildMgr().buldNames[i] + "  ", 200, 60 + (i+1) * 30);
    }
  }
}
