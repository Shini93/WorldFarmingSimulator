
int sizeFont = 20;
class Button{
   int deltaT =0;
   color c = 000000;
   color bgc = #FFFFFF;
   String text = "Button"; 
   int x = 0;
   int y = sizeFont;
   int boxSizeX = 300;
   int boxSizeY = 30;
   int opacity = 255;
   boolean visible = true;
   void initButton(){
     DrawButton();
   }
   Button(int x1, int y1, String text1){
     x=x1;
     y=y1+sizeFont;
     text = text1;
     initButton();
   }
   Button(int x1, int y1, int x2, int y2, String text1){
     x=x1;
     y=y1+sizeFont;
     boxSizeX = x2;
     boxSizeY = y2;
     text = text1;
     initButton();
   }
   Button(int x1, int y1, int x2, int y2, String text1, int opacityy){
     x=x1;
     opacity = opacityy;
     y=y1+sizeFont;
     boxSizeX = x2;
     boxSizeY = y2;
     text = text1;
     initButton();
   }
   Button(int x1, int y1, String text1, color c1, color bg){
     x=x1;
     y=y1+sizeFont;
     text = text1;
     c = c1;
     bgc = bg;
     initButton();
   }
   Button(int x1, int y1, String text1, color c1, color bg, int size){
     x=x1;
     y=y1+sizeFont;
     text = text1;
     c = c1;
     bgc = bg;
     sizeFont = size;
     initButton();
   }
   void DrawButton(){
     if(visible == false)
       return;
     pg_overlay.noStroke();
     pg_overlay.fill(bgc, opacity);
     pg_overlay.rect(x,y-boxSizeY+3,boxSizeX,boxSizeY+6);
     pg_overlay.fill(c, opacity);
     float tw = pg_overlay.textWidth(text);
     float lw = boxSizeX - tw;
     
     
     pg_overlay.text(text,x + 0.5*lw,y-boxSizeY+25);
   }
   Boolean isFired(){
     if(mousePressed  == false)
       return false;
     if(mouseX<x) 
       return false;
     if(mouseX > x+boxSizeX)
       return false;
     if(mouseY < y-boxSizeY+3)
       return false;
     if(mouseY > y+ 6)
       return false;
     if(deltaT>0)
       if(millis()-deltaT < 200)
         return false;
     deltaT = millis();
    return true;  
   } 
}
