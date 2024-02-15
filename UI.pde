class UI implements Observer {
  PImage menubar;

  PImage seedCarrot;
  PImage seedPumpkin;
  PImage seedTomato;
  int fontSize = 16;
  color textColour = #272736;
  float seedPosX = 72;
  float seedPosY = 182;
  


  void setup() {
    menubar = loadImage("images/menu.png");
    seedCarrot = loadImage("images/carrot.png");
    seedPumpkin = loadImage("images/adult.png");
    seedTomato = loadImage("images/tomato.png");
  }

  void draw() {
    textAlign(RIGHT);
    fill(textColour);
    textSize(fontSize);
    image(menubar, 0, 0);
    //actionStepDisplay();
    pointsDisplay();
    updateActionCount( interactionHandler, player.actionCount);
    toolsDisplay();
    movementsDisplay();
    noFill();
    updateCropSelection(interactionHandler, player.CROPSELECTION);
  }


  void pointsDisplay() {
    // harvest points
    pixelFont.draw("100", 45, 77);
  }

  void toolsDisplay() {
    // key instruction for plant seeds
    pixelFont.draw("X", width-90, 164);
    pixelFont.draw("H", width-90, 234);
    pixelFont.draw("Q", width-90, 304);
  }

  void movementsDisplay() {
    pixelFont.draw("W", 45, height-60);
    pixelFont.draw("S", 45, height-40);
    pixelFont.draw("A", 30, height-40);
    pixelFont.draw("D", 60, height-40);
  }

  void update(Object data) {
    //println(data + "working");

    // so basically keep intersections in here
  }

  void updateCropSelection(Observer observer, int cropSelection) {
    imageMode(CENTER);
    switch(cropSelection) {
    case 0:
      // TODO: change to pumpkin once exists
      image(seedPumpkin, width-seedPosX, seedPosY, seedPumpkin.width/2, seedPumpkin.height/2);
      break;
    case 1:
      image(seedTomato, width-seedPosX, seedPosY, seedTomato.width/2, seedTomato.height/2);
      break;
    case 2:
      image(seedCarrot, width-seedPosX, seedPosY, seedCarrot.width/2, seedCarrot.height/2);
      break;
    }
    imageMode(CORNER);
  }

  // step counter
  void updateActionCount(Observer observer, int actionCount) {
    String actionCountStr = str(actionCount);
    // TODO: fix value, right now it's 50 steps max
    pixelFont.draw(actionCountStr + "/50", 30, 30);
  }

  void updateGrowthStatus(Observer observer, int growthStatus) {
    println(growthStatus + "growthStatus Count");
  }
}
