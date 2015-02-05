
//Classes
public class Button {
  String id;
  //Button Text
  String text;
  PFont font;
  int size;
  //Button placement and dimensions
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
  
  void setText(String t, PFont font, int size) {
    this.text = t;
    this.font = font;
    this.size = size;
  } 
  
  void drawButton() {
    textAlign(LEFT, BASELINE);
    stroke(255);
    fill(currentColor);
    rect(this.x, this.y, this.w, this.h);
    fill(255);
    textFont(font, size);
    text(text, this.x + 10, this.y + size);
  }
  
  boolean overButton()  {
    if (mouseX >= this.x && mouseX <= this.x + this.w && 
        mouseY >= this.y && mouseY <= this.y + this.h) {
      return true;
    } else {
      return false;
    }
  }
}
