public class User {
    //attributes : chosen diploma, current earned total credits
    //some way of mapping their courses to the requirements they fulfill
    //array of TableDisplays allows us to switch between table displays depending on the year they click
    //and we could also give them an ArrayList that stores every course from each table
    ArrayList<TableDrawing> userSchedules;

    public User() {

    }

    public void initializeTableDrawings(int rowNum, int columnNum, int x, int y, int wid, int hgt, String[] titles, String[][] labels, GTextField[][] tableFields, GButton[][] buttons, int borderWeight, int fontSize, color borderColor, color textColor) {
        userSchedules = new ArrayList<TableDrawing>();
        for (int i = 0; i < 5; i++) {
            userSchedules.add(new TableDrawing(rowNum, columnNum, x, y, wid, hgt));
            userSchedules.get(i).title = titles[i];
            userSchedules.get(i).setDisplay(borderWeight, fontSize, borderColor, textColor);
            userSchedules.get(i).createCellObjects(labels, true);   
        }
        setEmptyCells(tableFields, buttons, labels, x, y, (float)wid/rowNum, (float)hgt/columnNum);
    }
    
    public boolean deleteCourse(ArrayList<TableDrawing> schedule, String year, int row, int col){
        boolean hasTwoCredits = false;
        if (year.equals("Freshman")){
            if (getCreditNum(schedule, 0, row, col) == 2){
            schedule.get(0).setOneLabel(row,col + 1,"");
            hasTwoCredits = true;
            }
            schedule.get(0).setOneLabel(row, col, "");
        } else if (year.equals("Sophomore")){
            if (getCreditNum(schedule, 1, row, col) == 2){
            schedule.get(1).setOneLabel(row,col + 1,"");
            hasTwoCredits = true;
            }
            schedule.get(1).setOneLabel(row,col,"");
        } else if (year.equals("Junior")){
            if (getCreditNum(schedule, 2, row, col) == 2){
            schedule.get(2).setOneLabel(row,col + 1,"");
            hasTwoCredits = true;
            }
            schedule.get(2).setOneLabel(row,col,"");
        } else if (year.equals("Senior")){
            if (getCreditNum(schedule, 3, row, col) == 2){
            schedule.get(3).setOneLabel(row,col + 1,"");
            hasTwoCredits = true;
            }
            schedule.get(3).setOneLabel(row,col,"");
        } else if (year.equals("Other")){
            if (getCreditNum(schedule, 4, row, col) == 2){
            schedule.get(4).setOneLabel(row,col + 1,"");
            hasTwoCredits = true;
            }
            schedule.get(4).setOneLabel(row,col,"");
        }
        return hasTwoCredits;
    }

    public int getCreditNum(ArrayList<TableDrawing> schedule, int year, int row, int col){
        String[][] currentSchedule = schedule.get(year).getLabelArray();
        String currentCourseName = currentSchedule[row][col];
        //traverse courses to find currentCourse, then return numCredits of that course
        
        for (int i = 0; i < courses.size(); i++){
            String courseName = courses.get(i).name;
            if (courseName.equals(currentCourseName)){
                return courses.get(i).numCredits;
            }
        }
        
        return 1;
    }
}
