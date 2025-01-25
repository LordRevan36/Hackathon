//imports
//these are all for the fileReader function
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
///import gui library
import g4p_controls.*;

//variables
ArrayList<Diploma> diplomas;
ArrayList<Course> courses;
TableDrawing coursesTable;
User user;
Diploma selectedDiploma;
    //arrays for the courses the user is taking each year, can check for prereqs by traversing the array to find if user has scheduled them
Course[] freshSched = new Course[14];
Course[] sophSched = new Course[14];
Course[] junSched = new Course[14];
Course[] senSched = new Course[14];
    //Global GGroup + a GGroup for each screen
GGroup global, schedule, courseList, diplomaRequirements;
    //stores which screen is on
String screen;
    //the "color theme" object, more to be added to color buttons etc.
//removed (IF)
    //global UI elements
GButton scheduleButton, courseListButton, diplomaRequirementsButton;
GLabel currentProgressLabel, finalProgressLabel;
ProgressBar currentProgressBar, finalProgressBar;
    //schedule screen UI elements
GButton freshmanButton, sophomoreButton, juniorButton, seniorButton, otherButton;
TableDrawing scheduleTable;
GButton[] scheduleAddButtons;
GPanel addCoursePopup;
GTextField[][] scheduleTableTextFields = new GTextField[7][2];
GButton[][] scheduleTableDeleteButtons = new GButton[7][2];
int[] lastTextFieldUsed = new int[2]; //stores row in index 0, stores col in index 1
GLabel errorLabel;
    //stores which grade on the schedule screen is selected
String selectedYear;
    //diploma screen UI elements
GOption generalDiplomaButton, core40Button, academicHonorsButton, technicalHonorsButton;
GLabel selectDiplomaLabel, totalCreditsLabel;
GToggleGroup diplomaSelection;
    //course list screen UI elements
GTextField searchBar;
GLabel searchBarLabel;
GPanel courseDescriptionPopup;
GTextArea courseDescriptionTextArea;

//settings
public void settings() {
    size(800,650);
}

//setup
public void setup() {
    surface.setTitle("Hackathon Project - Name Better Later");
    diplomas = new ArrayList<Diploma>();
    courses = new ArrayList<Course>();
    user = new User();
    selectedYear = "Freshman";
    setupCourses("CourseList.csv");
    initializeGlobalUIElements();
    initializeScheduleUIElements(true);
    initializeScheduleTable();
    initializeScheduleAddButton();
    initializeDiplomaUIElements(false);
    initializeCourseListUIElements(false);
    initializeCourseTable();
    initializeDiplomas();
    
}

//draw
public void draw() {
    background(255);
    currentProgressBar.drawProgressBar(true, 2);
    finalProgressBar.drawProgressBar(true, 2);
    if (screen.equals("Schedule")) scheduleTable.drawTable(scheduleTableTextFields);
    if (screen.equals("Course List")){
        coursesTable.drawTable();
        fill(40,10,120);
        rect(197.5,253.5,445,25);
    } //<>// //<>// //<>// //<>//
    if (screen.equals("Diploma Requirements")) { //<>// //<>//
        selectedDiploma.diplomaTable.drawTable();
    }
}

