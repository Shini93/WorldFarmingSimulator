class Spieler{
  String Name = "";
  int PlayerID = 0;
  int activeVillage = 0;
  int CulturPointsGlobal = 0;
  int fallenTroops = 0;
  ArrayList <Dorf> doerfer = new ArrayList <Dorf>();
  Spieler(String _Name, int _PlayerID){
    Name = _Name;
    PlayerID = _PlayerID;
    doerfer.add(new Dorf(PlayerID,0,4,4,4,6));
  }
  
  void updatePlayer(){
   for(int d = 0; d < doerfer.size(); d++)
     doerfer.get(d).updateVillage();
  }
}
