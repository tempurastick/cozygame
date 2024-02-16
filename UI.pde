class UI implements Observer {
  PImage menubar;

  Crops crops;

  // tools
  PImage seedCarrot;
  PImage seedPumpkin;
  PImage seedTomato;
  PImage seedKohl;
  PImage seedChoy;
  PImage seedEggplant;
  PImage watercan;
  PImage seedling;

  int fontSize = 16;
  color textColour = #272736;
  float seedPosX = 65;
  float seedPosY = 189;



  void setup() {
    menubar = loadImage("images/menu.png");
    seedCarrot = loadImage("images/carrot.png");
    seedPumpkin = loadImage("images/adult.png");
    seedTomato = loadImage("images/tomato.png");
    seedKohl = loadImage("images/kohl.png");
    seedChoy = loadImage("images/bokchoy.png");
    seedEggplant = loadImage("images/eggplant.png");
    watercan = loadImage("images/watercan.png");
    seedling = loadImage("images/seeds.png");

    registerObserver(observerSubject);
  }

  void draw() {
    textAlign(RIGHT);
    fill(textColour);
    textSize(fontSize);
    image(menubar, 0, 0);
    updateNotifyPoints(interactionHandler, player.pointsAdded);

    updateActionCount( interactionHandler, player.actionCount);

    movementsDisplay();
    noFill();
    updateCropSelection(interactionHandler, player.CROPSELECTION);
    toolsDisplay();
  }

  void toolsDisplay() {
    pixelFont.draw("P", width-86, 26);
    // key instruction for plant seeds
    pixelFont.draw("X", width-90, 164);
    // watering
    image(watercan, width-90, 234);
    pixelFont.draw("H", width-90, 234);
    // harvesting
    pixelFont.draw("Q", width-90, 304);
  }

  void movementsDisplay() {
    pixelFont.draw("W", 45, height-60);
    pixelFont.draw("S", 45, height-40);
    pixelFont.draw("A", 30, height-40);
    pixelFont.draw("D", 60, height-40);
  }

  void registerObserver( ObserverSubject observerSubject) {
    observerSubject.addObserver(this);
  }

  void update(Object data) {
  }

  void updateCropSelection(Observer observer, int cropSelection) {
    imageMode(CENTER);

    // seed always displayed
    image(seedling, width-seedPosX, seedPosY);
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
    case 3:
      image(seedKohl, width-seedPosX, seedPosY, seedCarrot.width/2, seedCarrot.height/2);
      break;
    case 4:
      image(seedChoy, width-seedPosX, seedPosY, seedCarrot.width/2, seedCarrot.height/2);
      break;
    case 5:
      image(seedEggplant, width-seedPosX, seedPosY, seedCarrot.width/2, seedCarrot.height/2);
      break;
    }
    imageMode(CORNER);
  }

  // step counter
  void updateActionCount(Observer observer, int actionCount) {
    String actionCountStr = str(actionCount);
    pixelFont.draw(actionCountStr + "/50", 30, 30);
  }

  void updateGrowthStatus(Observer observer, int growthStatus) {
  }

  void updateNotifyPoints(Observer observer, int points) {
    points += points;
    String pointsStr = str(points);
    pixelFont.draw(pointsStr, 45, 77);
  }
}
