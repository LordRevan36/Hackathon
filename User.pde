public class User {
    //attributes : chosen diploma, current earned total credits
    //some way of mapping their courses to the requirements they fulfill
    //array of TableDisplays allows us to switch between table displays depending on the year they click
    //and we could also give them an ArrayList that stores every course from each table
    ArrayList<TableDrawing> userSchedules;

    public User() {

    }

    public void initializeTableDrawings(int rowNum, int columnNum, int x, int y, int wid, int hgt, String[] titles, String[][] labels, GTextField[][] tableFields, int borderWeight, int fontSize, color borderColor, color textColor) {
        userSchedules = new ArrayList<TableDrawing>();
        for (int i = 0; i < 5; i++) {
            userSchedules.add(new TableDrawing(rowNum, columnNum, x, y, wid, hgt));
            userSchedules.get(i).title = titles[i];
            userSchedules.get(i).setDisplay(borderWeight, fontSize, borderColor, textColor);
            userSchedules.get(i).createCellObjects(labels, true);   
        }
        setEmptyCells(tableFields, labels, x, y, (float)wid/rowNum, (float)hgt/columnNum);
    }
    
    
    
    
}