public void handleButtonEvents(GButton button, GEvent event) {
    if (event == GEvent.CLICKED) {
        if (button == diplomaRequirementsButton){
            screen = "Diploma Requirements";
            schedule.setEnabled(false);
            schedule.setVisible(false);
            courseList.setEnabled(false);
            courseList.setVisible(false);
            diplomaRequirements.setEnabled(true);
            diplomaRequirements.setVisible(true);
            disableScheduleTextFields();
            disableScheduleDeleteButtons();
        } else if (button == scheduleButton){
            screen = "Schedule";
            schedule.setEnabled(true);
            schedule.setVisible(true);
            courseList.setEnabled(false);
            courseList.setVisible(false);
            diplomaRequirements.setEnabled(false);
            diplomaRequirements.setVisible(false);
            setEmptyCells(scheduleTableTextFields, scheduleTableDeleteButtons, scheduleTable.getLabelArray(), scheduleTable.x, scheduleTable.y, (float)scheduleTable.wid/scheduleTable.rowNum, (float)scheduleTable.hgt/scheduleTable.columnNum);
        } else if (button == courseListButton){
            screen = "Course List";
            schedule.setEnabled(false);
            schedule.setVisible(false);
            courseList.setEnabled(true);
            courseList.setVisible(true);
            diplomaRequirements.setEnabled(false);
            diplomaRequirements.setVisible(false);
            disableScheduleTextFields();
            disableScheduleDeleteButtons();
        }
        if (button == diplomaRequirementsButton || button == scheduleButton || button == courseListButton) {
            courseDescriptionPopup.setVisible(false);
            addCoursePopup.setVisible(false);
        }
        //changes displayed schedule table
        if (button == freshmanButton || button == sophomoreButton || button == juniorButton || button == seniorButton || button == otherButton) {
            disableScheduleTextFields();
            disableScheduleDeleteButtons();
            if (button == freshmanButton) {
                scheduleTable = user.userSchedules.get(0);
                selectedYear = "Freshman";
            } else if (button == sophomoreButton) {
                scheduleTable = user.userSchedules.get(1);
                selectedYear = "Sophomore";
            } else if (button == juniorButton) {
                scheduleTable = user.userSchedules.get(2);
                selectedYear = "Junior";
            } else if (button == seniorButton) {
                scheduleTable = user.userSchedules.get(3);
                selectedYear = "Senior";
            } else if (button == otherButton) {
                scheduleTable = user.userSchedules.get(4);
                selectedYear = "Other";
            }
            setEmptyCells(scheduleTableTextFields, scheduleTableDeleteButtons, scheduleTable.getLabelArray(), scheduleTable.x, scheduleTable.y, (float)scheduleTable.wid/scheduleTable.rowNum, (float)scheduleTable.hgt/scheduleTable.columnNum);
        }
        for (int i = 0; i < scheduleTableDeleteButtons.length; i++){
            for (int j = 0; j < scheduleTableDeleteButtons[i].length; j++){
                if (button == scheduleTableDeleteButtons[i][j]){
                    boolean hasTwoCredits = user.deleteCourse(user.userSchedules, selectedYear, i+1, j);
                    scheduleTableDeleteButtons[i][j].setVisible(false);
                    scheduleTableDeleteButtons[i][j].setEnabled(false);
                    scheduleTableTextFields[i][j].setVisible(true);
                    scheduleTableTextFields[i][j].setEnabled(true);
                    if (hasTwoCredits){
                        scheduleTableDeleteButtons[i][j+1].setVisible(false);
                        scheduleTableDeleteButtons[i][j+1].setEnabled(false);
                        scheduleTableTextFields[i][j+1].setVisible(true);
                        scheduleTableTextFields[i][j+1].setEnabled(true);
                    }
                }
            }
        }
        for (int i = 0; i < scheduleAddButtons.length;i++){
            if (button == scheduleAddButtons[i]){
                boolean hasTwoCredits = user.addCourse(user.userSchedules, selectedYear, lastTextFieldUsed[0] + 1, lastTextFieldUsed[1], scheduleAddButtons[i].getText(), courses);
                if (!user.hasDuplicate && user.hasPrereqs){
                scheduleTableTextFields[lastTextFieldUsed[0]][lastTextFieldUsed[1]].setVisible(false);
                scheduleTableDeleteButtons[lastTextFieldUsed[0]][lastTextFieldUsed[1]].setVisible(true);
                scheduleTableTextFields[lastTextFieldUsed[0]][lastTextFieldUsed[1]].setEnabled(false);
                scheduleTableDeleteButtons[lastTextFieldUsed[0]][lastTextFieldUsed[1]].setEnabled(true);
                scheduleTableTextFields[lastTextFieldUsed[0]][lastTextFieldUsed[1]].setText("");
                if (hasTwoCredits){
                    int col = 1;
                    System.out.println(lastTextFieldUsed[1]);
                    if (lastTextFieldUsed[1] == 1){ //if user uses sem2 controls, also get sem1 !!!NEEDS WORK
                        col = -1;
                    }
                    scheduleTableTextFields[lastTextFieldUsed[0]][lastTextFieldUsed[1]+(col)].setVisible(false);
                    scheduleTableDeleteButtons[lastTextFieldUsed[0]][lastTextFieldUsed[1]+(col)].setVisible(true);
                    scheduleTableTextFields[lastTextFieldUsed[0]][lastTextFieldUsed[1]+(col)].setEnabled(false);
                    scheduleTableDeleteButtons[lastTextFieldUsed[0]][lastTextFieldUsed[1]+(col)].setEnabled(true);
                    scheduleTableTextFields[lastTextFieldUsed[0]][lastTextFieldUsed[1]+(col)].setText("");
                }
                addCoursePopup.setVisible(false);
                addCoursePopup.setEnabled(false);  
                }           
            }
        }
    }
}

