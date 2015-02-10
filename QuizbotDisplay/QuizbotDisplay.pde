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

color textColor = color(0);
color backColor = color(255);
color buttonColor = color(230, 230, 230);
color hoverColor = color(41, 171, 226);
color correctColor = color(122, 201, 67);
color incorrectColor = color(128, 128, 128);

void setup() {

  //Setup communication port with Arduino
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);

  //setup display
  size(displayWidth, displayHeight);

  //setup fonts
  qFont = createFont("HelveticaNeue", qFontSize);
  aFont = createFont("HelveticaNeue", aFontSize);

  //Import the list of questions
  list = loadTable("Quiz.txt", "csv");

  outOfTotal = list.getRowCount();
  println(outOfTotal);


  //Create all the buttons
  buttonNav = new Button("Next");
  for (int i = 0; i < 4; i++) {
    button[i] = new Button(list.getString(0, i + 2));
    //set button colors to default
    button[i].setActiveColor(buttonColor);
    button[i].setHoverColor(hoverColor);
  }
}

boolean sketchFullScreen() {
  return true;
}

void draw() {
  clear();
  background(backColor);
  fill(textColor);

  if (firstPage && !lastPage) {
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
  if (!firstPage && !lastPage) {
    //Question Page Answer Buttons
    //update button background based on mouseover
    for (int i = 0; i < 4; i++) {
      button[i].update();
      button[i].drawButton();
    }
  } else {
    //First Page and Last Page Navigation buttons
    //update button background based on mouseover
    buttonNav.update();
    buttonNav.drawButton();
  }
}

//Iterate through all the buttons on mouse-click
//Send Result to Arduino
void mousePressed() {
  if (!firstPage && !lastPage) {
    for (int i = 0; i < 4; i++) {

      //Check if mouse pointer is over button
      if (button[i].overButton()) {
        //Compare button value with stored answer
        //Send 'y' if match, 'n' if no match
        if (button[i].id.equals(list.getString(currentQuestion, 6).toLowerCase())) {
          //set button color for correct answer
          button[i].activeColor = correctColor;
          myPort.write('y');
          correctAnswers++;
        } else {
          //set button color for incorrect answer
          button[i].activeColor = incorrectColor;
          myPort.write('n');
        }
      }
    }
  } else {
    //Check if mouse pointer is over button
    if (firstPage && !lastPage && buttonNav.overButton()) {
      //set first page to false
      firstPage = !firstPage;
    } else if (!firstPage && lastPage && buttonNav.overButton()) {
      exit();
    }
  }
}

//Receiving data from arduino
void serialEvent(Serial p) {
  String val = p.readString();
  println(val);
  if (val.equals("d")) {
    if (currentQuestion < outOfTotal - 1) {
      //there are more questions to display
      //Advance question counter
      currentQuestion++;
      for (int i = 0; i < 4; i++) {
        //set button colors to default
        button[i].setActiveColor(buttonColor);
        button[i].setHoverColor(hoverColor);
      }
    } else if (currentQuestion == outOfTotal - 1) {
      //There are no more questions to display
      //show last page
      lastPage = !lastPage;
    }
  }
}

/** --------------------------- Display -------------------------- **/
//display introduction
void introPage() {
  buttonNav.setDimensions(4 * width/5, height/2 + 40, 100, 30);
  buttonNav.setActiveColor(buttonColor);
  buttonNav.setHoverColor(hoverColor);
  buttonNav.setText("NEXT", aFont, aFontSize);
  buttonNav.drawButton();

  textAlign(CENTER, BASELINE);
  textFont(qFont, qFontSize);
  text("Welcome to quizbot", width/2, height/10);
  textFont(aFont, aFontSize);
  text("I will ask you " + (outOfTotal - 1) + " question(s), answer as many correctly as you can", width/2, height/2);

  //track mouse position
  update();
}

//display questions
void questionsPage() {


  //Draw Buttons
  for (int i = 0; i < 4; i++) {
    button[i].setDimensions(width/2 + 15, height/10 + 175 + (i * 40), width/2 - 100, 30);
    //set button text as answer value
    button[i].setText(list.getString(currentQuestion, i + 2), aFont, aFontSize);
    button[i].drawButton();
  }

  //Display Image
  //calculate image dimensions
  int vc = displayHeight/2; // column line
  int hc = displayWidth/2; // center horizontal line
  int p = 100; // padding
  float w_a, i_r, h_a, p_t;
  show = loadImage(list.getString(currentQuestion, 0));
  w_a = hc - 2 * p;  // target image width with padding on both left and right sides
  i_r = w_a / show.width; // scale factor for orignal to target image
  h_a = show.height * i_r; // target image height
  p_t = vc - .5 * h_a; // top padding
  image(show, p, p_t, w_a, h_a);

  //Display question
  showQuestion();

  //track mouse position
  update();
}

void showQuestion() {
  textAlign(CENTER, BASELINE);
  textFont(qFont, qFontSize);
  text(list.getString(currentQuestion, 1), width/2 + 20, height/10, width/2 - 100, 200);
}

//display results
void resultsPage() {
  buttonNav.setDimensions(4 * width/5, height/2 + 40, 100, 30);
  buttonNav.setActiveColor(buttonColor);
  buttonNav.setHoverColor(hoverColor);
  buttonNav.setText("NEXT", aFont, aFontSize);
  buttonNav.drawButton();

  textAlign(CENTER, BASELINE);

  textFont(qFont, qFontSize);
  text("Results", width/2, height/10);
  textFont(aFont, aFontSize);
  text("Score: " + correctAnswers + " out of " + (outOfTotal - 1) + " Questions.", width/2, height/2);

  //track mouse position
  update();
}
