Map map;

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

float time;
int GAMEWAIT=0, GAMERUNNING=1, GAMEOVER=2, GAMEWON=3;
int gameState;

PImage backgroundImg;
PFont font;
// https://ngndang.itch.io/fat-pix-font

Map.TileReference soil;


InteractionHandler interactionHandler = new InteractionHandler();
ObserverSubject observerSubject = new ObserverSubject();

void setup() {
  size( 640, 480 );
  font = createFont("FatPix-SVG.otf", 16);
  pixelFont = new Font();
  textFont(font);
  frameRate(30);
  backgroundImg = loadImage ("images/fire.jpg");
  ui = new UI();
  ui.setup();

  observerSubject.addObserver(interactionHandler);
  newGame ();
}

void newGame () {
  map = new Map( "demo.map");
  player = new Player();
  for ( int x = 0; x < map.w; ++x ) {
    for ( int y = 0; y < map.h; ++y ) {
      // put player at 'S' tile and replace with 'F'
      if ( map.at(x, y) == 'S' ) {
        player.playerX = map.centerXOfTile (x);
        player.playerY = map.centerYOfTile (y);
        map.set(x, y, 'F');
      }
      // put goal at 'E' tile
      if ( map.at(x, y) == 'E' ) {
        goalX = map.centerXOfTile (x);
        goalY = map.centerYOfTile (y);
      }
    }
  }
  time=0;

  player.setPlayerPos(50, 50);

  gameState = GAMEWAIT;
}


float map (float x, float xRef, float yRef, float factor) {
  return factor*(x-xRef)+yRef;
}

void drawBackground() {
  // Explanation to the computation of x and y:
  // If screenLeftX increases by 1, i.e. the main level moves 1 to the left on screen,
  // we want the background map to move 0.5 to the left, i.e. x decrease by 0.5
  // Further, imagine the center of the screen (width/2) corresponds to the center of the level
  // (map.widthPixel), i.e. screenLeftX=map.widthPixel()/2-width/2. Then we want
  // the center of the background image (backgroundImg.width/2) also correspond to the screen
  // center (width/2), i.e. x=-backgroundImg.width/2+width/2.
  float x = map (screenLeftX, map.widthPixel()/2-width/2, -backgroundImg.width/2+width/2, -0.5);
  float y = map (screenTopY, map.heightPixel()/2-height/2, -backgroundImg.height/2+height/2, -0.5);
  //image (backgroundImg, x, y);
  background(255);
}


void drawMap() {
  // The left border of the screen is at screenLeftX in map coordinates
  // so we draw the left border of the map at -screenLeftX in screen coordinates
  // Same for screenTopY.
  map.draw( -screenLeftX, -screenTopY );
}


void drawText() {
  textAlign(CENTER, CENTER);
  fill(0, 255, 0);
  textSize(40);
  if (gameState==GAMEWAIT) text ("press space to start", width/2, height/2);
  else if (gameState==GAMEOVER) text ("game over", width/2, height/2);
  else if (gameState==GAMEWON) text ("won in "+ round(time) + " seconds", width/2, height/2);
}

void update() {
}

void draw() {
  if (gameState==GAMERUNNING) {
    player.updatePlayer();
    time+=1/frameRate;
  } else if (keyPressed && key==' ') {
    if (gameState==GAMEWAIT) gameState=GAMERUNNING;
    else if (gameState==GAMEOVER || gameState==GAMEWON) newGame();
  }
  //screenLeftX = player.playerX - width/2;
  //screenTopY  = (map.heightPixel() - height)/2;

  drawBackground();
  drawMap();

  drawText();

  for ( Crops crop : cropList ) {
    crop.registerObserver(observerSubject);
    crop.draw();
  }
  player.drawPlayer();
  ui.draw();
}

void keyPressed() {
  player.keyPressed();
}
