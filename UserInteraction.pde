void mouseClicked() {
  if (sc_findField() == true)
    return;
  if (sc_findBuilding() == true)
    return;
  if (sc_findBuildingToBuild() == true)
    return;
  if(view.selView == view.mapSelect){
     println(map.list.itemClicked());
  }
  int village = a_player[activePlayer].list.itemClicked()[0];
  if(village >= 0){
    a_player[activePlayer].activeVillage = village;
  }
}

Boolean sc_findBuildingToBuild() {
  if (view.selView != 4)
    return false;
  println("sld");
  int rows = 6;
  for (int col = 0; col < float(buldNames.length) / float(rows); col ++) {
    for (int i = 0; i < rows; i++) {
      PVector pos = new PVector(200 + 200 * col, 110 + (i) * 30);
      if (mouseX < pos.x || mouseX > pos.x + 180)
        continue;
      if (mouseY < pos.y || mouseY > pos.y + 30)
        continue;
      Building build = sc_activeBuildMgr().getBuildingClass((buldNames[i + rows * col])); //<>//
      println(i + rows * col);
      a_player[activePlayer].doerfer.get(a_player[activePlayer].activeVillage).activeBuilding = build;
      view.selView = 5;
      return true;
    }
  }
  return false;
}

void exit(){
  saveJSON();
}

void updateButtons() {
  if (btn_levelUp.isFired()) {
    if ( view.selView == 1) {
      updateRessource();
    }
    if (view.selView == 3) {
      updateBuilding();
    }
    if (view.selView == 5) {
      addBuilding();
    }
  } else if (btn_switchPlayer.isFired()) {
    btn_switchPlayer.text = a_player[activePlayer].Name;
    activePlayer= (activePlayer+1)%2;
  } else if (btn_back.isFired()) {
    view.selView = byte((view.selView+1)%2);
  } else if (btn_AddBuilding.isFired()) {
    if(view.selView == 2)
      view.selView = 4;
  } else if (btn_toggleMap.isFired()){
    view.selView = 6;
  } else if (btn_toggleVillRess.isFired()) {
    if (view.selView == 0) {
      view.selView = 2;
      btn_toggleVillRess.text = "Fields";
    } else {
      view.selView = 0;
      btn_toggleVillRess.text = "Village";
    }
  }
}

void addBuilding() {
  sc_activeBuildMgr().addBuilding(sc_activeVillage().activeBuilding.S_name);
  view.selView = view.buildings;
}

void updateRessource() {
  if (sc_activeRessource().toLvl == true)
    return;
  if (sc_activeVillage().activeTimerAvailaible() == false)
    return;
  if (sc_activeRessource().lvlUpRess() == false)
    return;
  sc_activeVillage().activateTimer(sc_activeRessource());
  view.selView = 0;
}

void updateBuilding() {
  if (sc_activeBuilding().toLvl == true)
    return;
  if (sc_activeVillage().activeTimerAvailaible() == false)
    return;
  if(sc_activeBuilding().canLvlUp() == true){
    sc_activeBuildMgr().levelUp(sc_activeBuilding().S_name); 
    sc_activeVillage().activateTimer(sc_activeBuilding(), true);
  }
   //<>//
  view.selView = 2;
}
