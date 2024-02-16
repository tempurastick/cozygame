interface Observer {
  void update(Object observer);
  void updateActionCount(Observer observer, int actionCount);
  void updateGrowthStatus(Observer observer, int growthStatus);
  void updateCropSelection(Observer observer, int cropSelection);
  void updateNotifyPoints(Observer observer, int points);
}

class InteractionHandler implements Observer {
  boolean interactionAllowed;

  void update(Object data) {
    // so basically keep intersections in here
  }

  void updateActionCount(Observer observer, int actionCount) {
  }

  void updateGrowthStatus(Observer observer, int growthStatus) {
  }

  void updateCropSelection(Observer observer, int cropSelection) {
  }

  void updateNotifyPoints(Observer observer, int points) {
  }
}
