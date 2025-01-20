public class ProgressBar {
    int x, y, wid, hgt;
    int min, max, value;
    color backdropColor, progressColor, borderColor, textColor;
    int borderWeight;
    int fontSize;
    String alignment;

    //constructors
    public ProgressBar(int x, int y, int wid, int hgt, int min, int max, int value) {
        this.x = x;
        this.y = y;
        this.wid = wid;
        this.hgt = hgt;
        this.min = min;
        this.max = max;
        this.value = value;
    }
    public ProgressBar(int x, int y, int wid, int hgt, int min, int max, int value, int borderWeight, color backdropColor, color progressColor, color borderColor, color textColor) {
        this(x, y, wid, hgt, min, max, value);
        this.borderWeight = borderWeight;
        setColors(backdropColor, progressColor, borderColor, textColor);
    }
    public ProgressBar(int x, int y, int wid, int hgt, int min, int max, int value, int fontSize, String alignment) {
        this(x, y, wid, hgt, min, max, value);
        this.fontSize = fontSize;
        this.alignment = alignment;
    }

    //methods
    public void setColors(color backdropColor, color progressColor, color borderColor, color textColor) {
        this.backdropColor = backdropColor;
        this.progressColor = progressColor;
        this.borderColor = borderColor;
        this.textColor = textColor;
    }

    public void drawProgressBar(boolean displayLabel, int barOffset) {
        fill(backdropColor);
        strokeWeight(borderWeight);
        stroke(borderColor);
        rect(x, y, wid, hgt);
        noStroke();
        fill(progressColor);
        int barWidth = (int) ((wid - 2*barOffset) * ((double) value)/(max - min));
        rect(x + barOffset, y + barOffset, barWidth, hgt - 2*barOffset);
        if (displayLabel) {
            int textX, textY;
            int textOffset = 5;
            switch (alignment) {
                case "RIGHT":
                    textX = x + wid + textOffset;
                    textY = y + hgt/2;
                    textAlign(LEFT, CENTER);
                    break;
                case "LEFT":
                    textX = x - textOffset;
                    textY = y + hgt/2;
                    textAlign(RIGHT, CENTER);
                    break;
                case "TOP":
                    textX = x + wid/2;
                    textY = y - textOffset;
                    textAlign(CENTER, BOTTOM);
                    break;
                case "BOTTOM":
                    textX = x + wid/2;
                    textY = y + hgt + textOffset;
                    textAlign(CENTER, TOP);
                    break;
                default:
                    textX = x + wid + textOffset;
                    textY = y + hgt/2;
                    textAlign(LEFT, CENTER);
                    break;
            }
            textSize(fontSize);
            fill(textColor);
            text(value + "/" + max, textX, textY);
        }
    }
}
