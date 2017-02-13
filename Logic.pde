enum GameMode {
  SinglePlayer, TwoPlayer, AI
}

void moveHelper(int line, Direction dir) {
  switch (dir) {
  case Up:
    for (int j = line; j >= 1; j--) {
      for (int i = 0; i < cells.length; i++) {
        if (!movePositive && cells[i][j].val > 0) continue;
        if (!moveNegative && cells[i][j].val < 0) continue;
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
    break;
  case Down:
    for (int j = line; j < cells[0].length - 1; j++) {
      for (int i = 0; i < cells.length; i++) {
        if (!movePositive && cells[i][j].val > 0) continue;
        if (!moveNegative && cells[i][j].val < 0) continue;
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
    break;
  case Right:
    for (int i = line; i < cells.length - 1; i++) {
      for (int j = 0; j < cells[0].length; j++) {
        if (!movePositive && cells[i][j].val > 0) continue;
        if (!moveNegative && cells[i][j].val < 0) continue;
        if (cells[i+1][j].val == 0) {
          cells[i+1][j].set(cells[i][j].val);
          cells[i][j].set(0);
        } else if (cells[i+1][j].val == cells[i][j].val) {
          if (cells[i][j].val > 0) {
            cells[i+1][j].add(1);
          } else {
            cells[i+1][j].sub(1);
          }
          cells[i][j].set(0);
        } else if (cells[i][j].val == -cells[i+1][j].val) {
          cells[i][j].set(0);
          cells[i+1][j].set(0);
        }
      }
    }
    break;
  case Left:
    for (int i = line; i >= 1; i--) {
      for (int j = 0; j < cells[0].length; j++) {
        if (!movePositive && cells[i][j].val > 0) continue;
        if (!moveNegative && cells[i][j].val < 0) continue;
        if (cells[i-1][j].val == 0) {
          cells[i-1][j].set(cells[i][j].val);
          cells[i][j].set(0);
        } else if (cells[i][j].val == cells[i-1][j].val) {
          if (cells[i][j].val > 0) {
            cells[i-1][j].add(1);
          } else {
            cells[i-1][j].sub(1);
          }
          cells[i][j].set(0);
        } else if (cells[i][j].val == -cells[i-1][j].val) {
          cells[i][j].set(0);
          cells[i-1][j].set(0);
        }
      }
    }
    break;
  }
}

void move(Direction d) {
  switch (d) {
  case Up:
    for (int j = 1; j < cells[0].length; j++) {
      moveHelper(j, Direction.Up);
    }
    break;
  case Down:
    for (int j = cells[0].length - 2; j >= 0; j--) {
      moveHelper(j, Direction.Down);
    }
    break;
  case Right:
    for (int i = cells.length - 2; i >= 0; i--) {
      moveHelper(i, Direction.Right);
    }
    break;
  case Left:
    for (int i = 1; i < cells.length; i++) {
      moveHelper(i, Direction.Left);
    }
    break;
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

boolean hasNegative() {
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      if (cells[i][j].val < 0) return true;
    }
  }
  return false;
}

boolean hasPositive() {
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      if (cells[i][j].val > 0) return true;
    }
  }
  return false;
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
  if (gameMode == GameMode.SinglePlayer || gameMode == GameMode.AI) {
    cells[v.x][v.y].val = (random(0, 1) < 0.5 ? 1 : 2) * (random(0, 1) < negBias ? -1 : 1);
  } else if (gameMode == GameMode.TwoPlayer) {
    if (!hasPositive()) {
      cells[v.x][v.y].val = random(0, 1) < 0.5 ? 1 : 2;
    } else if (!hasNegative()) {
      cells[v.x][v.y].val = random(0, 1) < 0.5 ? -1 : -2;
    } else {
      cells[v.x][v.y].val = (random(0, 1) < 0.5 ? 1 : 2) * (random(0, 1) < negBias ? -1 : 1);
    }
  }
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
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      max = max(max, cells[i][j].val);
    }
  }
  return max;
}

int getLowestCell() {
  int min =  2147483647;
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      min = min(min, cells[i][j].val);
    }
  }
  return min;
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

void reset() {

  int seed = int(random(2147483647));
  println("Seed: " + seed);

  cells = new Cell[int(numericalX.val)][int(numericalY.val)];

  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      cells[i][j] = new Cell(0);
    }
  }

  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      cells[i][j].newCount = 0;
    }
  }

  score = 0;
  gameCount = 0;
  gameOverCount = 0;
  moves = 0;

  if (gameMode == GameMode.SinglePlayer || gameMode == GameMode.AI) {
    negBias = 0.2;
  } else if (gameMode == GameMode.TwoPlayer) {
    negBias = 0.5;
  }

  for (int i = 0; i < random(2, 4); i++) {
    randomPopulate();
  }
}

void swipe(Direction dir) {
  if (gameMode == GameMode.TwoPlayer) {
    if (positiveTurn) {
      movePositive = true;
      moveNegative = false;
    } else {
      movePositive = false;
      moveNegative = true;
    }
  } else if (gameMode == GameMode.SinglePlayer || gameMode == GameMode.AI) {
    movePositive = moveNegative = true;
  }
  resetAnimations();
  Cell[][] copy = copyCells();
  move(dir);
  if (!equalsCells(copy)) {
    randomPopulate();
    moves++;
    positiveTurn = !positiveTurn;
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