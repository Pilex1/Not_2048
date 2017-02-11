class Cell {

  int val;
  int life;

  int newCount;

  public Cell(int val) {
    this.val = val;
  }
  public void add(int i) {
    score += 4 * val;
    set(val + i);
  }
  public void sub(int i) {
    score += 4 * val;
    set(val - i);
  }
  public void set(int i) {
    if (i != val) {
      life = -FADE_TIME;
    }
    val = i;
  }
  public String getValue() {
    if (val > 0) {
      return "" + int(pow(2, val - 1) * MULTIPLE);
    } else if (val == 0) {
      return "";
    } else {
      return "" + (-int(pow(2, abs(val) - 1) * MULTIPLE));
    }
  }
}

class Vector2i {
  int x, y;
  public Vector2i(int x, int y) {
    this.x = x;
    this.y = y;
  }
}