import java.awt.*; //<>//

final color LOW = color(58, 182, 165);
final color HIGH = color(95, 58, 182);
final int SIZE_X = 4;
final int SIZE_Y = 4;
final int GRID_SIZE = 150;
final int GUI_X = 350;
final int GUI_X_OFFSET = 10;
final int MULTIPLE = 2;

final int MAX = 11;
final float NEG_BIAS = 0.2;

final int FADE_TIME = 25;
final int ENLARGE_TIME = 25;

AI ai;

int gameOverCount = 0;
int gameCount = 0;
int score = 0;

Cell[][] cells;

void settings() {
  size(GRID_SIZE * SIZE_X + GUI_X, GRID_SIZE * SIZE_Y);
}

void setup() {

  surface.setTitle("Not 2048 - Copyright Alex Tan 2017");

  textFont(createFont("Courier New", 1));

  cells = new Cell[SIZE_X][SIZE_Y];

  reset();
  
  ai = new AI();
}




void draw() {
  background(0, 0, 0);
  fill(0, 0, 0);

  textAlign(CENTER, CENTER);

  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {

      color c = color(0, 0, 0, 0);
      if (cells[i][j].val != 0) {
        c = lerpColor(LOW, HIGH, float(abs(cells[i][j].val)) / MAX);
      }
      if (cells[i][j].val < 0) {
        c = color(255 - red(c), 255 - green(c), 255 - blue(c));
      }
      float alpha = min(cells[i][j].life, 0);
      alpha += FADE_TIME;
      alpha /= FADE_TIME;
      alpha *= 128;
      alpha += 128;
      c = color(red(c), green(c), blue(c), alpha);
      fill(c);
      noStroke();
      float size = (cells[i][j].newCount + float(ENLARGE_TIME)) / ENLARGE_TIME * GRID_SIZE;
      size = min(size, GRID_SIZE);
      rect(i * GRID_SIZE + (GRID_SIZE - size) / 2, j * GRID_SIZE + (GRID_SIZE - size) / 2, size, size);

      fill(255, 255, 255);
      String s = cells[i][j].getValue();
      textSize(max(1, 50 * size / GRID_SIZE));
      text(s, GRID_SIZE / 2 + i * GRID_SIZE, GRID_SIZE / 2 + j * GRID_SIZE);
      cells[i][j].life++;
      cells[i][j].newCount++;
    }
  }

  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      fill(0, 0, 0, 0);
      stroke(255, 255, 255, 255);
      rect(i * GRID_SIZE, j * GRID_SIZE, GRID_SIZE, GRID_SIZE);
    }
  }

  if (!hasValidMoves()) {
    gameOverCount++;
  }
  if (gameOverCount <= 360) {
    fill(0, 0, 0, 255 * float(gameOverCount - 120) / 120);
    rect(0, 0, SIZE_X * GRID_SIZE, SIZE_Y * GRID_SIZE);
    fill(255, 255, 255, 255 * float(gameOverCount - 120) / 120);
    text("Game Over", SIZE_X * GRID_SIZE / 2, SIZE_Y * GRID_SIZE / 2);
  }
  if (gameOverCount == 360) {
    gameOverCount = 0;
    reset();
  }
  if (gameOverCount < 120) {
    gameCount++;
  }
  
  if (frameCount % 10 == 0) {
     //ai.update(); 
  }


  textAlign(LEFT, TOP);
  textSize(30);
  fill(255, 255, 255, 255);
  text("Score: " + score, GUI_X_OFFSET + SIZE_X * GRID_SIZE, 0);
  text("Time: " + convertTime(), GUI_X_OFFSET + SIZE_X * GRID_SIZE, 50);
  text("Highest Cell: " + new Cell(getHighestCell()).getValue(), GUI_X_OFFSET + SIZE_X * GRID_SIZE, 100);
  
}

void keyPressed() {
  if (keyCode == UP || key == 'w') {
    swipeUp();
  }
  if (keyCode == DOWN || key == 's') {
    swipeDown();
  }
  if (keyCode == LEFT || key == 'a') {
    swipeLeft();
  }
  if (keyCode == RIGHT || key == 'd') {
    swipeRight();
  }
}



void reset() {
  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      cells[i][j] = new Cell(0);
    }
  }

  for (int i = 0; i < random(2, 4); i++) {
    randomPopulate();
  }

  for (int i = 0; i < cells.length; i++) {
    for (int j = 0; j < cells[0].length; j++) {
      cells[i][j].newCount = 0;
    }
  }

  score = 0;
  gameCount = 0;
}

void swipeUp() {
  resetAnimations();
  Cell[][] copy = copyCells();
  moveUp();
  if (!equalsCells(copy)) {
    randomPopulate();
  }
}

void swipeDown() {
  resetAnimations();
  Cell[][] copy = copyCells();
  moveDown();
  if (!equalsCells(copy)) {
    randomPopulate();
  }
}

void swipeLeft() {
  resetAnimations();
  Cell[][] copy = copyCells();
  moveLeft();
  if (!equalsCells(copy)) {
    randomPopulate();
  }
}

void swipeRight() {
  resetAnimations();
  Cell[][] copy = copyCells();
  moveRight();
  if (!equalsCells(copy)) {
    randomPopulate();
  }
}