public class TableDrawing {
    int rowNum, columnNum;
    int[] rowSizes, columnSizes;
    int x, y, wid, hgt;
    int borderWeight, fontSize;
    color borderColor, fillColor, textColor;
    Cell[][] cells;

        //constructors
    public TableDrawing(int rowNum, int columnNum, int x, int y, int wid, int hgt) {
        this.rowNum = rowNum;
        this.columnNum = columnNum;
        this.x = x;
        this.y = y;
        this.wid = wid;
        this.hgt = hgt;
        rowSizes = new int[rowNum];
        columnSizes = new int[columnNum];
        cells = new Cell[rowNum][columnNum];
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
    public TableDrawing(Table table, int x, int y, int wid, int hgt) {
        this(table.getRowCount(), table.getColumnCount(), x, y, wid, hgt);
        for (int i = 0; i < rowNum; i++) {
            rowSizes[i] = hgt/rowSizes.length;
        }
        for (int i = 0; i < columnNum; i++) {
            columnSizes[i] = wid/columnSizes.length;
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
    public void createCellObjects(Table table) {
        int cellX = x;
        int cellY = y;
        for (int i = 0; i < cells.length; i++) {
            for (int j = 0; j < cells[0].length; j++) {
                if (table.getString(i,j) == null) {
                    cells[i][j] = new Cell(cellX, cellY, columnSizes[j], rowSizes[i], "", color(255));
                } else {
                    cells[i][j] = new Cell(cellX, cellY, columnSizes[j], rowSizes[i], table.getString(i,j), color(255));
                }
                cellX += columnSizes[j];
            }
            cellX = x;
            cellY += rowSizes[i];
        }
    }

    public void drawTable() {
        for (Cell[] row : cells) {
            for (Cell cell : row) {
                cell.drawCell(borderWeight, fontSize, borderColor, textColor);
            }
        }
    }
}
