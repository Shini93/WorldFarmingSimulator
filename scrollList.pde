class scrollList { //<>//
  PVector size;
  PVector pos;
  int hFieldX, hFieldY;      //size of each field
  int count = 0;
  int maxX, maxY;
  ArrayList <ArrayList <String>> fields = new ArrayList <ArrayList <String>>();
  ArrayList <String> dummyListRow  = new ArrayList <String>();
  color bg = #CCCCCC;
  color border = #000000;
  private float percY = 0;
  private float percX = 0;
  int strokeW = 0;
  color strokeC = 0;
  PGraphics g;      //can draw on any given PGraphics object

  Slider sliderV;
  Slider sliderH;

  scrollList(int px, int py, int sx, int sy, int nrX, int nrY) {
    g = createGraphics(width,height);      
    g = getGraphics();                  //gets standard draw object
    maxX = nrX;
    maxY = nrY;
    size = new PVector(sx, sy);
    pos = new PVector(px, py);
    hFieldX = round(float(sx) / float(nrX));
    hFieldY = round(float(sy) / float(nrY));
    setSlider();
  }

  void setGraphicContext(PGraphics g){
    this.g = g;
    sliderV.setGraphicContext(g);
    sliderH.setGraphicContext(g);
  }

  void setFieldSize(int x, int y) {
    hFieldX = round((size.x) / float(x));
    hFieldY = round((size.y) / float(y));
    //setSlider();
  }

  void setSlider() {
    int px = int(pos.x);
    int py = int(pos.y);
    int sy = int(size.y);
    int sx = int(size.x);

    sliderH = new Slider(px, py + sy, sx, 10, 10, false);
    sliderV = new Slider(sx + px, py, sy, 10, 10, true);
  }

  void nextRow() {
    count ++;
    fields.add(dummyListRow);
    dummyListRow  = new ArrayList <String>();
  }

  void update() {
    sliderV.display();
    sliderV.update(10);
    sliderH.display();
    sliderH.update(10);
    percY = sliderV.getPosCalc() - 1;
    percX = sliderH.getPosCalc() - 1;
  }

  void drawList() {
    drawCanvas();
    update();
    drawFields();
  }
  
  void drawCanvas() {
    g.stroke(border);
    g.fill(bg);
    g.rect(pos.x, pos.y, size.x, size.y);
  }

  void drawField(int y, int r, color c) {
    if (checkFieldVisible(r, y) == true) {
      float sy = maxY / (size.y / float(hFieldY)) - 1;
      float sx = maxX / (size.x / float(hFieldX)) - 1;
      int posY = round(size.y * percY * sy) + hFieldY;
      int posX = round(size.x * percX * sx) + hFieldX;
      g.fill(c);
      if (strokeW > 0) {
        g.strokeWeight(strokeW);
        g.stroke(strokeC);
        g.rect(pos.x + (y - 1) * hFieldX + posX, pos.y + ( r - 1 )* hFieldY +  posY, hFieldX, hFieldY);
      }
      g.fill(0);
      int tW = round(textWidth(fields.get(y).get(r)));
      int tH = round(textAscent() );
      int tPosX = round(0.5 * (hFieldX - tW));
      g.text(fields.get(y).get(r), pos.x + (y - 1) * hFieldX + posX + tPosX, pos.y + r * hFieldY +  posY - tH);
    }
  }

  void drawFields() {
    g.fill(0);
    for (int y = 0; y < fields.size(); y ++) {
      for (int r = 0; r < fields.get(y).size(); r++) {
        drawField(y, r, 200);
      }
    }
    g.fill(125);
  }

  void addField(String text) {
    dummyListRow.add(text);
    if (dummyListRow.size() >= maxY)
      nextRow();
  }

  boolean checkFieldVisible(int nr, int r) {
    float sy = maxY / (size.y / float(hFieldY)) - 1;
    float sx = maxX / (size.x / float(hFieldX)) - 1;
    float bottom = (size.y / (hFieldY)) * (1 - sy*percY);
    float right = (size.x / hFieldX) * (1 - sx*percX);
    if (nr + 1 > bottom)    //bottom blend out
      return false;
    if (nr  < bottom - (size.y / (hFieldY)))    //bottom blend out
      return false;

    if (r + 1 > right)    //bottom blend out
      return false;
    if (r  < right - (size.x / hFieldX) )    //bottom blend out
      return false;
    return true;
  }

  int[] itemClicked() {
    int[] id = {-1, -1};
    if (mouseX < pos.x || mouseX > pos.x + size.x)
      return id; //<>//
    if (mouseY < pos.y || mouseY > pos.y + size.y)
      return id;

    int offsetY = hFieldY;
    int offsetX = hFieldX;
    float sy = maxY / (size.y / float(hFieldY)) - 1;
    float sx = maxX / (size.x / float(hFieldX)) - 1;
    int posY = round(size.y * percY * sy + pos.y) + offsetY ;
    int posX = round(size.x * percX * sx + pos.x) + offsetX ;

    for (int y = 0; y < fields.size(); y ++) {
      for (int r = 0; r < fields.get(y).size(); r++) {
        if (checkFieldVisible(r, y) == true) {
          if (mouseY > posY + (r - 1) * hFieldY && mouseY < posY + (r ) * hFieldY) {
            id[0] = r;
            if (id[1] >= fields.size())
              id[0] = -1;
          }
          if (mouseX > posX + (y - 1 ) * hFieldX && mouseX < posX + (y ) * hFieldX) {
            id[1] = y;
            if (id[0] >= fields.get(y).size())
              id[1] = -1;
          }
        }
      }
    }
    return id;
  }
}

