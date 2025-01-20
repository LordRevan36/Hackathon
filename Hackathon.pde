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
User user;
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
    //diploma screen UI elements
GOption generalDiplomaButton, core40Button, academicHonorsButton, technicalHonorsButton;
GLabel selectDiplomaLabel, totalCreditsLabel;
GToggleGroup diplomaSelection;
    //course list screen UI elements
GTextField searchBar;
GLabel searchBarLabel;
    


//settings
public void settings() {
    size(800,800);
}

//setup
public void setup() {
    surface.setTitle("Hackathon Project - Name Better Later");
    diplomas = new ArrayList<Diploma>();
    courses = new ArrayList<Course>();
    user = new User();
    setupCourses("CourseList.csv");
    initializeGlobalUIElements();
    initializeScheduleUIElements(true);
    initializeScheduleTable();
    initializeDiplomaUIElements(false);
    initializeCourseListUIElements(false);

    
    
}

//draw
public void draw() {
    background(255);
    currentProgressBar.drawProgressBar(true, 2);
    finalProgressBar.drawProgressBar(true, 2);
    if (screen.equals("Schedule")) scheduleTable.drawTable();
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
        } else if (button == scheduleButton){
            screen = "Schedule";
            schedule.setEnabled(true);
            schedule.setVisible(true);
            courseList.setEnabled(false);
            courseList.setVisible(false);
            diplomaRequirements.setEnabled(false);
            diplomaRequirements.setVisible(false);
        } else if (button == courseListButton){
            screen = "Course List";
            schedule.setEnabled(false);
            schedule.setVisible(false);
            courseList.setEnabled(true);
            courseList.setVisible(true);
            diplomaRequirements.setEnabled(false);
            diplomaRequirements.setVisible(false);
        }
        //changes displayed schedule table
        if (button == freshmanButton) {
            scheduleTable = user.userSchedules.get(0);
        } else if (button == sophomoreButton) {
            scheduleTable = user.userSchedules.get(1);
        } else if (button == juniorButton) {
            scheduleTable = user.userSchedules.get(2);
        } else if (button == seniorButton) {
            scheduleTable = user.userSchedules.get(3);
        } else if (button == otherButton) {
            scheduleTable = user.userSchedules.get(4);
        }
    }
}

public void handleToggleControlEvents(GToggleControl option, GEvent event) {
    
}

public void handleTextEvents(GEditableTextControl textcontrol, GEvent event) {

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
            while (temp.contains(",")) {//repeats for each prereq value except the last
                index = temp.indexOf(",");
                courses.get(last).prereq[i] = temp.substring(0,index);
                temp = temp.substring(index + 1);
                i++;
            }
            courses.get(last).prereq[courses.get(last).prereq.length - 1] = temp;//last value doesn't contain comma
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
    schedule.addControl(freshmanButton);
    schedule.addControl(sophomoreButton);
    schedule.addControl(juniorButton);
    schedule.addControl(seniorButton);
    schedule.addControl(otherButton);
    schedule.setVisible(visible);
}

public void initializeScheduleTable() {
    String[] titles = {"Freshman Year", "Sophomore Year", "Junior Year", "Senior Year", "Other"};
    String[][] labels = {{"Semester 1", "Semester 2"}, {"APCSA", "APCSA"}, {"AP Calc BC", "AP Calc BC"}, {"", ""}, {"", ""}, {"", ""}, {"", ""}, {"", ""}};
    user.initializeTableDrawings(8, 2, 150, 330, 500, 250, titles, labels, 2, 16, color(0), color(0));
    scheduleTable = user.userSchedules.get(0);
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
    searchBar = new GTextField(this, 200, 256, 440, 20);
    searchBarLabel = new GLabel(this, 140, 250, 60, 30, "Search:");
    courseList.addControl(searchBar);
    courseList.addControl(searchBarLabel);
    courseList.setVisible(visible);
}