public void handleToggleControlEvents(GToggleControl option, GEvent event) {
    for (Diploma diploma : diplomas) {
        if (diploma.name.contains(option.getText())) {
            selectedDiploma = diploma;
            return;
        }
    }
}

public void handleTextEvents(GEditableTextControl textcontrol, GEvent event) {
    if (event == GEvent.CHANGED){
        if (textcontrol == searchBar){
            //set labels of coursesTable to searchCourse(searchBar.getText())
            coursesTable.setColumn(0,searchCourse(searchBar.getText(),10));
        }
        for (int i = 0; i < scheduleTableTextFields.length; i++){
            for (int j = 0; j < scheduleTableTextFields[i].length; j++){
                if (textcontrol == scheduleTableTextFields[i][j]){
                    if (j == 0){
                        addCoursePopup.moveTo(2,400);
                    } else {
                        addCoursePopup.moveTo(653,400);
                    }
                    addCoursePopup.setCollapsed(false);
                    addCoursePopup.setVisible(true);
                    addCoursePopup.setEnabled(true);
                    setupAddButtons(scheduleTableTextFields[i][j].getText());
                    lastTextFieldUsed[0] = i;
                    lastTextFieldUsed[1] = j;
                }
            }
        }
    }
}

public void mousePressed() {
    if (screen.equals("Course List")) {
        if (!receiveCourseDescriptionMouseInput().equals("")) {
            courseDescriptionPopup.setVisible(true);
            courseDescriptionTextArea.setVisible(true);
            courseDescriptionPopup.setText(receiveCourseDescriptionMouseInput());
            for (Course course : courses) {
                if (course.name.contains(receiveCourseDescriptionMouseInput())) {
                    courseDescriptionTextArea.setText(course.description);
                    break;
                }
            }
        }
    }
}


