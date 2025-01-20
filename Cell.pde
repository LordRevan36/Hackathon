public class Cell {
    int x, y, wid, hgt;
    String label;
    color fillColor;

        //constructors
    public Cell(int x, int y, int wid, int hgt) {
        this.x = x;
        this.y = y;
        this.wid = wid;
        this.hgt = hgt;
        label = "";
    }
    public Cell(int x, int y, int wid, int hgt, String label) {
        this(x, y, wid, hgt);
        this.label = label;
    }
    public Cell(int x, int y, int wid, int hgt, String label, color fillColor) {
        this(x, y, wid, hgt, label);
        this.fillColor = fillColor;
    }
    public Cell(int x, int y, int wid, int hgt, color fillColor) {
        this(x, y, wid, hgt);
        this.fillColor = fillColor;
    }
        //methods
    public void drawCell(int borderWeight, int fontSize, color borderColor, color textColor) {
        strokeWeight(borderWeight);
        stroke(borderColor);
        fill(fillColor);
        rect(x, y, wid, hgt);
        noStroke();
        fill(textColor);
        textSize(fontSize);
        textAlign(LEFT, CENTER);
        text(label, x + 5, y + hgt/2);
    }
}