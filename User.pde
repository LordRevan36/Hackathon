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
            //setEmptyCells(tableFields, labels, x, y, (float)wid/rowNum, (float)hgt/columnNum);
        }
    }
    /*
    //sets the empty cells to text fields
    public void setEmptyCells(GTextField[][] tableFields, String[][] labels, int x, int y, float wid, float hgt){
        for (int i = 0; i < labels.length; i++){
            for (int j = 0; j < labels[i].length - 1;j++){
                //set location of the text box      !!!IN PROGRESS
                tableFields[i][j] = new GTextField(this, x + wid*j, y + hgt*i, wid, hgt);
                //set the text field if box is empty
                if (labels[i][j].equals("")){
                    tableFields[i][j].setVisible(true);
                    tableFields[i][j].setEnabled(true);
                } else {
                    tableFields[i][j].setVisible(false);
                    tableFields[i][j].setEnabled(false);
                }
            }
        }
    } */
    
    
}