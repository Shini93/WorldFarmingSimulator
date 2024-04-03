Byte actualView = 0;    //Fields, Field, Village, Building, Map, Troops,
void updatepg_overlay() {
  pg_overlay.beginDraw();
  pg_overlay.clear();
  pg_overlay.textSize(35);
  pg_overlay.text(sc_activeVillage().name, 0.5 * (width - textWidth(sc_activeVillage().name)), 30);
  pg_overlay.textSize(20);
  pg_overlay.noStroke();
  drawLager();
  drawProd();
  drawDetails();

  int t = 0;
  int offsetY = 30;
  for (int i = 0; i < sc_activeVillage().timer.length; i++) {
    if (sc_activeVillage().timer[i].timeInSec>0) {
      sc_activeVillage().timer[i].drawTimer(width-200, 250 + t*30 + offsetY + 5, 150, 5);
      t++;
    }
  }

  view.drawView();

  btn_back.DrawButton();
  btn_switchPlayer.DrawButton();
  if (actualView != 1 && actualView != 3)
    btn_toggleVillRess.DrawButton();
  pg_overlay.endDraw();
  image(pg_overlay, 0, 0);
  updateButtons();
}

void drawNewBuilding() {
  pg_overlay.text("Gebäudeauswahl", 300, 60);

  for (int i = 0; i < sc_activeBuildMgr().buldNames.length; i++) {
    pg_overlay.text(sc_activeBuildMgr().buldNames[i] + "  ", 200, 60 + (i+1) * 30);
  }
}

void drawDetails() {
  int offsetY = 30;
  int offsetX = 10;
  pg_overlay.textSize(20);
  pg_overlay.fill(255);
  pg_overlay.rect(offsetX, offsetY, 150, 90);
  pg_overlay.fill(0);
  pg_overlay.text( "Population : "+sc_activeVillage().population, offsetX + 5, offsetY + 20);
  pg_overlay.text( "Kultur : "+a_player[activePlayer].CulturPointsGlobal, offsetX + 5, offsetY + 40);
  pg_overlay.text( "Kultur/day : "+sc_activeRessMgr().a_CulturePointsPerDay, offsetX + 5, offsetY + 60);
}

void drawLager() {
  int offsetY = 30;
  int offsetX = 60;
  pg_overlay.textSize(20);
  pg_overlay.fill(255);
  pg_overlay.rect(width-205 - offsetX, 0 + offsetY, 250, 90);
  pg_overlay.fill(0);
  pg_overlay.text( sc_activeRessMgr().storage.Ress[0], width-100 - offsetX, 20 + offsetY);
  pg_overlay.text( sc_activeRessMgr().storage.Ress[1], width-100 - offsetX, 40 + offsetY);
  pg_overlay.text( sc_activeRessMgr().storage.Ress[2], width-100 - offsetX, 60 + offsetY);
  pg_overlay.text( sc_activeRessMgr().storage.Ress[3], width-100 - offsetX, 80 + offsetY);

  pg_overlay.fill(255, 125);
  pg_overlay.fill(0);
  pg_overlay.text("Holz : ", width-200 - offsetX, 20 + offsetY);
  pg_overlay.text("Lehm : ", width-200 - offsetX, 40 + offsetY);
  pg_overlay.text("Eisen : ", width-200 - offsetX, 60 + offsetY);
  pg_overlay.text("Getreide : ", width-200 - offsetX, 80 + offsetY);

  pg_overlay.text( sc_activeRessMgr().storage.maxCapacity, width - 60, 20 + offsetY);
  pg_overlay.text( sc_activeRessMgr().storage.maxCapacity, width - 60, 40 + offsetY);
  pg_overlay.text( sc_activeRessMgr().storage.maxCapacity, width - 60, 60 + offsetY);
  pg_overlay.text( sc_activeRessMgr().storage.maxKorn, width - 60, 80 + offsetY);

  sc_activeVillage().c_RessourceManager.storage.drawRessBalken();
}

void drawProd() {
  int offsetY = 30 + 150;
  pg_overlay.textSize(20);
  pg_overlay.fill(255);
  pg_overlay.rect(width-205, 0 + offsetY, 200, 90);
  pg_overlay.fill(0);
  pg_overlay.text( sc_activeRessMgr().a_RohstoffPerHour[Holz], width-90, 20 + offsetY);
  pg_overlay.text( sc_activeRessMgr().a_RohstoffPerHour[Lehm], width-90, 40 + offsetY);
  pg_overlay.text( sc_activeRessMgr().a_RohstoffPerHour[Eisen], width-90, 60 + offsetY);
  pg_overlay.text( sc_activeRessMgr().a_RohstoffPerHour[Korn], width-90, 80 + offsetY);

  pg_overlay.fill(255, 125);
  pg_overlay.fill(0);
  pg_overlay.text("Holz/h : ", width-200, 20 + offsetY);
  pg_overlay.text("Lehm/h : ", width-200, 40 + offsetY);
  pg_overlay.text("Eisen/h : ", width-200, 60 + offsetY);
  pg_overlay.text("Getreide/h : ", width-200, 80 + offsetY);

  sc_activeVillage().c_RessourceManager.storage.drawRessBalken();
}

PVector getBuildingPos(int b) {
  PVector pos = new PVector(0.5*width - 50, 100 + b * 40);
  return pos;
}

void drawLadebalken(int x, int y, int w, int h, float actual, float max, boolean rightToLeft) {
  float perc = actual/max;
  pg_overlay.noFill();
  pg_overlay.strokeWeight(1);
  pg_overlay.stroke(0);
  pg_overlay.rect(x, y, w, h);
  if (rightToLeft == true) {
    pg_overlay.fill(255*(1-perc), 255*perc, 0);
    pg_overlay.rect(x, y, round(w*perc), h);
  } else {
    pg_overlay.fill(255*(perc), 255*(1-perc), 0);
    pg_overlay.rect(x, y, round(w*(1-perc)), h);
  }
  pg_overlay.fill(0);
}
