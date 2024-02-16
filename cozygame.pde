Map map;
GameScreens gameScreen;

Player player;
ArrayList<Crops> cropList = new ArrayList<Crops>();

UI ui;
Font pixelFont;

// Will be set by restart
float goalX=0, goalY=0;
// Whether to illustrate special functions of class Map
boolean showSpecialFunctions=false;

// left / top border of the screen in map coordinates
// used for scrolling
float screenLeftX, screenTopY;

PImage backgroundImg;

Map.TileReference soil;

InteractionHandler interactionHandler = new InteractionHandler();
ObserverSubject observerSubject = new ObserverSubject();

void setup() {
  gameScreen = new GameScreens();
  size( 640, 480 );
  pixelFont = new Font();
  frameRate(30);
  backgroundImg = loadImage ("images/fire.jpg");
  ui = new UI();
  ui.setup();

  observerSubject.addObserver(interactionHandler);
  gameScreen.newGame();
}

void update() {
}

void draw() {
  if ( gameScreen.gameState == gameScreen.GAMEWAIT ) {
    gameScreen.startScreen();
  } else if ( gameScreen.gameState == gameScreen.GAMERUNNING ) {
    gameScreen.gameRunningScreen();
  } else if (gameScreen.gameState == gameScreen.GAMEOVER) {
    gameScreen.gameOverScreen();
  } else if (gameScreen.gameState == gameScreen.GAMEWON) {
    gameScreen.gameWonScreen();
  } else if (gameScreen.gameState == gameScreen.GAMERESTART) {
    gameScreen.resetState();
  }
}

void keyPressed() {
  if (gameScreen.gameState == gameScreen.GAMERUNNING) {
    player.keyPressed();
  }
}
