public class TableDrawing {
    String title;
    int rowNum, columnNum;
    int[] rowSizes, columnSizes;
    int x, y, wid, hgt;
    int borderWeight, fontSize;
    color borderColor, fillColor, textColor;
    Cell[][] cells;
    int limit;

        //constructors
    public TableDrawing(int rowNum, int columnNum, int x, int y, int wid, int hgt) {
        this.rowNum = rowNum;
        this.columnNum = columnNum;
        this.x = x;
        this.y = y;
        this.wid = wid;
        this.hgt = hgt;
        limit = -1;
        rowSizes = new int[rowNum];
        columnSizes = new int[columnNum];
        cells = new Cell[rowNum][columnNum];
        for (int i = 0; i < rowNum; i++) {
            rowSizes[i] = hgt/rowNum;
        }
        for (int i = 0; i < columnNum; i++) {
            columnSizes[i] = wid/columnNum;
        }
    }
    public TableDrawing(int rowNum, int columnNum, int x, int y, int wid, int hgt, int limit) {
        this(rowNum, columnNum, x, y, wid, hgt);
        this.limit = limit;
    }
    public TableDrawing(int rowNum, int columnNum, int defaultRowSize, int defaultColumnSize, int x, int y, int wid, int hgt) {
        this(rowNum, columnNum, x, y, wid, hgt);
        for (int i = 0; i < rowNum; i++) {
            rowSizes[i] = defaultRowSize;
        }
        for (int i = 0; i < columnNum; i++) {
            columnSizes[i] = defaultColumnSize;
        }
    }

        //methods
    public void setRowSizes(int[] nums) {
        for (int i = 0; i < nums.length; i++) {
            rowSizes[i] = nums[i];
        }
    }
    public void setColumnSizes(int[] nums) {
        for (int i = 0; i < nums.length; i++) {
            columnSizes[i] = nums[i];
        }
    }
    public void setDisplay(int borderWeight, int fontSize, color borderColor, color textColor) {
        this.borderWeight = borderWeight;
        this.fontSize = fontSize;
        this.borderColor = borderColor;
        this.textColor = textColor;
    }
    public void setAllLabels(String[][] labels, boolean override) {
        for (int i = 0; i < cells.length; i++) {
            for (int j = 0; j < cells[0].length; j++) {
                if (labels[i][j].equals("") && !override) {
                    continue;
                }
                cells[i][j].label = labels[i][j];
            }
        }
    }
    public void setOneLabel(int row, int col, String label){
        cells[row][col].label = label;
    }
    public void setColumn(int index, ArrayList<String> labels) {
        for (int i = 0; i < rowNum; i++) {
            cells[i][index].label = labels.get(i);
            if (i + 1 == labels.size()) {
                break;
            }
        }
    }

    public String[][] getLabelArray() {
        String[][] result = new String[rowNum][columnNum];
        for (int i = 0; i < cells.length; i++) {
            for (int j = 0; j < cells[0].length; j++) {
                result[i][j] = cells[i][j].label;
            }
        }
        return result;
    }

    public void createCellObjects(String[][] labels, boolean override) {
        int cellX = x;
        int cellY = y;
        for (int i = 0; i < cells.length; i++) {
            for (int j = 0; j < cells[0].length; j++) {
                cells[i][j] = new Cell(cellX, cellY, columnSizes[j], rowSizes[i], "", color(255));
                cellX += columnSizes[j];
            }
            cellX = x;
            cellY += rowSizes[i];
        }
        setAllLabels(labels, override);
    }

    public void drawTable(GTextField[][] tableFields) {
        int num = 0;
        for (Cell[] row : cells) {
            for (Cell cell : row) {
                cell.drawCell(borderWeight, fontSize, borderColor, textColor);
            }
            num++;
            if (num == limit) {
                break;
            }
        }
        //setEmptyCells(tableFields, getLabelArray(), x, y, (float)wid/rowNum, (float)hgt/columnNum);
        textSize(25);
        textAlign(CENTER, BOTTOM);
        noStroke();
        fill(0);
        text(title, x + wid/2, y - 5);
    }
    public void drawTable() {
        int num = 0;
        for (Cell[] row : cells) {
            for (Cell cell : row) {
                cell.drawCell(borderWeight, fontSize, borderColor, textColor);
            }
            num++;
            if (num == limit) {
                break;
            }
        }
        //setEmptyCells(tableFields, getLabelArray(), x, y, (float)wid/rowNum, (float)hgt/columnNum);
        textSize(25);
        textAlign(CENTER, BOTTOM);
        noStroke();
        fill(0);
        text(title, x + wid/2, y - 5);
    }
}
