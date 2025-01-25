public class User {
    //attributes : chosen diploma, current earned total credits
    //some way of mapping their courses to the requirements they fulfill
    //array of TableDisplays allows us to switch between table displays depending on the year they click
    //and we could also give them an ArrayList that stores every course from each table
    ArrayList<TableDrawing> userSchedules;
    boolean hasDuplicate;
    boolean hasPrereqs;
    String noReqReason; //stores why user doesn't meet prereqs

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

     public boolean addCourse(ArrayList<TableDrawing> schedule, String year, int row, int col, String courseName, ArrayList<Course> courseList){
        boolean hasTwoCredits = false;
        hasDuplicate = false;
        hasPrereqs = hasPrereqs(courseName, courseList, year);
        int cred = 1;
        if (col == 1){
            cred = -1;
        }
        for (int i = 0; i < 5; i++){
            for (int j = 0; j < schedule.get(i).getLabelArray().length; j++){
                for (int k = 0; k < schedule.get(i).getLabelArray()[j].length; k++){
                    if (schedule.get(i).getLabelArray()[j][k].equals(courseName)){ //checks for duplicate course
                        hasDuplicate = true;
                        break;
                    }
                }
            }
        }
        if (!hasDuplicate && hasPrereqs){
        if (year.equals("Freshman")){
            if (getCreditNum(courseName) == 2){
            schedule.get(0).setOneLabel(row,col + cred,courseName);
            hasTwoCredits = true;
            }
            schedule.get(0).setOneLabel(row, col, courseName);
        } else if (year.equals("Sophomore")){
            if (getCreditNum(courseName) == 2){
            schedule.get(1).setOneLabel(row,col + cred,courseName);
            hasTwoCredits = true;
            }
            schedule.get(1).setOneLabel(row,col,courseName);
        } else if (year.equals("Junior")){
            if (getCreditNum(courseName) == 2){
            schedule.get(2).setOneLabel(row,col + cred,courseName);
            hasTwoCredits = true;
            }
            schedule.get(2).setOneLabel(row,col,courseName);
        } else if (year.equals("Senior")){
            if (getCreditNum(courseName) == 2){
            schedule.get(3).setOneLabel(row,col + cred,courseName);
            hasTwoCredits = true;
            }
            schedule.get(3).setOneLabel(row,col,courseName);
        } else if (year.equals("Other")){
            if (getCreditNum(courseName) == 2){
            schedule.get(4).setOneLabel(row,col + cred,courseName);
            hasTwoCredits = true;
            }
            schedule.get(4).setOneLabel(row,col,courseName);
        }
        }
        return hasTwoCredits;
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

    public int getCreditNum(String courseName){
        for (int i = 0; i < courses.size();i++){
            if (courses.get(i).name.equals(courseName)){
                return courses.get(i).numCredits;
            }
        }
        return 1;
    }

    public boolean hasPrereqs(String courseName, ArrayList<Course> courses, String year){
        Course currentCourse = courses.get(0); //placeholder
        int yearNum;
        int currentGradeLevel;
        for (int i = 0; i < courses.size(); i++){
            if (courseName.equals(courses.get(i).name)){
                currentCourse = courses.get(i);
                break;
            }
        }
        //array of prereqs and whether or not they're met
        String[] currentPrereqs = new String[currentCourse.prereq.length];
        for (int i = 0; i < currentPrereqs.length; i++){
            currentPrereqs[i] = currentCourse.prereq[i];
        }
        boolean[] currentHasPrereqs = new boolean[currentCourse.prereq.length];
        for (int i = 0; i < currentHasPrereqs.length; i++){
            currentHasPrereqs[i] = false;
        }

        if (year.equals("Freshman")){
            yearNum = 0;
            currentGradeLevel = 9;
        } else if (year.equals("Sophomore")){
            yearNum = 1;
            currentGradeLevel = 10;
        } else if (year.equals("Junior")){
            yearNum = 2;
            currentGradeLevel = 11;
        } else if (year.equals("Senior")){
            yearNum = 3;
            currentGradeLevel = 12;
        } else {
            //for Other schedule, makes it greater than and after all years
            yearNum = 4;
            currentGradeLevel = 13;
        }
        //check grade level requirement
        if (currentGradeLevel < currentCourse.gradeLevel){
            noReqReason = "The selected grade level is too low for this course.";
            return false;
        }

        //go through all previous schedules and check if prereqs of currentCourse are in that schedule
        for (int i = yearNum; i >= 0; i--){ //goes through all schedules of previous years
            String[][] schedule = userSchedules.get(i).getLabelArray();
            for (int j = 0; j < schedule.length; j++){ //goes through array of courses in schedule
                for (int k = 0; k < schedule[j].length; k++){
                    for (int l = 0; l < currentPrereqs.length; l++){ // goes through all prereqs
                        if (schedule[j][k].equals(currentPrereqs[l])){
                            currentHasPrereqs[l] = true;
                        }
                    }
                }
            }
        }
        for (int i = 0; i < currentHasPrereqs.length; i++){
            if (!currentHasPrereqs[i]){
                noReqReason = "In order to schedule this course, you must schedule its prerequisite courses first.";
                return false;
            }
        }
        
        return true;
    }
}
