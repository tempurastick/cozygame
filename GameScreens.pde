class GameScreens {
  int GAMEWAIT=0, GAMERUNNING=1, GAMEOVER=2, GAMEWON=3, GAMERESTART=4, GAMEHELP=5;
  int gameState;
  float time;
  PImage startScreenLogo;
  PImage helpScreen;
  color greenBg = #d4dfb7;

  GameScreens() {
    startScreenLogo = loadImage("images/startscreen.png");
    helpScreen = loadImage("images/helpscreen.png");
  }

  void startScreen() {
    gameState = GAMEWAIT;
    background(greenBg);
    image(startScreenLogo, 50, 50);
    pixelFont.draw("ENTER zum start", 50, height/2);
    pixelFont.draw("SPACE zur Anleitung", 50, height/2+32);
    if (keyPressed) {
      gameState = GAMERUNNING;
    }
  }

  int returnGameState() {
    return gameState;
  }

  void gameRunningScreen() {
    player.updatePlayer();
    time+=1/frameRate;
    drawBackground();
    drawMap();

    for ( Crops crop : cropList ) {
      crop.registerObserver(observerSubject);
      crop.draw();
    }
    player.drawPlayer();
    ui.draw();

    if ( player.actionCount >= 50 ) {
      // update for whether enough points are accumulated. Also I should probably clean this and use the notify
      gameState = GAMEOVER;
    }
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

  void gameOverScreen() {
    // replace later
    background(255);
    gameState = GAMEOVER;
    ui.updateNotifyPoints(interactionHandler, player.pointsAdded);
    pixelFont.draw(totalPoints(), 50, height/2-40);
    pixelFont.draw("zum Neustarten ", 50, height/2);
    pixelFont.draw("ENTER eingeben", 50, (height/2)+16);
    if (keyPressed && (key == ENTER || key == RETURN ) ) {
      gameState = GAMERESTART;
    }
  }

  void gameWonScreen() {
    // replace later
    background(255);
    gameState = GAMEWON;
    ui.updateNotifyPoints(interactionHandler, player.pointsAdded);
    pixelFont.draw(totalPoints(), 50, height/2-40);
    pixelFont.draw("zum Neustarten ", 50, height/2);
    pixelFont.draw("ENTER eingeben", 50, (height/2)+16);
    if (keyPressed && (key == ENTER || key == RETURN ) ) {
      gameState = GAMERESTART;
    }
  }

  String totalPoints() {
    String pointsTotal = str(player.pointsAdded);
    return pointsTotal;
  }

  void resetState() {
    cropList.clear();
    newGame();
    gameState = GAMEWAIT;
  }

  void helpScreen() {
    gameState = GAMEHELP;
    image(helpScreen, 0, 0);
  }
}
