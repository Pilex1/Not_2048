import java.awt.*; //<>//

final color LOW = color(58, 182, 165);
final color HIGH = color(95, 58, 182);

final int GRID_SIZE = 150;
final int GUI_X = 350;
final int GUI_X_OFFSET = 10;

final int MAX = 11;

final int FADE_TIME = 25;
final int ENLARGE_TIME = 25;

PFont courier;

AI ai;

float negBias = 0.2;
int gameOverCount = 0;
int gameCount = 0;
int score = 0;
int moves = 0;
boolean inGame = false;
boolean positiveTurn = true;
boolean movePositive = false;
boolean moveNegative = false;
GameMode gameMode;

Button buttonSinglePlayer;
Button buttonTwoPlayer;
Button buttonAI;
NumericalSelect numericalMultiple;
NumericalSelect numericalX;
NumericalSelect numericalY;

Button buttonReset;
Button buttonHome;

Cell[][] cells;

/*
Seeds:
922753024
 */

void settings() {
  fullScreen();
  //size(GRID_SIZE * SIZE_X + GUI_X, GRID_SIZE * SIZE_Y);
}

void setup() {

  surface.setTitle("Not 2048 - Copyright Alex Tan 2017");

  courier = createFont("Courier New", 1);

  ai = new AI();

  buttonAI = new Button(100, 150, 800, 80, "Watch AI", new IAction() {
    public void action() {
      inGame = true;
      gameMode = GameMode.AI;
      reset();
    }
  }
  );

  buttonSinglePlayer = new Button(100, 250, 800, 80, "Play Singleplayer", new IAction() {
    public void action() {
      inGame = true;
      gameMode = GameMode.SinglePlayer;
      reset();
    }
  }
  );

  buttonTwoPlayer = new Button(100, 350, 800, 80, "Play 2-player", new IAction() {
    public void action() {
      inGame = true;
      gameMode = GameMode.TwoPlayer;
      reset();
    }
  }
  );

  numericalMultiple = new NumericalSelect(100, 550, 600, 80, 2, 20, 1, 2);
  numericalMultiple.displayInt = true;

  numericalX = new NumericalSelect(100, 700, 600, 80, 2, 10, 1, 4);
  numericalX.displayInt = true;
  numericalY = new NumericalSelect(100, 850, 600, 80, 2, 10, 1, 4);
  numericalY.displayInt = true;

  buttonReset = new Button(GRID_SIZE * numericalX.val + GUI_X_OFFSET, 50, GUI_X - GUI_X_OFFSET * 2, 50, "Reset", new IAction() {
    public void action() {
      reset();
    }
  }
  );
  buttonReset.textSize = 30;

  buttonHome = new Button(GRID_SIZE * numericalX.val + GUI_X_OFFSET, 125, GUI_X - GUI_X_OFFSET * 2, 50, "Home", new IAction() {
    public void action() {
      reset();
      buttonSinglePlayer.cooldown = 30;
      buttonTwoPlayer.cooldown = 30;
      inGame = false;
    }
  }
  );
  buttonHome.textSize = 30;
}

void draw() {
  background(0, 0, 0);
  fill(0, 0, 0);

  if (inGame) {
    textFont(courier);
    textAlign(CENTER, CENTER);

    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[0].length; j++) {

        color c = color(0, 0, 0, 0);
        if (cells[i][j].val != 0) {
          c = lerpColor(LOW, HIGH, float(abs(cells[i][j].val)) / MAX);
        }
        if (cells[i][j].val < 0) {
          c = invert(c);
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
    if (gameOverCount > 0) {
      fill(0, 0, 0, 255 * float(gameOverCount - 120) / 120);
      rect(0, 0, numericalX.val * GRID_SIZE, numericalY.val * GRID_SIZE);
      fill(255, 255, 255, 255 * float(gameOverCount - 120) / 120);
      text("Game Over", numericalX.val * GRID_SIZE / 2, numericalY.val * GRID_SIZE / 2);
    }
    if (gameOverCount == 0) {
      gameCount++;
    }

    if (gameMode == GameMode.AI) {
      if (gameCount % 60 == 0) {
        ai.update();
      }
    }


    textAlign(LEFT, BOTTOM);
    textSize(30);
    fill(255, 255, 255, 255);
    text("Score: " + score, GUI_X_OFFSET + numericalX.val * GRID_SIZE, numericalY.val * GRID_SIZE - 200);
    text("Moves: " + moves, GUI_X_OFFSET + numericalX.val * GRID_SIZE, numericalY.val * GRID_SIZE - 150);
    text("Time: " + convertTime(), GUI_X_OFFSET + numericalX.val * GRID_SIZE, numericalY.val * GRID_SIZE - 100);
    String min =  new Cell(getLowestCell()).getValue();
    if (min == "") min = "0";
    String max = new Cell(getHighestCell()).getValue();
    if (max == "") max = "0";
    text("Lowest Cell: " + min, GUI_X_OFFSET + numericalX.val * GRID_SIZE, numericalY.val * GRID_SIZE - 50);
    text("Highest Cell: " + max, GUI_X_OFFSET + numericalX.val * GRID_SIZE, numericalY.val * GRID_SIZE);

    textAlign(LEFT, TOP);
    if (gameMode == GameMode.TwoPlayer) {
      fill(positiveTurn ? lerpColor(LOW, HIGH, 0.5) : lerpColor(invert(LOW), invert(HIGH), 0.5));
      text("2-player: " + (positiveTurn ? "Positive" : "Negative") + "'s turn", GUI_X_OFFSET + numericalX.val * GRID_SIZE, 0);
    } else if (gameMode == GameMode.SinglePlayer) {
      fill(255, 255, 255);
      text("Singleplayer", GUI_X_OFFSET + numericalX.val * GRID_SIZE, 0);
    } else if (gameMode == GameMode.AI) {
     text("AI", GUI_X_OFFSET + numericalX.val * GRID_SIZE, 0);
    }

    buttonReset.pos.x = buttonHome.pos.x = GRID_SIZE * numericalX.val + GUI_X_OFFSET;

    buttonReset.update();
    buttonHome.update();
  } else {

    buttonAI.update();
    buttonSinglePlayer.update();
    buttonTwoPlayer.update();
    numericalMultiple.update();
    numericalX.update();
    numericalY.update();

    textSize(80);
    fill(255, 255, 255);
    textAlign(LEFT, TOP);
    text("Not 2048", 100, 10);

    textSize(30);
    textAlign(RIGHT, BOTTOM);
    text("Copyright Alex Tan 2017", width - 10, height - 10);

    line(90, 0, 90, height);
    line(0, 90, width, 90);

    textAlign(LEFT, TOP);
    textFont(courier);
    textSize(40);
    fill(255, 255, 255, 255);
    text("Multiple", 100, 500);
    text("Grid X", 100, 650);
    text("Grid Y", 100, 800);
  }
}

void keyPressed() {
  if (gameMode == GameMode.AI) return;
  if (keyCode == UP || key == 'w') {
    swipe(Direction.Up);
  }
  if (keyCode == DOWN || key == 's') {
    swipe(Direction.Down);
  }
  if (keyCode == LEFT || key == 'a') {
    swipe(Direction.Left);
  }
  if (keyCode == RIGHT || key == 'd') {
    swipe(Direction.Right);
  }
}