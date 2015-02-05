import processing.serial.*;

//Serial communication
Serial myPort;

//Graphics variables for question and answer
PFont qFont, aFont;
int qFontSize = 32, aFontSize = 24;
Table list;
PImage show;
Button buttonNav;
Button[] button = new Button[4];
//track current question
//keeps track of which row in the csv table is currently being referenced.
int currentQuestion = 1;
int correctAnswers = 0;
int outOfTotal = 0;
boolean firstPage = true;
boolean lastPage = false;


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
  
  outOfTotal = list.getRowCount();
  println(outOfTotal);
}

boolean sketchFullScreen() {
  return true;
}

void draw() {
  clear();
  if(firstPage && !lastPage) {
    //display introduction page
    introPage();  
  } else if (!firstPage && !lastPage) {
    //Show questions page
    questionsPage();
  } else if (!firstPage && lastPage) {
    //show Results page
    resultsPage();
  }
}

/** ------------- Functionality ----------------------- **/
//Update the displayed graphics 
void update() {
  if(!firstPage && !lastPage) {
    //Question Page Answer Buttons
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
  } else {
    //First Page and Last Page Navigation buttons
    //update button background based on mouseover
    if(buttonNav.overButton()) {
      buttonNav.currentColor = color(200);
      buttonNav.drawButton();
    } else {
      buttonNav.currentColor = color(20);
      buttonNav.drawButton();
    }
  }
}

//Iterate through all the buttons on mouse-click
//Send Result to Arduino
void mousePressed() {
  if(!firstPage && !lastPage) {
    for(int i = 0; i < 4; i++) {
      //Check if mouse pointer is over button
      if(button[i].overButton()) {
        //Compare button value with stored answer
        //Send 'y' if match, 'n' if no match
        if(button[i].id.equals(list.getString(currentQuestion, 6).toLowerCase())) {
          myPort.write('y');
          correctAnswers++;
        } else {
          myPort.write('n');
        }      
      } else {
        //do nothing
      }
    }
  } else {
    //Check if mouse pointer is over button
    if(firstPage && !lastPage && buttonNav.overButton()) {
      firstPage = !firstPage;
    } else if(!firstPage && lastPage && buttonNav.overButton()) {
      exit();
    } else {
      //Do Nothing
    }
  }
}

//Receiving data from arduino
void serialEvent(Serial p) {
  String val = p.readString();
  println(val);
  if(val.equals("d")) {
    if(currentQuestion < outOfTotal - 1){
      //there are more questions to display
      //Advance question counter
      currentQuestion++;
    } else if(currentQuestion == outOfTotal - 1){
      //There are no more questions to display
      //show last page
      lastPage = !lastPage;
    } else {
      //Do Nothing
    }
  }
}

/** --------------------------- Display -------------------------- **/
//display introduction
void introPage() {
  buttonNav = new Button("Next", 4 * width/5, height/2 + 40, 100, 30);
  buttonNav.setText("NEXT", aFont, aFontSize);
  
  textAlign(CENTER, BASELINE);
  fill(255);
  textFont(qFont, qFontSize);
  text("Welcome to quizbot", width/2, height/10);
  textFont(aFont, aFontSize);
  text("I will ask you " + outOfTotal + " question(s), answer as many correctly as you can", width/2, height/2);
  
  //track mouse position
  update();
}

//display questions
void questionsPage() {
  
  textAlign(LEFT, BASELINE);
  //Draw Buttons
  for(int i = 0; i < 4; i++) {
    button[i] = new Button(list.getString(0, i + 2), 
                            width/2 + 15,
                            height/10 + 175 + (i * 40),
                            width/2 - 100,
                            30);
    //set button text as answer value
    button[i].setText(list.getString(currentQuestion,i + 2), aFont, aFontSize);
    button[i].drawButton();
  }
  
  //Display Image
  show = loadImage(list.getString(currentQuestion, 0));
  image(show, 100, 100, width/2 - 100, width/2 - 100);
  
  //Display question
  showQuestion();
  
  //track mouse position
  update();

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

//display results
void resultsPage() {
 buttonNav = new Button("Next", 4 * width/5, height/2 + 40, 100, 30);
 buttonNav.setText("NEXT", aFont, aFontSize);
 
 textAlign(CENTER, CENTER);
 fill(255);
 textFont(qFont, qFontSize);
 text("Results", width/2, height/10);
 textFont(aFont, aFontSize);
 text("Score: " + correctAnswers + " out of " + (outOfTotal - 1) + " Questions.", width/2, height/2);
 
 //track mouse position
 update();

}

