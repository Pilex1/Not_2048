class AI {
   
  void update() {
      //priority: right, down, left, up
      
      Cell[][] copy = copyCells();
      
      swipeRight();
      if (!equalsCells(copy)) return;
      
      swipeDown();
      if (!equalsCells(copy)) return;
      
      swipeLeft();
      if (!equalsCells(copy)) return;
      
      swipeUp();
      if (!equalsCells(copy)) return;
      
      
  }
  
}