boolean lockedGlobal = false;

class Slider {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  float loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked = false;
  float ratio;
  String name = "";
  PVector range = new PVector(0, 1);
  color sColor = #00FF00;
  color bColor = #55AA55;
  color hColor = #00EE00;
  boolean vert = false;
  PGraphics g;
  

  Slider (float xp, float yp, int sw, int sh, int l, boolean vertical) {
    init(xp, yp, sw, sh, l, vertical);
  }

  void setGraphicContext(PGraphics g){
    this.g = g; 
  }

  void setColor(color[] c) {
    sColor = c[0];
    bColor = c[1];
    hColor = c[2];
  }

  void setSliderPos(float perc) {  //in percent
    float range = swidth/2 - sheight/2;
    spos = xpos + 2 * perc * range;
    newspos = spos;
  }

  void init(float xp, float yp, int sw, int sh, int l, boolean vertical) {
    vert = vertical;
    if (vert == true) {
      int widthtoheight = sh - sw;
      ratio = (float)sh / (float)widthtoheight;
      swidth = sh;
      sheight = sw;
      xpos = xp-swidth/2;
      ypos = yp;
      spos = ypos;
      sposMin = ypos;
      sposMax = ypos + sheight - swidth;
    } else {
      int widthtoheight = sw - sh;
      ratio = (float)sw / (float)widthtoheight;
      swidth = sw;
      sheight = sh;
      xpos = xp;
      ypos = yp-sheight/2;
      spos = xpos;
      sposMin = xpos;
      sposMax = xpos + swidth - sheight;
    }
    newspos = spos;
    loose = l;
    g = getGraphics();
  }

  Slider(String name, float xp, float yp, int sw, int sh, int l, boolean vertical) {
    this.name = name;
    init(xp, yp, sw, sh, l, vertical);
  }

  void defRange(float min, float max) {
    range = new PVector(min, max);
  }

  void update(int textWidth) {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over && lockedGlobal == false) {
      locked = true;
      lockedGlobal = true;
    }
    if (!mousePressed) {
      locked = false;
      lockedGlobal = false;
    }
    if (locked) {
      //println(newspos);
      if (vert == true)
        newspos = constrain(mouseY, sposMin, sposMax );
      else
        newspos = constrain(mouseX-sheight/2 - textWidth, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      float nLoose = min(loose, abs(newspos - spos));
      spos = spos + (newspos-spos)/nLoose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    g.noStroke();
    g.fill(bColor);
    g.rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      g.fill(sColor);
    } else {
      g.fill(color(hColor));
    }
    if (vert == true)
      g.rect(xpos, spos, swidth, swidth);
    else
      g.rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }

  float getPosCalc() {
    int round;
    if (vert == true)
      round = round(100 * ((((spos - sheight) - ypos + swidth) * ratio) / swidth));
    else
      //round = round(100 * (((spos ) * ratio) / swidth)+ sheight);
      round = round(100 * (1 -((spos - xpos) / (swidth - sheight))));
    return (0.01 * round) ;
  }

  float getRangedOutput() {
    return map(getPosCalc(), 0, 1, range.x, range.y);
  }
}
