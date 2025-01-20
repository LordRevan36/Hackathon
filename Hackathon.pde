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
GSlider currentCompletionBar, finalCompletionBar;
GLabel currentProgressLabel, finalProgressLabel;
    //schedule screen UI elements
GButton freshmanButton, sophomoreButton, juniorButton, seniorButton, otherButton;


//settings
public void settings() {
    size(800,800);
}

//setup
public void setup() {
    surface.setTitle("Hackathon Project - Change Later");
    diplomas = new ArrayList<Diploma>();
    courses = new ArrayList<Course>();
    setupCourses("CourseList.csv");
    for (Course course : courses) {
        System.out.println(course.courseToString(true));
    }
    //condensed setup into functions to make setup cleaner
    initializeGlobalUIElements();
    initializeScheduleUIElements();
}

//draw
public void draw() {
    background(255);
}

public void handleSliderEvents(GValueControl slider, GEvent event) {

}

public void handleButtonEvents(GButton button, GEvent event) {
    
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
    System.out.println(fontWidth);
    currentProgressLabel = new GLabel(this, 75, 170, fontWidth, fontSize + 5, label);
    currentProgressLabel.setFont(new java.awt.Font("Monospaced", java.awt.Font.PLAIN, fontSize));
    label = "Expected Diploma Completion";
    fontWidth = (int) (textWidth(label)) + 100;
    System.out.println(fontWidth);
    finalProgressLabel = new GLabel(this, 425, currentProgressLabel.getY(), fontWidth, fontSize + 5, label);
    finalProgressLabel.setFont(new java.awt.Font("Monospaced", java.awt.Font.PLAIN, fontSize));
        //progress bars
    currentCompletionBar = new GSlider(this, currentProgressLabel.getX() - 12, currentProgressLabel.getY() + 30, currentProgressLabel.getWidth(), 15, currentProgressLabel.getWidth());
    finalCompletionBar = new GSlider(this, finalProgressLabel.getX() - 12, finalProgressLabel.getY() + 30, finalProgressLabel.getWidth(), 15, finalProgressLabel.getWidth());
    currentCompletionBar.setEnabled(false);
    finalCompletionBar.setEnabled(false);
    global.addControl(currentProgressLabel);
    global.addControl(finalProgressLabel);
    global.addControl(currentCompletionBar);
    global.addControl(finalCompletionBar);
}

public void initializeScheduleUIElements() {
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
}
