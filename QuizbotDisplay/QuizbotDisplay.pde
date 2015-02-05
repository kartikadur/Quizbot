import processing.serial.*;

//Serial communication
Serial myPort;

//Graphics variables for question and answer
PFont qFont, aFont;
int qFontSize = 32, aFontSize = 24;
Table list;
PImage show;
Button[] button = new Button[4];
//track current question
//keeps track of which row in the csv table is currently being referenced.
int currentQuestion = 1;


void setup() {
  
  //Setup communication port with Arduino
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  
  //setup display
  size(displayWidth, displayHeight);
  background(0);
  
  //setup fonts
  qFont = createFont("HelveticaNeue", qFontSize);
  aFont = createFont("HelveticaNeue", aFontSize);
  
  //Import the list of questions
  list = loadTable("Quiz.txt", "csv");
  //Draw buttons
  for(int i = 0; i < 4; i++) {
    button[i] = new Button(list.getString(0, i + 2), 
                            width/2 + 15,
                            height/10 + 175 + (i * 40),
                            width/2 - 100,
                            30);
    button[i].drawButton();
  }
}

boolean sketchFullScreen() {
  return true;
}

void draw() {
  //track mouse position
  update();
  
  //Display Image
  show = loadImage(list.getString(currentQuestion, 0));
  image(show, 100, 100, width/2 - 100, width/2 - 100);
  
  
  //Display question
  showQuestion();
  
  //Display answers
  showAnswers();  
}

//Update the displayed graphics 
void update() {
  //update button background based on mouseover
  for(int i = 0; i < 4; i++) {
    if(button[i].overButton()) {
      button[i].currentColor = color(200);
      button[i].drawButton();
    } else {
      button[i].currentColor = color(20);
      button[i].drawButton();
    }
  }
}

//Iterate through all the buttons on mouse-click
void mousePressed() {
  for(int i = 0; i < 4; i++) {
    if(button[i].overButton()) {
      //Compare button value with stored answer
      //Send 'y' if match, 'n' if no match
      if(button[i].id.equals(list.getString(currentQuestion, 6))) {
        myPort.write('y');
        //wait for response from arduino
        if(myPort.available() > 0) {
          println("world");
          String val = myPort.readStringUntil('\n');
          //update question counter
          //Currently not working
          if(val.equals("done")) {
            println("hello");
            currentQuestion = currentQuestion + 1;
          }
        }
        
        
      } else {
        myPort.write('n');
      }
      
    } else {
      //do nothing
    }
  }
}

void showAnswers() {
  fill(255);
  textFont(aFont, aFontSize);
  for(int i = 0; i < 4; i++) {
    text(list.getString(currentQuestion,i + 2), width/2 + 20, height/10 + 200 + (i*40));
  }
}

void showQuestion() {
  fill(255);
  textFont(qFont, qFontSize);
  text(list.getString(currentQuestion,1), width/2 + 20, height/10, width/2 - 100, 200);
}

