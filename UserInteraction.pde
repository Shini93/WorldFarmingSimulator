void mouseClicked() {
  if (sc_findField() == true)
    return;
  if (sc_findBuilding() == true)
    return;
  if (sc_findBuildingToBuild()== true)
    return;
}

Boolean sc_findBuildingToBuild() {
  if (view.selView != 4)
    return false;
  if (mouseX < 180 || mouseX > 600)
    return false;
  for (int i = 0; i < sc_activeBuildMgr().buldNames.length; i++) {
    if (mouseY > (60 + (i) * 30) && mouseY < ( 60 + (i+1) * 30)) {
      Building build = sc_activeBuildMgr().getBuildingClass((sc_activeBuildMgr().buldNames[i]));
      a_player[activePlayer].doerfer.get(a_player[activePlayer].activeVillage).activeBuilding = build;
      view.selView = 5;
      return true;
    }
  }
  return false;
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
    view.selView = 4;
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

void addBuilding(){
  sc_activeBuildMgr().addBuilding(sc_activeVillage().activeBuilding.S_name);
  view.selView = view.buildings;
}

void updateRessource() {
  if (sc_activeRessource().toLvl == true)
    return;
  if (sc_activeRessource().lvlUpRess() == false)
    return;
  sc_activeVillage().activateTimer(sc_activeRessource());
  view.selView = 0;
}

void updateBuilding() {
  if (sc_activeBuilding().toLvl == true)
    return;
  if (sc_activeBuilding().lvlUpBuilding() == false)
    return;
  sc_activeVillage().activateTimer(sc_activeBuilding(), true);
  view.selView = 2;
}
