
//Classes
public class Button {
  String id;
  int x, y, w, h;
  //mouse pointer tracking
  int mX, mY;
  //graphics data
  color currentColor = color(20);
  
  Button(String i, int x, int y, int w, int h) {
    this.id = i;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.mX = mouseX;
    this.mY = mouseY; 
  }
  
  void drawButton() {
    stroke(255);
    fill(currentColor);
    rect(this.x, this.y, this.w, this.h);
  }
  
  boolean overButton()  {
    if (mouseX >= this.x && mouseX <= this.x + this.w && 
        mouseY >= this.y && mouseY <= this.y + this.h) {
      return true;
    } else {
      return false;
    }
  }
  
//  boolean testAnswer(String ans) {
//    if(this.id == ans) {
//      return true;
//    } else {
//      return false;
//    }
//  }
}
