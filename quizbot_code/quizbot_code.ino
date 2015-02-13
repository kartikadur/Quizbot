#include <Servo.h>
#include "behaviors.h"


void setup() {
  Serial.begin(9600);  
  crazy_dance();
}



char val;

//----MAIN STARTS HERE ----
void loop(){

  //check if question was answered
  if(Serial.available()) {
    val = Serial.read();
    if( val == 'y') {
      yes();
    } else if( val == 'n') {
      no();
    } else if( val == 'z') {
      crazy_dance();
    } else {
      //Do Nothing
    }
    //Nod or Turn action completed
    //send communication to update question 
    Serial.println("d");
  }
  
}

