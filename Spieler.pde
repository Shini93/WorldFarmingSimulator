class Spieler{
  String Name = "";
  int PlayerID = 0;
  int activeVillage = 0;
  int CulturPointsGlobal = 0;
  int fallenTroops = 0;
  ArrayList <Dorf> doerfer = new ArrayList <Dorf>();
  scrollList list = new scrollList(width - 150,300,100,200, 1,6);
  Spieler(String _Name, int _PlayerID){
    Name = _Name;
    PlayerID = _PlayerID;
    doerfer.add(new Dorf(PlayerID,0,4,4,4,6));
    doerfer.get(0).coord = new PVector(int(map.size.x * noise(PlayerID * 23.5)), int(map.size.y * noise(PlayerID * 3.3)));
    //doerfer.add(new Dorf(PlayerID,1,3,3,3,9));
    list.addField(doerfer.get(0).name);
    //list.addField(doerfer.get(1).name);
    list.nextRow();
  }
  
  void updatePlayer(){
   for(int d = 0; d < doerfer.size(); d++)
     doerfer.get(d).updateVillage();
  }
}
