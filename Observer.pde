interface Observer {
  void update(Object observer);
  void updateActionCount(Observer observer, int actionCount);
  void updateGrowthStatus(Observer observer, int growthStatus);
  void updateCropSelection(Observer observer, int cropSelection);
}

class InteractionHandler implements Observer {
  boolean interactionAllowed;

  void update(Object data) {
    //println(data + "working");

    // so basically keep intersections in here
  }

  void updateActionCount(Observer observer, int actionCount) {
    //println(actionCount + "action Count");
  }

  void updateGrowthStatus(Observer observer, int growthStatus) {
  }

  void updateCropSelection(Observer observer, int cropSelection) {
  }
}
