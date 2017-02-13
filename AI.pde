class AI {

  /*
  
   1. Fills up bottom right corner
   2. Cancels out any negatives
   
   */

  void update() {

    //Fills up bottom right corner
    if (isEmptyColumn(cells.length-1)) {
      Vector2i next;

      next = getNext(cells.length-1, cells[0].length-1, Direction.Up);
      if (next != null) {
        swipe(Direction.Down);
        return;
      }

      next = getNext(cells.length-1, cells[0].length-1, Direction.Left);
      if (next != null) {
        swipe(Direction.Right);
        return;
      }
    }


    //Cancels out any negatives except for those on the far right column
    Vector2i[] negatives = findAllNegatives();
    for (Vector2i neg : negatives) {

      Vector2i right = getNext(neg.x, neg.y, Direction.Right);
      if (right != null && abs(cells[right.x][right.y].val) == abs(cells[neg.x][neg.y].val)) {
        if (right.x == cells.length - 1) {
          swipe(Direction.Down);
        } else {
          swipe(Direction.Right);
        }
        return;
      }

      Vector2i left = getNext(neg.x, neg.y, Direction.Left);
      if (left != null && abs(cells[left.x][left.y].val) == abs(cells[neg.x][neg.y].val)) {
          swipe(Direction.Right);
        return;
      }

      Vector2i down = getNext(neg.x, neg.y, Direction.Down);
      if (down != null && abs(cells[down.x][down.y].val) == abs(cells[neg.x][neg.y].val)) {
        swipe(Direction.Down);
        return;
      }

      Vector2i up = getNext(neg.x, neg.y, Direction.Up);
      if (up != null && abs(cells[up.x][up.y].val) == abs(cells[neg.x][neg.y].val) ) {
        swipe(Direction.Down);
        return;
      }
    }

    for (int j = cells[0].length - 1; j >= 0; j--) {
      for (int i = cells.length - 1; i >= 0; i--) {
        if (calcMovement(i, j)) return;
      }
    }





    //if all else fails
    Cell[][] copy = copyCells();

    swipe(Direction.Right);
    if (!equalsCells(copy)) return;

    swipe(Direction.Down);
    if (!equalsCells(copy)) return;

    swipe(Direction.Up);
    if (!equalsCells(copy)) return;

    swipe(Direction.Left);
    if (!equalsCells(copy)) return;
  }

  boolean isEmptyColumn(int x) {
    for (int j = 0; j < cells[0].length; j++) {
      if (cells[x][j].val != 0) return false;
    }
    return true;
  }

  boolean isEmptyRow(int y) {
    for (int i = 0; i < cells.length; i++) {
      if (cells[i][y].val != 0) return false;
    }
    return true;
  }

  boolean calcMovement(int x, int y) {
    Vector2i up = getNext(x, y, Direction.Up);
    if (up != null) {
      if (cells[up.x][up.y].val == cells[x][y].val) {
        swipe(Direction.Down); 
        return true;
      }
    }

    Vector2i left = getNext(x, y, Direction.Left);
    if (left != null) {
      if (cells[left.x][left.y].val == cells[x][y].val) {
        swipe(Direction.Right); 
        return true;
      }
    }

    return false;
  }

  Vector2i[] findAllNegatives() {
    ArrayList<Vector2i> list = new ArrayList<Vector2i>();
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[0].length; j++) {
        if (cells[i][j].val < 0) list.add(new Vector2i(i, j));
      }
    }
    return (Vector2i[])list.toArray(new Vector2i[list.size()]);
  }

  //returns the location of the next non-zero cell in the given direction
  Vector2i getNext(int x, int y, Direction d) {
    while (true) {
      switch (d) {
      case Up:
        y--;
        break;
      case Down:
        y++;
        break;
      case Right:
        x++;
        break;
      case Left:
        x--;
        break;
      }
      if (!(x >= 0 && x < cells.length && y >= 0 && y < cells[0].length)) return null;
      if (cells[x][y].val != 0) return new Vector2i(x, y);
    }
  }
}