class Storage {
  int[] Ress = {500, 500, 500, 500};  //Holz, Lehm, Eisen, Getreide
  int maxCapacity = 800;
  int maxKorn = 800;
  PVector posBalken;
  Storage() {
    posBalken = new PVector(width-50, 5);
  }
  Storage(int x, int y) {
    posBalken = new PVector(x, y);
  }
  void Update() {
    for (int i=0; i<3; i++) {
      if (Ress[i] > maxCapacity)
        Ress[i] = maxCapacity;
    }
    if (Ress[3] > maxKorn)
      Ress[3] = maxKorn;
  }

  boolean canBuild(int[] cost) {
    for (int i = 0; i < Ress.length - 1; i++) {
      if (Ress[i] < cost[i])
        return false;
    }
    return true;
  }

  void substractCost(int[] cost) {
    for (int r = 0; r < Ress.length; r++)
      Ress[r] -= cost[r];
  }

  void drawRessBalken() {
    int offsetY = 30;
    int offsetX = 60;
    int w = round(width-posBalken.x-10);
    for (int i = 0; i < Ress.length - 1; i++) {
      drawLadebalken(int(posBalken.x) - offsetX, int(posBalken.y+i*20 + offsetY),w,15,float(Ress[i]),float(maxCapacity),true);
    }
    drawLadebalken(int(posBalken.x) - offsetX, int(posBalken.y+3*20 + offsetY),w,15,float(Ress[3]),float(maxKorn),true);
  }
}
