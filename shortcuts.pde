Boolean sc_findField(){
  return a_player[activePlayer].doerfer.get(a_player[activePlayer].activeVillage).c_RessourceManager.findField(); 
}

RessourceManager sc_activeRessMgr(){
  return a_player[activePlayer].doerfer.get(a_player[activePlayer].activeVillage).c_RessourceManager;
}

Rohstoffeld sc_activeRessource(){
  return a_player[activePlayer].doerfer.get(a_player[activePlayer].activeVillage).activeRessource;
}

Dorf sc_activeVillage(){
   return  a_player[activePlayer].doerfer.get(a_player[activePlayer].activeVillage);
}

BuildingManager sc_activeBuildMgr(){
  return a_player[activePlayer].doerfer.get(a_player[activePlayer].activeVillage).c_BuildingManager; 
}

Boolean sc_findBuilding(){
  return a_player[activePlayer].doerfer.get(a_player[activePlayer].activeVillage).c_BuildingManager.openBuilding(); 
}

Building sc_activeBuilding(){
  return a_player[activePlayer].doerfer.get(a_player[activePlayer].activeVillage).activeBuilding;
}

Storage sc_activeStorage(){
  return sc_activeRessMgr().storage;
}
