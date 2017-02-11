void moveUpHelper(int row) {
  for (int j = row; j >= 1; j--) {
    for (int i = 0; i < cells.length; i++) {
      if (cells[i][j-1].val == 0) {
        cells[i][j-1].set(cells[i][j].val);
        cells[i][j].set(0);
      } else if (cells[i][j].val == cells[i][j-1].val) {
        if (cells[i][j].val < 0) {
          cells[i][j-1].sub(1);
        } else {
          cells[i][j-1].add(1);
        }
        cells[i][j].set(0);
      } else if (cells[i][j].val == -cells[i][j-1].val) {
        cells[i][j].set(0);
        cells[i][j-1].set(0);
      }
    }
  }
}
void moveUp() {
  for (int j = 1; j < cells[0].length; j++) {
    moveUpHelper(j);
  }
}

void moveDownHelper(int row) {
  for (int j = row; j < cells[0].length - 1; j++) {
    for (int i = 0; i < cells.length; i++) {
      if (cells[i][j+1].val == 0) {
        cells[i][j+1].set(cells[i][j].val);
        cells[i][j].set(0);
      } else if (cells[i][j+1].val == cells[i][j].val) {
        if (cells[i][j+1].val > 0) {
          cells[i][j+1].add(1);
        } else {
          cells[i][j+1].sub(1);
        }
        cells[i][j].set(0);
      } else if (cells[i][j].val == -cells[i][j+1].val) {
        cells[i][j].set(0);
        cells[i][j+1].set(0);
      }
    }
  }
}
void moveDown() {
  for (int j = cells[0].length - 2; j >= 0; j--) {
    moveDownHelper(j);
  }
}

void moveLeftHelper(int col) {
  for (int i = col; i >= 1; i--) {
    for (int j = 0; j < cells[0].length; j++) {
      if (cells[i-1][j].val == 0) {
        cells[i-1][j].set(cells[i][j].val);
        cells[i][j].set(0);
      } else if (cells[i][j].val == cells[i-1][j].val) {
        if (cells[i][j].val > 0) {
         cells[i-1][j].add(1);
        }else{
         cells[i-1][j].sub(1);
        }
        cells[i][j].set(0);
      } else if (cells[i][j].val == -cells[i-1][j].val) {
        cells[i][j].set(0);
        cells[i-1][j].set(0);
      }
    }
  }
}
void moveLeft() {
  for (int i = 1; i < cells.length; i++) {
    moveLeftHelper(i);
  }
}

void moveRightHelper(int col) {
  for (int i = col; i < cells.length - 1; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      if (cells[i+1][j].val == 0) {
        cells[i+1][j].set(cells[i][j].val);
        cells[i][j].set(0);
      } else if (cells[i+1][j].val == cells[i][j].val) {
        if (cells[i][j].val > 0) {
         cells[i+1][j].add(1);
        }else{
         cells[i+1][j].sub(1);
        }
        cells[i][j].set(0);
      } else if (cells[i][j].val == -cells[i+1][j].val) {
        cells[i][j].set(0);
        cells[i+1][j].set(0);
      }
    }
  }
}
void moveRight() {
  for (int i = cells.length - 2; i >= 0; i--) {
    moveRightHelper(i);
  }
}

Vector2i[] getEmptyCells() {
  ArrayList<Vector2i> list = new ArrayList<Vector2i>();
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      if (cells[i][j].val == 0) {
        list.add(new Vector2i(i, j));
      }
    }
  }
  return (Vector2i[])list.toArray(new Vector2i[list.size()]);
}

boolean validRegion(int x, int y) {
  return x >= 0 && x < cells.length && y >= 0 && y < cells[0].length;
}

boolean hasValidMoves() {
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      if (validRegion(i-1, j)) {
        if (abs(cells[i-1][j].val) == abs(cells[i][j].val)) return true;
        if (cells[i-1][j].val == 0) return true;
      }
      if (validRegion(i+1, j)) {
        if (abs(cells[i+1][j].val) == abs(cells[i][j].val)) return true;
        if (cells[i+1][j].val == 0) return true;
      }
      if (validRegion(i, j-1)) {
        if (abs(cells[i][j-1].val) == abs(cells[i][j].val)) return true;
        if (cells[i][j-1].val == 0) return true;
      }
      if (validRegion(i, j+1)) {
        if (abs(cells[i][j+1].val) == abs(cells[i][j].val)) return true;
        if (cells[i][j+1].val == 0) return true;
      }
    }
  }
  return false;
}

void randomPopulate() {
  Vector2i[] list = getEmptyCells();
  if (list.length == 0) return;
  Vector2i v = list[int(random(0, list.length))];
  cells[v.x][v.y].val = (random(0, 1) < 0.5 ? 1 : 2) * (random(0, 1) < NEG_BIAS ? -1 : 1);
  cells[v.x][v.y].newCount = -ENLARGE_TIME;
}

Cell[][] copyCells() {
  Cell[][] copy = new Cell[cells.length][cells[0].length];
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      copy[i][j] = new Cell(cells[i][j].val);
    }
  }
  return copy;
}

int getHighestCell() {
   int max = -2147483648;
   Cell cell;
   for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      max = max(max, cells[i][j].val);
    }
  }
  return max;
}

boolean equalsCells(Cell[][] copy) {
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      if (copy[i][j].val != cells[i][j].val) return false;
    }
  }
  return true;
}

void resetAnimations() {
   for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      cells[i][j].life = 0;
      cells[i][j].newCount = 0;
    }
  }
}

String convertTime() {
   int seconds = gameCount / 60;
   int hours = seconds / 3600;
   int minutes = seconds / 60;
   
   int dSeconds = seconds % 60;
   int dMinutes = minutes % 60;
   
   String s = "";
   if (hours > 0) s += hours + "h ";
   if (dMinutes > 0) s += dMinutes + "m ";
   if (dSeconds > 0) s += dSeconds + "s";
   if (s == "") s = "0s";
   return s;
}