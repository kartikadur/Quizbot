#include <Servo.h>

char val;

Servo tilt_servo;  // create servo object to control a servo
Servo turn_servo;
Servo nod_servo;
int pos = 0;    // variable to store the servo position
int pos_2 = 0;
int pos_3 = 0;
int NOD_DELAY = 8;
int TURN_DELAY = 8;
int TILT_DELAY = 50;
int NOD_AMOUNT = 3;
int TURN_AMOUNT = 3;

/// DEFINE PINS FOR SERVOS
int lower_servo = 9;
int upper_servo = 10;

// Quiz Questions here

//char [][]

void setup() {
  Serial.begin(9600);
  //questionAndAnswers();
  turn(1);
  nod(1);
}

void nod(int times){
   int i;
   nod_servo.attach(upper_servo);
   for (i = 0; i < times; i++){
     for (pos = 0; pos <= 50; pos += 1){
       nod_servo.write(pos);
       delay(NOD_DELAY);
     }

     for (pos = 50; pos >= 0; pos -= 1){
       nod_servo.write(pos);
       delay(NOD_DELAY);
     }
   }
   nod_servo.detach();
}

void turn(int times){
   int i;
   turn_servo.attach(lower_servo);
   for (i = 0; i < times; i++){
     for (pos_2 = 90; pos_2 <= 115; pos_2 += 1){
       turn_servo.write(pos_2);
       delay(TURN_DELAY);
     }

     for (pos_2 = 115; pos_2 >= 90; pos_2 -= 1){
       turn_servo.write(pos_2);
       delay(TURN_DELAY);
     }
     for (pos_2 = 90; pos_2 >= 65; pos_2 -= 1){
       turn_servo.write(pos_2);
       delay(TURN_DELAY);
     }
   }
   for (pos_2 = 65; pos_2 <= 90; pos_2 ++){
       turn_servo.write(pos_2);
       delay(TURN_DELAY);
   }
   turn_servo.detach();
}

void tilt(){
   tilt_servo.attach(10);
   delay(5);
   for (pos_3 = 0; pos_3 <= 60; pos_3 += 1){
     tilt_servo.write(pos_3);
     delay(TILT_DELAY);
   }
   delay(5);
   tilt_servo.detach();
}

void untilt(){
   tilt_servo.attach(10);
   delay(5);
   for (pos_3 = 60; pos >= 0; pos_3 -= 1){
     tilt_servo.write(pos_3);
     delay(TILT_DELAY);
   }
   delay(5);
   tilt_servo.detach();
}

//----MAIN STARTS HERE ----
void loop(){


  
  if(Serial.available()) {
    val = Serial.read();
//    Serial.println(val);
    if( val == 'y') {
      nod(NOD_AMOUNT);
    } else if( val == 'n') {
      turn(TURN_AMOUNT);
    } else {
      //Do Nothing
    }    
  }
  
      Serial.println("done");
}

