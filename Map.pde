final static byte NONE = 0;
final static byte PLAYER = 1;
final static byte NATARS = 2;
final static byte BARBARS = 3;
final static byte OASIS = 4;

class Map{
  PVector size;
  Field[][] fields;
  int seed = 0;
  scrollList list;
  
  Map(){
    size = new PVector(50,50);
    fields = new Field[int(size.x)][];
    fillMap();
    fillList();
  }
  
  Map(int x, int y){
    size = new PVector(x,y);
    fields = new Field[int(size.x)][];
    fillMap();
    fillList();
  }
 
  void drawMap(PVector pos){
    pg_overlay.textSize(normalTextSize);
    list.strokeW = 1;
    //list.drawList();
    list.drawCanvas();
    for(int y = 0; y < size.y; y ++){
      for(int r = 0; r < size.x; r++){
        color c = 0;
        if(fields[y][r].occupiedBy == NONE)
          c = 200;
        else if (fields[y][r].occupiedBy == PLAYER)
          c = #55FF55;
        else if (fields[y][r].occupiedBy == NATARS)
          c = #FFFF55;
        else if (fields[y][r].occupiedBy == BARBARS)
          c = #FF5555;
        else if (fields[y][r].occupiedBy == OASIS)
          c = #5555FF;
          
        list.drawField(y,r,c);
      }
    }
    list.update();
  }
 
  void fillList(){
    list = new scrollList(300,100,500,500,int(size.x),int(size.y));
    list.setFieldSize(5,5);
    
    for(int x = 0; x < size.x; x ++){
      for(int y = 0; y < size.y; y ++){
        list.addField(str(fields[x][y].ressKind)); 
      }
    }
  }
 
  void fillMap(){
    noiseSeed(seed);
    
    for(int x = 0; x < int(size.x); x++){
      fields[x] = new Field[int(size.y)];
      for(int y = 0; y < int(size.y); y++){
        float occ =  noise(y + x * size.y ); 
        Byte oc = 0;
        if(occ < 0.3)
          oc = OASIS;
        else
          oc = NONE;
        int ress = round(50 * noise( y + x * size.y + 0.2));
        if(oc == OASIS)
          ress = round(0.2*ress);
        fields[x][y] = new Field(oc,ress);
      }
    }
  }
}

class Field{
  Byte occupiedBy = 0; //none, Player, Natars, Barbars, Oasis
  Byte Player = 0;
  int Village = 0;
  Byte ressKind = 0;    //what kind of ressis there can be      //1- 50 reserved for resskinds 51- 60 reserved for oasis
  
  Field(){
    occupiedBy = 0;
    Player = 0;
    Village = 0;
    ressKind = 0;
  }
  
  Field(int ress){
    occupiedBy = 0;
    ressKind = byte(ress);
    
  }
  
  Field(int occ, int ress){
    occupiedBy = byte(occ);
    ressKind = byte(ress);
  }
  
  Field(int occ, int Player, int Village, int ress){
    occupiedBy = byte(occ);
    ressKind = byte(ress);
    this.Player = byte(Player);
    this.Village = Village;
  }
}
