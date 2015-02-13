#include <Arduino.h>
#include <Servo.h>

// MATT REVISION FEB 10
Servo neck_servo; // lower
Servo head_servo; // upper


/// DEFINE PINS FOR SERVOS
int lower_servo = 9;
int upper_servo = 10;

/// STARTING POSITIONS FOR EACH SERVO
int head_position = 90;
int neck_position = 90;


void head(int start_pos, int end_pos, int ms_delay) {
   int angle = 0;
   int i = 1; // increment size
   head_servo.attach(upper_servo); 
   if (start_pos < end_pos) {
     for ( angle = start_pos; angle <= end_pos; angle += 1) {
       head_servo.write(angle);
       delay(ms_delay);
     }
   } else {
     for ( angle = start_pos; angle >= end_pos; angle -= 1) {
       head_servo.write(angle);
       delay(ms_delay);
     }
   }
   head_position = angle;
   head_servo.detach();
}
void head(int end_pos, int ms_delay) {
   int angle = 0;
   int i = 1; // increment size
   head_servo.attach(upper_servo); 
   if (head_position < end_pos) {
     for ( angle = head_position; angle <= end_pos; angle += 1) {
       head_servo.write(angle);
       delay(ms_delay);
     }
   } else {
     for ( angle = head_position; angle >= end_pos; angle -= 1) {
       head_servo.write(angle);
       delay(ms_delay);
     }
   }
   head_position = angle;
   head_servo.detach();
}

void neck(int start_pos, int end_pos, int ms_delay) {
   int angle = 0;
   int i = 1; // increment size
   neck_servo.attach(lower_servo); 
   if (start_pos < end_pos) {
     for ( angle = start_pos; angle <= end_pos; angle += 1) {
       neck_servo.write(angle);
       delay(ms_delay);
     }
   } else {
     for ( angle = start_pos; angle >= end_pos; angle -= 1) {
       neck_servo.write(angle);
       delay(ms_delay);
     }
   }
   neck_position = angle;
   neck_servo.detach();
}

void neck(int end_pos, int ms_delay) {
   int angle = 0;
   int i = 1; // increment size
   neck_servo.attach(lower_servo); 
   if (neck_position < end_pos) {
     for ( angle = neck_position; angle <= end_pos; angle += 1) {
       neck_servo.write(angle);
       delay(ms_delay);
     }
   } else {
     for ( angle = neck_position; angle >= end_pos; angle -= 1) {
       neck_servo.write(angle);
       delay(ms_delay);
     }
   }
   neck_position = angle;
   neck_servo.detach();
}

