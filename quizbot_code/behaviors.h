#include "controls.h"
/// FORMAT FOR MOTOR CONTROLS:
// head(postion , delay);
//  The postion is the angle you want
//    the servo to move to.
//   The delay is how much time
//     there is between each step the
//     motor takes to go to the angle.
//     Thus, the larger the delay the 
//      slower the movement...

void no() {
   int s = 7;
   head(90,s);
   neck(110,s);
   neck(80,s);
   neck(110,s);
   neck(90,s);
}

void yes() {
  int s = 4;
  neck(90,s);
  head(90,s);
  for (int i = 0 ; i < 2; i++) { // repeat the following two times
    head(120,s);
    head(70,s);
  }
  head(90,s);
}

void crazy_dance() {
  int s = 4;
  head(120,s);
  neck(40,s);
  head(30,s);
  neck(70,s);
  head(140,s * 2);
  neck(30,s+4);
  head(20,s);
  neck(110,s);
  head(30,s);
  neck(150,s);
  head(20,s);
  neck(40,s);
  head(70,s);
  neck(40,s);
  head(80,s);
  neck(40,s);

}
