class Button {

  color colourDefault = color(255, 255, 255, 0);
  color colourHover = color(255, 255, 255, 64);
  int textSize = 50;
  PFont textFont;
  int cooldown = 0;

  PVector pos;
  PVector size;
  String text;
  IAction action;

  boolean changed = false;
  boolean disabled = false;
  boolean centredText = false;

  Button(float x, float y, float w, float h, String text, IAction action) {
    this.pos = new PVector(x, y);
    this.size = new PVector(w, h);
    this.text = text;
    this.action = action;
    textFont = courier;
  }

  void update() {
    if (disabled) return;
    stroke(255, 255, 255, 255);
    if (mouseX >= pos.x && mouseX <= pos.x + size.x && mouseY >= pos.y && mouseY <= pos.y + size.y) {
      fill(colourHover);
      if (mousePressed) {
        if (!changed && cooldown == 0) {
          action.action();
          changed = true;
        }
      } else {
       changed = false; 
      }
    } else {
      fill(colourDefault);
    }

    rect(pos.x, pos.y, size.x, size.y);

    textFont(textFont);
    textSize(textSize);
    fill(255, 255, 255, 255);
    if (centredText) {
       textAlign(CENTER, CENTER);
       text(text, pos.x + size.x / 2, pos.y + size.y / 2);
    } else {
      textAlign(LEFT, CENTER);
      text(text, pos.x + GUI_X_OFFSET, pos.y + size.y / 2);
    }
    
    if (cooldown > 0) {
     cooldown--; 
    }
   
  }
}

class NumericalSelect {

  PVector pos;
  PVector size;
  Button buttonDecrease;
  Button buttonIncrease;

  float min;
  float max;
  float incr;
  float val;

  boolean displayInt;
  boolean disabled;

  NumericalSelect(float x, float y, float w, float h, float min, float max, float incr, float val) {
    pos = new PVector(x, y);
    size = new PVector(w, h);
    this.min = min;
    this.max = max;
    this.incr = incr;
    this.val = val;
    disabled = false;
    displayInt = false;

    buttonDecrease = new Button(x, y, h, h, "<", new IAction() {
      public void action() {
        decrease();
      }
    }
    );
    buttonDecrease.centredText = true;

    buttonIncrease = new Button(x + w - h, y, h, h, ">", new IAction() {
      public void action() {
        increase();
      }
    }
    );
    buttonIncrease.centredText = true;
  }

  void increase() {
    val += incr;
    if (val > max) val = max;
  }

  void decrease() {
    val -= incr;
    if (val < min) val = min;
  }

  void update() {
    if (disabled) return;
    buttonDecrease.update();
    buttonIncrease.update();
    
    fill(buttonIncrease.colourDefault);
    stroke(255, 255, 255, 255);
    rect(pos.x + size.y, pos.y, size.x - 2 * size.y, size.y);
    
    textAlign(CENTER, CENTER);
    textFont(courier);
    textSize(40);
    fill(255, 255, 255, 255);
    String text = ""; //<>//
    if (displayInt) {
      text += int(val);
    } else {
      text += val; 
    }
    text(text, pos.x + size.x / 2, pos.y + size.y / 2);
    
  }
}

color invert(color c) {
 return color(255 - red(c), 255 - green(c), 255 - blue(c), alpha(c)); 
}

interface IAction {
  void action();
}