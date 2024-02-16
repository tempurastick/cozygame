// observable -> notifies observers about state

class ObserverSubject {
  // intersection between player and crops
  ArrayList<Observer> watchList = new ArrayList<Observer>();

  void addObserver(Observer observer) {
    this.watchList.add(observer);
  }

  void removeObserver(Observer observer) {
    this.watchList.remove(observer);
  }

  void notifyObservers(Object data) {
    for (Observer observer : this.watchList ) {
      observer.update(data);
    }
  }

  void notifyObserversActionCount(int actionCount) {
    for (Observer observer : this.watchList ) {
      observer.updateActionCount(observer, actionCount);
    }
  }

  void notifyGrowthStatus( int growthStatus) {
    for (Observer observer : this.watchList ) {
      observer.updateGrowthStatus(observer, growthStatus);
    }
  }

  void notifyCropSelection ( int cropSelection) {
    for (Observer observer : this.watchList ) {
      observer.updateCropSelection(observer, cropSelection);
    }
  }

  void notifyPoints( int points ) {
    for (Observer observer : this.watchList ) {
      observer.updateNotifyPoints(observer, points);
    }
  }
}
