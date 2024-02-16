class Crops implements Observer {

  PImage seed;
  PImage seedling;
  PImage youngAdult;
  PImage adult;
  PImage dead;
  // width & size
  float cropW, cropH;
  // crop pos
  float cropX, cropY;
  // crop growth status
  int lifeCycle = 1;

  // state machine for crops
  int GROWSTATUS;
  int SEED = 0;
  int YOUNG = 1;
  int YOUNGADULT = 2;
  int ADULT = 3;
  int DEAD = 4;

  int growThreshold;

  // how many points you gain
  int cropPoints;

  // water level
  int hydrationLevel;

  // reference for steps
  int previousActionCount = 0;

  int cropType;
  Crops crops;

  Crops(float cropX, float cropY) {
    this.cropX = cropX;
    this.cropY = cropY;
    growThreshold = 10;
    cropW = 50;
    cropH = 50;
    hydrationLevel = 10;

    cropPoints = 10;
    seed = loadImage("images/seeds.png");
    seedling = loadImage("images/seedling.png");
    // fallback
    youngAdult = loadImage("images/youngadult.png");
    adult = loadImage("images/adult.png");
    dead = loadImage("images/dead.png");
  }

  int getHydration() {
    return hydrationLevel;
  }

  void hydrate() {
    if ( GROWSTATUS != DEAD ) {
      hydrationLevel += 10;
    }
  }

  Crops checkNeighbour() {
    return crops;
  }

  int checkGrowthStatus() {
    return GROWSTATUS;
  }

  void registerObserver( ObserverSubject observerSubject) {
    observerSubject.addObserver(this);
  }

  void update(Object observer) {
    // Implement how Crops respond to updates from observers (if needed)
  }

  void updateNotifyPoints(Observer observer, int points) {
  }

  void updateCropSelection(Observer observer, int cropSelection) {
  }

  void updateActionCount(Observer observer, int actionCount) {
    if ( actionCount != previousActionCount && GROWSTATUS != DEAD) {
      if (observer instanceof Crops) {
        Crops crop = (Crops) observer;
        crop.hydrationLevel--;
      }
      lifeCycle++;
      previousActionCount = actionCount;
    }
  }

  void updateGrowthStatus(Observer observer, int growthStatus) {
    if (observer instanceof Crops) {
      Crops crop = (Crops) observer;
      crop.checkGrowthStatus();
    }
  }

  void growCrops() {
    imageMode(CENTER);
    if ( hydrationLevel > 1 ) {
      // seeds have the same parameter
      if (lifeCycle >= 1 && lifeCycle <= 2 ) {
        image(seed, cropX, cropY);
        GROWSTATUS = SEED;
      } else if ( lifeCycle >= 2 && lifeCycle <= (growThreshold/2) ) {
        image(seedling, cropX, cropY);
        GROWSTATUS = YOUNG;
      } else if ( lifeCycle >= 5 && lifeCycle <= growThreshold ) {
        image(youngAdult, cropX, cropY);
        GROWSTATUS = YOUNGADULT;
      } else if ( lifeCycle >= growThreshold+1 ) {
        image(adult, cropX, cropY);
        GROWSTATUS = ADULT;
      }
    } else if ( hydrationLevel <= 1 ) {
      image(dead, cropX, cropY);
      GROWSTATUS = DEAD;
    }
    observerSubject.notifyGrowthStatus(GROWSTATUS);
    imageMode(CORNER);
  }

  void draw() {
    growCrops();
  }
}
