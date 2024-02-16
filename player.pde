class Player {
  // Position of player center in level coordinates
  // also starting value
  float playerX = width-120, playerY = 40;

  // animation from lecture
  ArrayList<PImage> loadImages (String filePattern) {
    // Count number of question marks
    String qmString="";
    while (filePattern.indexOf (qmString+"?")>=0) qmString += "?";
    // The largest sequence of question marks is qmString
    ArrayList<PImage> images = new ArrayList<PImage>();
    PImage image;
    int ctr=0;
    do {
      String fname = filePattern.replace(qmString, nf(ctr, qmString.length()));
      InputStream input = createInput(fname);
      if (input==null) break;
      PImage img = loadImage (fname);
      if (img==null) break;
      images.add(img);
      ctr++;
    } while (true);
    return images;
  }

  ArrayList<PImage> playerImgs;
  int playerPhase;
  float xVelocity = 32;  // Fox velocity in x direction in pixels per second
  float yVelocity = 16;  // Fox velocity in y direction in pixels per second
  int animationStepsPerSecond = 8; // How many images per second
  float phaseLength = 1.0 / animationStepsPerSecond; // Time for which one image is shown
  float subPhase = 0; // Timer for currently shown image
  boolean isMoving = false;

  // Velocity of player

  // Speed at which the player moves
  float playerSpeed = 10;

  float playerVX, playerVY;
  float nextX = playerX + playerVX;
  float nextY = playerY + playerVY;

  int actionCount = 0;
  int growthCeck;
  int pointsAdded;

  // The player is a circle and this is its radius
  float playerR = 10;

  // string gets sent to observer. Technically it would be cleaner to implement a real state machine or pattern but it's kind of overkill for the project so this will do.
  String onCrop;

  // debatable whether this should go into Crops or Player but since the player picks a seed (e.g. action) it's in here
  IntList cropSelection;

  int CROPSELECTION;
  int PUMPKIN = 0;
  int TOMATO = 1;
  int CARROT = 2;
  int KOHL = 3;
  int BOKCHOY = 4;
  int EGGPLANT = 5;

  // invoke without adjusted parameters
  Player() {
    playerPhase = 0;
    playerImgs = loadImages("animation/fx-??.png");
    animationStepsPerSecond = 8;
    phaseLength = 1.0 / animationStepsPerSecond;
    subPhase = 0;
    setCropList();
  }

  Player(float tempPlayerX, float tempPlayerY, float tempPlayerVX, float tempPlayerVY, float tempPlayerSpeed, float tempPlayerR) {
    playerX = tempPlayerX;
    playerY = tempPlayerY;
    playerVX = tempPlayerVX;
    playerVY = tempPlayerVY;
    playerSpeed = tempPlayerSpeed;
    playerR = tempPlayerR;
    setCropList();
  }

  void setCropList() {
    // create list of all crops so we can iterate through it
    cropSelection = new IntList();
    cropSelection.append(PUMPKIN);
    cropSelection.append(TOMATO);
    cropSelection.append(CARROT);
    cropSelection.append(KOHL);
    cropSelection.append(BOKCHOY);
    cropSelection.append(EGGPLANT);
  }

  void setPlayerPos(float setVX, float setVY) {
    playerVX = setVX;
    playerVY = setVY;
  }

  // Method to update player animation
  void updateAnimation() {
    if (isMoving) {
      subPhase += 1.0 / frameRate; // Measure time of currently shown image
      if (subPhase > phaseLength) { // If time per image is reached ...
        subPhase = 0; // ... reset timer and

        playerPhase++; // go to next animation phase

        // down animation
        if ( playerPhase == 4 ) {
          playerPhase = 1;
        }

        // left animation
        if ( playerPhase == 9 ) {
          playerPhase = 5;
        }

        // down animation
        if ( playerPhase == 14 ) {
          playerPhase = 10;
        }

        if ( playerPhase == 19 ) {
          playerPhase = 15;
        }

        if (playerPhase >= playerImgs.size()) {
          playerPhase = 0; // Loop back to the start of animation if end is reached
        }
      }
    } else {
      // Player is not moving, set animation phase to stationary frame
      subPhase = 0;
      playerPhase = 0; // Set to the stationary frame
    }
  }

  void updatePlayer() {
    if ( map.testTileInRect( nextX-playerR, nextY-playerR, 2*playerR, 2*playerR, map.emptyField ) ) {
      // tile can be planted on
      onCrop = "onSoil";
    } else if ( map.testTileInRect( nextX-playerR, nextY-playerR, 2*playerR, 2*playerR, map.tilled ) || map.testTileInRect( nextX-playerR, nextY-playerR, 2*playerR, 2*playerR, "H" ) ) {
      // planted tile, either hydrated or not
      onCrop = "onCrop";
    } else {
      onCrop = "notOnCrop";
    }

    // error was that we were extending the observersbj instead of just calling on it here
    updateAnimation();

    playerX = nextX;
    playerY = nextY;
  }

  float getX() {
    return playerX;
  }

  float getY() {
    return playerY;
  }

  void drawPlayer() {
    // draw player
    noStroke();
    fill(#2E2A2A, 122);
    ellipseMode(CENTER);
    imageMode(CENTER);
        ellipse( playerX , playerY+20, 2*playerR+10, playerR );
    image(playerImgs.get(playerPhase), playerX, playerY);
 
    imageMode(CORNER);
  }

  void keyPressed() {
    if ( key == 'w' || key == 'W' ) {
      playerPhase = 11;
      if (nextY <= 0) {
        nextY = 0;
      } else {
        nextY = nextY - playerSpeed;
      }
    } else if ( key == 's' || key == 'S'  ) {
      playerPhase = 1;
      if ( nextY >= height ) {
        nextY = height;
      } else {
        nextY = nextY + playerSpeed;
      }
    } else if ( key == 'a' || key == 'A') {
      playerPhase = 6;
      if ( nextX <= 0 ) {
        nextX = 0;
      } else {
        nextX = nextX - playerSpeed;
      }
    } else if ( key == 'd' || key == 'D' ) {
      playerPhase = 16;
      if ( nextX >= width ) {
        nextX = width;
      } else {
        nextX = nextX + playerSpeed;
      }
    } else {
      // allow actions
      actions();
    }

    //animation
    if ((key == 'w' || key == 'W' || key == 's' || key == 'S' || key == 'a' || key == 'A' || key == 'd' || key == 'D') && !isMoving) {
      isMoving = true;
    }
    // select crop called only when key is pressed
    selectCrop();
    // update movement
    updatePlayer();
  }

  void keyReleased() {
    if ( key == 'w' || key == 'W'  ) {
      nextY = 0;
    } else if ( key == 's' || key == 'S' ) {
      nextY = 0;
    } else if ( key == 'a' || key == 'A'  ) {
      nextX = 0;
    } else if ( key == 'd' || key == 'D' ) {
      nextX = 0;
    }
    if ((key == 'w' || key == 'W' || key == 's' || key == 'S' || key == 'a' || key == 'A' || key == 'd' || key == 'D') && isMoving) {
      isMoving = false;
    }
  }

  void actions() {
    // should only be allowed on seed so probably good idea to store a boolean and use observer to update that
    Map.TileReference soil = map.findTileInRect
      (playerX, playerY, playerR*2, playerR*2, map.emptyField);

    Map.TileReference tilled = map.findTileInRect
      (playerX, playerY, playerR*2, playerR*2, map.tilled);

    Map.TileReference tilledWatered = map.findTileInRect
      (playerX, playerY, playerR*2, playerR*2, map.tilledWatered);

    if (keyPressed) {
      println(key);
      // planting a seed
      if ( (key == 'x' || key == 'X') && soil != null ) {

        //cropList.add(new Crops(map.centerXOfTile(soil.x), map.centerYOfTile(soil.y)));
        // make field tilled
        plantSeed(soil);
        map.set (soil.x, soil.y, 'H');
        actionCount++;
      } else if (( key == 'h' || key == 'H') && tilled != null  ) {
        // find crop, if there is crop do action.
        checkForCrops(tilled);
        map.set (tilled.x, tilled.y, 'M');
        actionCount++;
      } else if ((key == 'q' || key == 'Q')) {
        if ( tilled != null ) {
          checkForCrops(tilled);
        } else if ( tilledWatered != null ) {
          checkForCrops(tilledWatered);
        }
      }

      // trigger each time key is pressed
      soilHydrationReset();
    }

    // lets observer know
    observerSubject.notifyObserversActionCount(actionCount);
  }

  void soilHydrationReset() {
    for (int x = 0; x < map.w; x++) {
      for (int y = 0; y < map.h; y++) {
        // Check if the tile is tilled and watered
        if (map.at(x, y) == map.tilledWatered.charAt(0)) {
          // Check if there is a crop at this location
          for (Crops crop : cropList) {
            if (crop.cropX == map.centerXOfTile(x) && crop.cropY == map.centerYOfTile(y)) {
              println("hydration level:" + crop.hydrationLevel );
              // Check the hydration level of the crop
              if (crop.hydrationLevel < 10) {

                // Reset the tile to just tilled
                map.set(x, y, map.tilled.charAt(0));
                break; // No need to check other crops for this tile
              }
            }
          }
        }
      }
    }
  }



  int selectCrop() {
    if (keyPressed) {
      if (keyCode == RIGHT) {
        if (CROPSELECTION < cropSelection.size()-1 ) {
          CROPSELECTION++;
        } else {
          CROPSELECTION = 0;
        }
      } else if (keyCode == LEFT) {
        if (CROPSELECTION <= 0) {

          CROPSELECTION = cropSelection.size()-1;
        } else {
          CROPSELECTION--;
        }
      }
    }
    //println("crop selected:" + CROPSELECTION + "list total:" + cropSelection.size());

    // at the end we need to notify observer about changed seed for the display
    observerSubject.notifyCropSelection(CROPSELECTION);
    return CROPSELECTION;
  }

  void plantSeed(Map.TileReference soil) {
    switch(CROPSELECTION) {
    case 0:
      // TODO: change to pumpkin once exists
      cropList.add(new Pumpkin(map.centerXOfTile(soil.x), map.centerYOfTile(soil.y)));
      break;
    case 1:
      cropList.add(new Tomato(map.centerXOfTile(soil.x), map.centerYOfTile(soil.y)));
      break;
    case 2:
      cropList.add(new Carrot(map.centerXOfTile(soil.x), map.centerYOfTile(soil.y)));
      break;
    case 3:
      cropList.add(new Kohl(map.centerXOfTile(soil.x), map.centerYOfTile(soil.y)));
      break;
    case 4:
      cropList.add(new Bokchoy(map.centerXOfTile(soil.x), map.centerYOfTile(soil.y)));
      break;
    case 5:
      cropList.add(new Eggplant(map.centerXOfTile(soil.x), map.centerYOfTile(soil.y)));
      break;
    }

    observerSubject.notifyObservers(cropList);
  }


  void checkForCrops(Map.TileReference tile) {
    for (Crops crop : cropList) {
      // Calculate the distance between player and crop
      float dx = playerX - crop.cropX;
      float dy = playerY - crop.cropY;
      float distance = sqrt(dx * dx + dy * dy);
      int growthStatus = crop.checkGrowthStatus();

      // Check if in crop
      if (distance < playerR + crop.cropW/2) {
        switch(growthStatus) {
        case 4:
          // dead
          cropList.remove(crop);
          // reset field
          map.set (tile.x, tile.y, 'D');
          actionCount++;
          println("removed" + tile.x + tile.y );
          break;
        case 3:
          // harvest
          cropList.remove(crop);

          // reset field
          map.set (tile.x, tile.y, 'D');
          println("harvested!" + tile.x + tile.y );
          actionCount++;
          // add to player point count
          pointsAdded += crop.cropPoints;
          observerSubject.notifyPoints(player.pointsAdded);
          break;
        default:
          // hydrate
          crop.hydrate();
          break;
        }

        return; // Exit the loop if a crop is found
      }
    }
  }
}