public void setupCourses(String fileName) {
    try {
        // Read all lines into a list of strings
        //File file = new File(fileName);
        String filePath = sketchPath(fileName);
        File file = new File(filePath);

        System.out.println("File exists: " + file.exists());
        System.out.println("File absolute path: " + file.getAbsolutePath());
        System.out.println("Working Directory: " + Paths.get("").toAbsolutePath());


        List<String> lines = Files.readAllLines(Paths.get(filePath));
        String temp;
        // Use each line
        for (String line : lines) {
            if (line.substring(0,4).equals("name")) {//skips header line
                continue;
            }
            temp = line;
            int last = courses.size();//index of the soon-to-be last object in array
            int index = temp.indexOf(",");//find first comma
            courses.add(new Course(temp.substring(0,index)));//add object to array
            temp = temp.substring(index + 1);//removes first value and comma
            index = temp.indexOf(",");
            courses.get(last).id = Integer.parseInt(temp.substring(0,index));
            temp = temp.substring(index + 1);
            index = temp.indexOf(",");
            courses.get(last).subject = temp.substring(0,index);
            temp = temp.substring(index + 1);
            index = temp.indexOf(",");
            courses.get(last).weight = Integer.parseInt(temp.substring(0,index));
            temp = temp.substring(index + 1);
            index = temp.indexOf(",");
            courses.get(last).specialClass = temp.substring(0,index);
            temp = temp.substring(index + 1);
            index = temp.indexOf(",");
            courses.get(last).gradeLevel = Integer.parseInt(temp.substring(0,index));
            temp = temp.substring(index + 1);
            index = temp.indexOf(",");
            courses.get(last).numCredits = Integer.parseInt(temp.substring(0,index));
            temp = temp.substring(index + 2);//skip an extra to skip past the quote at the beginning of the line
            index = temp.indexOf("\"");
            courses.get(last).description = temp.substring(0,index);
            temp = temp.substring(index + 2);//skip past quote + comma
            index = temp.indexOf(",");
            courses.get(last).prereq = new String[Integer.parseInt(temp.substring(0,index))];
            temp = temp.substring(index + 1);
            int i = 0;
            while (temp.contains(",")) {//repeats for each prereq value
                index = temp.indexOf(",");
                courses.get(last).prereq[i] = temp.substring(0,index);
                temp = temp.substring(index + 1);
                i++;
            }
            while (temp.contains("/")){ //repeats while there's more tags
                index = temp.indexOf("/");
                courses.get(last).tags.add(new String(temp.substring(0,index)));
                temp = temp.substring(index + 1);
            }
            courses.get(last).tags.add(temp); //add last tag
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
}

public void initializeGlobalUIElements() {
        //initializes to screen1 with screens 2 and 3 hidden
    global = new GGroup(this);
    schedule = new GGroup(this);
    courseList = new GGroup(this);
    diplomaRequirements = new GGroup(this);
    courseList.setVisible(false);
    diplomaRequirements.setVisible(false);
    screen = "Schedule";
        //initialize global UI elements
        //screen switcher buttons
    scheduleButton = new GButton(this, 100, 100, 180, 40, "Schedule");
    courseListButton = new GButton(this, 310, scheduleButton.getY(), scheduleButton.getWidth(), scheduleButton.getHeight(), "Course List");
    diplomaRequirementsButton = new GButton(this, 520, scheduleButton.getY(), scheduleButton.getWidth(), scheduleButton.getHeight(), "Diploma Requirements");
    global.addControl(scheduleButton);
    global.addControl(courseListButton);
    global.addControl(diplomaRequirementsButton);
        //progress bar labels
    int fontSize = 18;
    textSize(fontSize);
    String label = "Current Diploma Completion";
    int fontWidth = (int) (textWidth(label)) + 100;
    currentProgressLabel = new GLabel(this, 45, 170, fontWidth, fontSize + 5, label);
    currentProgressLabel.setFont(new java.awt.Font("Monospaced", java.awt.Font.PLAIN, fontSize));
    label = "Expected Diploma Completion";
    fontWidth = (int) (textWidth(label)) + 100;
    finalProgressLabel = new GLabel(this, 410, currentProgressLabel.getY(), fontWidth, fontSize + 5, label);
    finalProgressLabel.setFont(new java.awt.Font("Monospaced", java.awt.Font.PLAIN, fontSize));
    global.addControl(currentProgressLabel);
    global.addControl(finalProgressLabel);
        //progress bars
    currentProgressBar = new ProgressBar(45, 200, 290, 20, 0, 42, 4, 25, "RIGHT");
    currentProgressBar.setColors(color(0,0,255), color(0,255,0), color(0), color(0));
    finalProgressBar = new ProgressBar(415, 200, 290, 20, 0, 42, 42, 25, "RIGHT");
    finalProgressBar.setColors(color(0,0,255), color(0,255,0), color(0), color(0));
}

public void initializeScheduleUIElements(boolean visible) {
    freshmanButton = new GButton(this, 140, 250, 100, 30, "Freshman");
    sophomoreButton = new GButton(this, 245, freshmanButton.getY(), freshmanButton.getWidth(), freshmanButton.getHeight(), "Sophomore");
    juniorButton = new GButton(this, 350, freshmanButton.getY(), freshmanButton.getWidth(), freshmanButton.getHeight(), "Junior");
    seniorButton = new GButton(this, 455, freshmanButton.getY(), freshmanButton.getWidth(), freshmanButton.getHeight(), "Senior");
    otherButton = new GButton(this, 560, freshmanButton.getY(), freshmanButton.getWidth(), freshmanButton.getHeight(), "Other");
    errorLabel = new GLabel(this, 200, 600, 200, 50, user.noReqReason);
    schedule.addControl(freshmanButton);
    schedule.addControl(sophomoreButton);
    schedule.addControl(juniorButton);
    schedule.addControl(seniorButton);
    schedule.addControl(otherButton);
    schedule.setVisible(visible);
}

public void initializeScheduleTable() {
    String[] titles = {"Freshman Year", "Sophomore Year", "Junior Year", "Senior Year", "Other"};
    String[][] labels = {{"Semester 1", "Semester 2"},  {"", ""}, {"", ""}, {"", ""}, {"", ""}, {"", ""}, {"", ""}, {"", ""}};
    user.initializeTableDrawings(8, 2, 150, 330, 500, 250, titles, labels, scheduleTableTextFields, scheduleTableDeleteButtons, 2, 16, color(0), color(0));
    scheduleTable = user.userSchedules.get(0);
}

public void initializeScheduleAddButton(){
    scheduleAddButtons = new GButton[4]; //popup displays 4 courses at a time
    for (int i = 0; i < 4; i++){
         scheduleAddButtons[i] = new GButton(this, 505, 505, 140,30,"filler");
    }
    addCoursePopup= new GPanel(this,0,800,145,150,"Select a course to add");
    addCoursePopup.setCollapsed(false);
    addCoursePopup.setDraggable(false);
    addCoursePopup.setVisible(false);
    addCoursePopup.setEnabled(false);
    for (int i = 0; i < 4; i++){
        addCoursePopup.addControl(scheduleAddButtons[i],3,22+i*32,0);
    }
}

public void setupAddButtons(String entry){
    String[] suggestedCourses = new String[scheduleAddButtons.length];
    for (int i = 0; i < scheduleAddButtons.length;i++){
        suggestedCourses[i] = searchCourse(entry, scheduleAddButtons.length).get(i);
    }
    for (int i = 0; i < scheduleAddButtons.length; i++){
        scheduleAddButtons[i].setText(suggestedCourses[i]);
    }
}


//for tables: sets the empty cells to text fields
public void setEmptyCells(GTextField[][] tableFields, GButton[][] buttons, String[][] labels, int x, int y, float wid, float hgt){
    for (int i = 0; i < tableFields.length; i++){
        for (int j = 0; j < tableFields[i].length;j++){
            //set location of the text box
            tableFields[i][j] = new GTextField(this, (x+2.5) + (j)*hgt*2, (y+2.5) + (i+1)*wid/2, hgt*2 - 5, wid/2 - 5); //for some reason the width and height are switched
            buttons[i][j] = new GButton(this, (x+ hgt*2-52.5) + (j)*hgt*2, (y+2.5) + (i+1)*wid/2, 50, wid/2 - 5, "Delete"); 
            //set the text field if box is empty
            if (labels[i+1][j].equals("")){
                tableFields[i][j].setVisible(true);
                tableFields[i][j].setEnabled(true);
                buttons[i][j].setVisible(false);
                buttons[i][j].setEnabled(false);
            } else {
                tableFields[i][j].setVisible(false);
                tableFields[i][j].setEnabled(false);
                buttons[i][j].setVisible(true);
                buttons[i][j].setEnabled(true);
            }
        }
    }
}


public void initializeDiplomaTable(){
    //test
}

public void initializeDiplomaUIElements(boolean visible){
    //make radio buttons and add into a toggle group
    generalDiplomaButton = new GOption(this, 240, 250, 100, 30, "General Diploma");
    core40Button = new GOption(this, 350, generalDiplomaButton.getY(), generalDiplomaButton.getWidth(), generalDiplomaButton.getHeight(),"Core 40");
    academicHonorsButton = new GOption(this, 460, generalDiplomaButton.getY(), generalDiplomaButton.getWidth(), generalDiplomaButton.getHeight(),"Academic Honors");
    technicalHonorsButton = new GOption(this, 570, generalDiplomaButton.getY(), generalDiplomaButton.getWidth(), generalDiplomaButton.getHeight(),"Technical Honors");
    diplomaSelection = new GToggleGroup();
    diplomaSelection.addControls(generalDiplomaButton,core40Button,academicHonorsButton,technicalHonorsButton);
    //set labels
    selectDiplomaLabel = new GLabel(this, 130, generalDiplomaButton.getY(), generalDiplomaButton.getWidth(), generalDiplomaButton.getHeight(),"Select diploma:");
    totalCreditsLabel = new GLabel(this, 500, 720, 200, 30, "Total Credits:");
    //add to gui controller
    diplomaRequirements.addControl(generalDiplomaButton);
    diplomaRequirements.addControl(core40Button);
    diplomaRequirements.addControl(academicHonorsButton);
    diplomaRequirements.addControl(technicalHonorsButton);
    diplomaRequirements.addControl(selectDiplomaLabel);
    diplomaRequirements.addControl(totalCreditsLabel);
    diplomaRequirements.setVisible(visible);
}

public void initializeCourseListUIElements(boolean visible){
    int popupWidth = 600;
    int popupHeight = 300;
    searchBar = new GTextField(this, 200, 256, 440, 20);
    textSize(30);
    searchBarLabel = new GLabel(this, 140, 250, 60, 30, "Search:");
    courseDescriptionPopup = new GPanel(this,150,300,popupWidth,popupHeight,"Course Description");
    courseList.addControl(searchBar);
    courseList.addControl(searchBarLabel);
    courseList.setVisible(visible);
    courseDescriptionPopup.setVisible(false);
    courseDescriptionTextArea = new GTextArea(this, 5, 25, popupWidth - 10, popupHeight - 35);
    courseDescriptionTextArea.setTextEditEnabled(false);
    courseDescriptionPopup.addControl(courseDescriptionTextArea, 5, 25);
}


public void disableScheduleTextFields() {
    for (GTextField[] list : scheduleTableTextFields) {
        for (GTextField field : list) {
            field.setVisible(false);
            field.setEnabled(false);
        }
    }
}
public void disableScheduleDeleteButtons(){
    for (GButton[] list : scheduleTableDeleteButtons){
        for (GButton button : list){
            button.setVisible(false);
            button.setEnabled(false);
        }
    }
}

public void initializeCourseTable() {
    ArrayList<String> courseNames = new ArrayList<String>();
    for (Course course : courses) {
        courseNames.add(course.name);
    }
    coursesTable = new TableDrawing(courseNames.size(), 1, 150, 330, 500, 250);
    int columnMagnitude = coursesTable.hgt/8;
    for (int i = 0; i < 10; i++) {
        coursesTable.rowSizes[i] = columnMagnitude;
    }
    String[][] emptyArray = new String[coursesTable.rowNum][coursesTable.columnNum];
    for (int i = 0; i < emptyArray.length; i++) {
        for (int j = 0; j < emptyArray[0].length; j++) {
            emptyArray[i][j] = "";
        }
    }
    coursesTable.createCellObjects(emptyArray, true); //<>// //<>//
    coursesTable.setDisplay(2, 16, color(0), color(0));
    coursesTable.setColumn(0, courseNames);
    coursesTable.limit = 10;
    coursesTable.title = "Courses";
     //<>// //<>//
}

public void initializeDiplomas() {
    int longestColumnWidth = 450;
    diplomas.add(new Diploma("Core 40"));
    Diploma currentDiploma = diplomas.get(0);
    currentDiploma.parseDiploma("Core40.csv", courses);
    diplomaInitializerLogic(currentDiploma, longestColumnWidth);
    
    
    //general diploma
    diplomas.add(new Diploma("General Diploma"));
    currentDiploma = diplomas.get(1);
    currentDiploma.parseDiploma("GeneralDiploma.csv", courses);
    diplomaInitializerLogic(currentDiploma, longestColumnWidth);

    selectedDiploma = diplomas.get(0);
    addDiplomaTags();
}

public void diplomaInitializerLogic(Diploma currentDiploma, int longestColumnWidth) {
    currentDiploma.diplomaTable.setAllProperties(currentDiploma.subjects.size(), 3, 75, 330, 650, 300);
    int[] sizes = {165,longestColumnWidth,35};
    currentDiploma.diplomaTable.setColumnSizes(sizes);
    currentDiploma.diplomaTable.setDisplay(2, 12, color(0), color(0));
    String[][] labels = new String[currentDiploma.diplomaTable.rowNum][currentDiploma.diplomaTable.columnNum];
    for (int i = 0; i < currentDiploma.diplomaTable.rowNum; i++) {
        labels[i][0] = currentDiploma.subjects.get(i).name + " (" + currentDiploma.subjects.get(i).numRequired + ")";
        labels[i][1] = "";
        int requirementCreditsNum = 0;
        String lastLine = "";
        textSize(currentDiploma.diplomaTable.fontSize);
        for (RequiredCourses requirement : currentDiploma.subjects.get(i).requiredCourses) {
            lastLine += requirement.toString(3);
            if (textWidth(lastLine) > longestColumnWidth) {
                labels[i][1] += "\n" + requirement.toString(3);
                lastLine = requirement.toString(3);
            } else {
                labels[i][1] += "; " + requirement.toString(3);
            }
            if (labels[i][1].substring(0,2).equals("; ") || labels[i][1].substring(0,2).equals("\n")) {
                labels[i][1] = labels[i][1].substring(2);
            }
            requirementCreditsNum += requirement.numRequired;
        }
        labels[i][2] = "0/" + requirementCreditsNum;
    }
    currentDiploma.diplomaTable.createCellObjects(labels, true);
}


public ArrayList<String> searchCourse(String entry, int colHgt){
    ArrayList<String> searchedCourses = new ArrayList<>();
    int index = entry.length();
    entry = entry.toLowerCase();
    if (entry.equals("")){ //if search bar is blank, return all courses //<>//
        for (int i = 0; i < courses.size(); i++){ //<>//
            searchedCourses.add(courses.get(i).name);
        }
    } else {
        for (int i = 0; i < courses.size(); i++){
            if (courses.get(i).name.toLowerCase().contains(entry)){ //if course name contains the entry 
                searchedCourses.add(courses.get(i).name);
            } else if (courses.get(i).tags.size() > 0){
                for (int j = 0; j < courses.get(i).tags.size(); j++){
                    if (courses.get(i).tags.get(j).toLowerCase().contains(entry)){ //if first few letters of tags match entry
                        searchedCourses.add(courses.get(i).name);
                        break;
                    }
                }
            }
        }
        while (searchedCourses.size() < colHgt){ //clear extra table cells
            searchedCourses.add("");
        }

    }
    return searchedCourses;
}


public void addDiplomaTags() {
    for (Diploma diploma : diplomas) {
        for (Subject subject : diploma.subjects) {
            for (RequiredCourses requirement : subject.requiredCourses) {
                for (Course course : requirement.courses) {
                    course.tags.add(diploma.name + ":" + subject.name + ":" + requirement.name);
                }
            }
        }
    }
}

public String receiveCourseDescriptionMouseInput() {
    if (mouseX > coursesTable.x && mouseX < coursesTable.x + coursesTable.wid && mouseY > coursesTable.y && mouseY < coursesTable.y + coursesTable.hgt) {
        int pos = coursesTable.y;
        String label;
        for (Cell[] row : coursesTable.cells) {
            if (mouseY >= pos && mouseY <= pos + row[0].hgt) {
                return row[0].label;
            } else {
                pos += row[0].hgt;
            }
        }
    } else if (mouseX < courseDescriptionPopup.getX() || mouseX > courseDescriptionPopup.getX() + courseDescriptionPopup.getWidth() || mouseY < courseDescriptionPopup.getY() || mouseY > courseDescriptionPopup.getY() + courseDescriptionPopup.getHeight()) {
        courseDescriptionPopup.setVisible(false);
    }
    return "";
}
