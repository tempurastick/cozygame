class Tomato extends Crops {

  Tomato(float cropX, float cropY) {
    super(cropX, cropY);
    
    // easier
    growThreshold = 12;
    
    youngAdult = loadImage("images/youngtomato.png");
    adult = loadImage("images/tomato.png");
  }
}

class Carrot extends Crops {
  Carrot(float cropX, float cropY) {
    super(cropX, cropY);
    
    // easier
    growThreshold = 8;
    
    youngAdult = loadImage("images/youngcarrot.png");
    adult = loadImage("images/carrot.png");
  }
}
