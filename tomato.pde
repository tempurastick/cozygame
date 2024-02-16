class Tomato extends Crops {

  Tomato(float cropX, float cropY) {
    super(cropX, cropY);

    // easier
    growThreshold = 12;
    cropPoints = 6;

    youngAdult = loadImage("images/youngtomato.png");
    adult = loadImage("images/tomato.png");
  }
}

class Pumpkin extends Crops {
  Pumpkin(float cropX, float cropY) {
    super(cropX, cropY);

    cropPoints = 13;

    youngAdult = loadImage("images/youngadult.png");
    adult = loadImage("images/adult.png");
  }
}

class Carrot extends Crops {
  Carrot(float cropX, float cropY) {
    super(cropX, cropY);

    // easier
    growThreshold = 10;
    hydrationLevel = 5;
    cropPoints = 8;

    youngAdult = loadImage("images/youngcarrot.png");
    adult = loadImage("images/carrot.png");
  }
}

class Kohl extends Crops {
  Kohl(float cropX, float cropY) {
    super(cropX, cropY);

    // long time
    growThreshold = 20;
    cropPoints = 25;

    youngAdult = loadImage("images/youngkohl.png");
    adult = loadImage("images/kohl.png");
  }

  void hydrate() {
    if ( GROWSTATUS != DEAD ) {
      hydrationLevel += 6;
    }
  }
}

class Bokchoy extends Crops {

  Bokchoy(float cropX, float cropY) {
    super(cropX, cropY);

    // easy
    growThreshold = 9;
    cropPoints = 3;
    hydrationLevel = 15;

    youngAdult = loadImage("images/babychoy.png");
    adult = loadImage("images/bokchoy.png");
  }
}

class Eggplant extends Crops {
  Eggplant(float cropX, float cropY) {
    super(cropX, cropY);

    // long time
    growThreshold = 13;
    hydrationLevel = 30;
    cropPoints = 5;

    youngAdult = loadImage("images/youngeggplant.png");
    adult = loadImage("images/eggplant.png");
  }

  void hydrate() {
    if ( GROWSTATUS != DEAD ) {
      hydrationLevel += 5;
    }
  }
}
