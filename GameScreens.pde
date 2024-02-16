class GameScreens {
  int GAMEWAIT=0, GAMERUNNING=1, GAMEOVER=2, GAMEWON=3, GAMERESTART=4, GAMEHELP=5;
  int gameState;
  float time;
  PImage startScreenLogo;
  PImage helpScreen;
  color greenBg = #d4dfb7;
  
  boolean scoreSaved = false;

  JSONObject json;

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
    loadData();
    if (keyPressed) {
      if ( key == ENTER || key == RETURN ) {
        gameState = GAMERUNNING;
      } else if (key == ' ') {
        gameState = GAMEHELP;
      }
    }
  }

  int returnGameState() {
    return gameState;
  }

  void gameRunningScreen() {
    player.updatePlayer();
    time+=1/frameRate;
    drawMap();

    for ( Crops crop : cropList ) {
      crop.registerObserver(observerSubject);
      crop.draw();
    }
    // display player
    player.drawPlayer();
    // display menu
    ui.draw();

    if ( keyPressed && (key == 'p' || key == 'P')) {
      gameState = GAMEHELP;
    }

    if ( player.actionCount >= 50 ) {
      // update for whether enough points are accumulated. Also I should probably clean this and use the notify
      if ((player.pointsAdded*2) <= 200) {
        gameState = GAMEOVER;
      } else {
        gameState = GAMEWON;
      }
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


  void drawMap() {
    // The left border of the screen is at screenLeftX in map coordinates
    // so we draw the left border of the map at -screenLeftX in screen coordinates
    // Same for screenTopY.
    map.draw( -screenLeftX, -screenTopY );
  }

  void gameOverScreen() {
    if (!scoreSaved) {
      saveData();
      scoreSaved = true;
    }
    background(greenBg);
    gameState = GAMEOVER;
    pixelFont.draw("Leider hat Bob gewonnen...", 50, 77+16);
    pixelFont.draw("Punkte:" + totalPoints(), 50, height/2-40);
    pixelFont.draw("zum Neustarten ", 50, height/2);
    pixelFont.draw("ENTER eingeben", 50, (height/2)+16);

    if (keyPressed && (key == ENTER || key == RETURN ) ) {
      gameState = GAMERESTART;
    }
  }

  void gameWonScreen() {
    if (!scoreSaved) {
      saveData();
      scoreSaved = true;
    }

    background(greenBg);
    gameState = GAMEWON;
    pixelFont.draw("Take that Bob!", 50, 77+16);
    pixelFont.draw("Punkte:" + totalPoints(), 50, height/2-40);
    pixelFont.draw("zum Neustarten ", 50, height/2);
    pixelFont.draw("ENTER eingeben", 50, (height/2)+16);

    if (keyPressed && (key == ENTER || key == RETURN ) ) {
      gameState = GAMERESTART;
    }
  }

  String totalPoints() {
    String pointsTotal = str(player.pointsAdded*2);
    return pointsTotal;
  }

  void saveData() {
    if (!json.hasKey("High Score")) {
      json.setJSONArray("High Score", new JSONArray());
    }

    JSONObject highScore = new JSONObject();
    highScore.setInt("Punkte", player.pointsAdded*2);

    JSONArray highScoreData = json.getJSONArray("High Score");
    highScoreData.append(highScore);

    saveJSONObject(json, "data/data.json");
    loadData();
    loadData();
  }

  void loadData() {
    json = loadJSONObject("data/data.json");

    if (json != null && json.hasKey("High Score")) {
      JSONArray highScoreData = json.getJSONArray("High Score");

      if (highScoreData.size()> 0) {
        int highestScore = Integer.MIN_VALUE;

        // grab highest score saved
        for (int i = 0; i < highScoreData.size(); i++) {
          JSONObject highScore = highScoreData.getJSONObject(i);
          int scoreValue = highScore.getInt("Punkte");
          highestScore = Math.max(highestScore, scoreValue);
        }

        // if score found:
        String scoreStr = str(highestScore);
        pixelFont.draw("High Score:" + scoreStr, 50, height/2+48);
      }
    }
  }

  void resetState() {
    cropList.clear();
    scoreSaved = false;
    newGame();
    gameState = GAMEWAIT;
  }

  void helpScreen() {
    gameState = GAMEHELP;
    background(greenBg);
    image(helpScreen, 0, 0);
    pixelFont.draw("Bisher hatte Bob jedes Jahr die beste", 156, 92);
    pixelFont.draw("Ernte. Doch dieses Jahr... komme ich!", 156, 92+20);
    pixelFont.draw("Anleitung:", 40, 200);
    pixelFont.draw("Du hast 50 Tage (Aktionen) Zeit", 214, 200);
    pixelFont.draw("WASD zum Bewegen", 40, 268);
    pixelFont.draw("Wasser: Q", 462, 268);
    pixelFont.draw("H", 508, 308);
    pixelFont.draw("Ernte:   X", 462, 312+20);
    pixelFont.draw("Q", 508+24, 308);
    pixelFont.draw("Auswahl mit Pfeiltasten", 40, 312);
    pixelFont.draw("X zum pflanzen", 40, 312+20);
    pixelFont.draw("13   25  8   5   25   6", 40, 378);
    pixelFont.draw("0", 554, 378);
    pixelFont.draw("Enter zum Fortfahren", 40, height-42);
    if (keyPressed && (key == ENTER || key == RETURN )) {
      gameState = GAMERUNNING;
    }
  }
}
