Byte actualView = 0;    //Fields, Field, Village, Building, Map, Troops,
PShape hexagon;

void updatepg_overlay() {
  pg_overlay.beginDraw();
  pg_overlay.clear();
  pg_overlay.textSize(titleTextSize);
  pg_overlay.text(sc_activeVillage().name, 0.5 * (width - textWidth(sc_activeVillage().name)), 30);
  pg_overlay.textSize(normalTextSize);
  pg_overlay.noStroke();
  drawLager();
  drawProd();
  drawDetails();
  drawVillageList();

  int t = 0;
  int offsetY = 30;
  for (int i = 0; i < sc_activeVillage().timer.length; i++) {
    if (sc_activeVillage().timer[i].timeInSec>0) {
      sc_activeVillage().timer[i].drawTimer(width-230, 250 + t*30 + offsetY + 5, 210, 5);
      t++;
    }
  }

  view.drawView();

  btn_back.DrawButton();
  btn_switchPlayer.DrawButton();
  if(view.selView == 0)
    btn_toggleMap.DrawButton();
  if (actualView != 1 && actualView != 3)
    btn_toggleVillRess.DrawButton();
  pg_overlay.endDraw();
  image(pg_overlay, 0, 0);
  updateButtons();
}

void drawVillageList(){
  a_player[activePlayer].list.drawList(); 
}

void drawDetails() {
  int offsetY = 30;
  int offsetX = 10;
  pg_overlay.textSize(normalTextSize);
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
  pg_overlay.textSize(normalTextSize);
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
  pg_overlay.textSize(normalTextSize);
  pg_overlay.fill(255);
  pg_overlay.rect(width-230, 0 + offsetY, 210, 90);
  pg_overlay.fill(0);
  pg_overlay.text( sc_activeRessMgr().a_RohstoffPerHour[Holz], width-90, 20 + offsetY);
  pg_overlay.text( sc_activeRessMgr().a_RohstoffPerHour[Lehm], width-90, 40 + offsetY);
  pg_overlay.text( sc_activeRessMgr().a_RohstoffPerHour[Eisen], width-90, 60 + offsetY);
  pg_overlay.text( sc_activeRessMgr().a_RohstoffPerHour[Korn], width-90, 80 + offsetY);

  pg_overlay.fill(255, 125);
  pg_overlay.fill(0);
  pg_overlay.text("Holz/h : ", width-230, 20 + offsetY);
  pg_overlay.text("Lehm/h : ", width-230, 40 + offsetY);
  pg_overlay.text("Eisen/h : ", width-230, 60 + offsetY);
  pg_overlay.text("Getreide/h : ", width-230, 80 + offsetY);

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

PShape createHexagon(PVector pos, int r) {
  PShape hex = createShape();
  hex.beginShape();
  for (int i = 0; i < 6; i++) {
    float angle = 2*PI * (float(i) / 6);
    hex.vertex(pos.x + r * cos(angle), pos.y + r * sin(angle));
  }
  hex.vertex(pos.x + r, pos.y);
  hex.endShape();
  hexagon = hex;
  return hex;
}

void hexagon(PVector pos, int r, color bg) {
  PShape hex = createHexagon(pos, r);
  hex.setFill(bg);
  pg_overlay.shape(hex, 1, 1);
}

void hexagon(PVector pos, int r) {
  PShape hex = createHexagon(pos, r);
  pg_overlay.shape(hex, 1, 1);
}

PVector getHexPos(int count, int hexSize) {
  PVector pos = new PVector();
  int[] rings = {1, 7, 19, 37, 61};
  int ring = 0;
  PVector offset = new PVector(600, 300);

  //Checks ring it is in
  while ( count >= rings[ring] ) {
    ring++;
  }

  int r = int(ring * hexSize * 2);    //radius to the layer
  if ( ring > 0) {
    for (int i = 1; i < ring + 1; i ++) {
      if (count % ring  == i)
        r -= 30;
    }
  }
  int outerLayer = ring * 6;
  float angle = 0;
  if (outerLayer > 0)
    angle = (float( count - outerLayer) / float(outerLayer)) * 2 * PI + (PI/6);
  else
    angle = 0;
  pos = new PVector(offset.x + r * cos(angle), offset.y + r * sin(angle));
  //PVector pos =  new PVector( 150 + 100 * ( k + 1 ), ressSize + 100 * ( nr + 1) - ressSize * dy);
  return pos;
}

Boolean hexClicked(PVector pos, int hexSize) {
  if (mouseX < pos.x - hexSize || mouseX > pos.x + hexSize)
    return false;
  if (mouseY < pos.y - hexSize || mouseY > pos.y + hexSize)
    return false;
  return true;
}
