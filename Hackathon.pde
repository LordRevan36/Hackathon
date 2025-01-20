//imports
//these are all for the fileReader function
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
///import gui library
import interfascia.*;

//variables
ArrayList<Diploma> diplomas;
ArrayList<Course> courses;
User user;
    //arrays for the courses the user is taking each year, can check for prereqs by traversing the array to find if user has scheduled them
Course[] freshSched = new Course[14];
Course[] sophSched = new Course[14];
Course[] junSched = new Course[14];
Course[] senSched = new Course[14];
    //Global GUIController + a GUIController for each screen
GUIController global, schedule, courseList, diplomaRequirements;
    //stores which screen is on
String screen;
    //the "color theme" object, more to be added to color buttons etc.
IFLookAndFeel defaultLook;
    //global UI elements
IFButton scheduleButton, courseListButton, diplomaRequirementsButton;
IFProgressBar currentCompletion, finalCompletion;
IFLabel currentProgressLabel, finalProgressLabel;
    //schedule screen UI elements
IFButton freshmanButton, sophomoreButton, juniorButton, seniorButton, otherButton;


//settings
public void settings() {
    size(800,800);
}

//setup
public void setup() {
    diplomas = new ArrayList<Diploma>();
    courses = new ArrayList<Course>();
    setupCourses("CourseList.csv");
    for (Course course : courses) {
        System.out.println(course.courseToString(true));
    }
        //initializes to screen1 with screens 2 and 3 hidden
    global = new GUIController(this);
    schedule = new GUIController(this, true);
    courseList = new GUIController(this, false);
    diplomaRequirements = new GUIController(this, false);
    screen = "schedule";
    defaultLook = new IFLookAndFeel(this, IFLookAndFeel.DEFAULT);
        //initialize global UI elements
    scheduleButton = new IFButton("Schedule", 100, 100, 180, 40);
    courseListButton = new IFButton("Course List", 310, scheduleButton.getY(), scheduleButton.getWidth(), scheduleButton.getHeight());
    diplomaRequirementsButton = new IFButton("Diploma Requirements", 520, scheduleButton.getY(), scheduleButton.getWidth(), scheduleButton.getHeight());
    global.add(scheduleButton);
    global.add(courseListButton);
    global.add(diplomaRequirementsButton);
    currentCompletion = new IFProgressBar(125, 200, 250);
    finalCompletion = new IFProgressBar(425, currentCompletion.getY(), currentCompletion.getWidth());
    global.add(currentCompletion);
    global.add(finalCompletion);
    textSize(18);
    currentProgressLabel = new IFLabel("Current Diploma Completion", 125, 180, 18);//last parameter is textSize
    currentProgressLabel.setTextSize(18);//this also had no effect
    int fontWidth = (int) textWidth(currentProgressLabel.getLabel());
    currentProgressLabel.setX(currentProgressLabel.getX() + (250 - fontWidth)/2);
    finalProgressLabel = new IFLabel("Expected Diploma Completion", 425, currentProgressLabel.getY());
    fontWidth = (int) textWidth(finalProgressLabel.getLabel());
    finalProgressLabel.setX(finalProgressLabel.getX() + (250 - fontWidth)/2);
    global.add(currentProgressLabel);
    global.add(finalProgressLabel);
        //initialize schedule screen UI elements
    freshmanButton = new IFButton("Freshman", 140, 250, 100, 30);
    sophomoreButton = new IFButton("Sophomore", 245, freshmanButton.getY(), freshmanButton.getWidth(), freshmanButton.getHeight());
    juniorButton = new IFButton("Junior", 350, freshmanButton.getY(), freshmanButton.getWidth(), freshmanButton.getHeight());
    seniorButton = new IFButton("Senior", 455, freshmanButton.getY(), freshmanButton.getWidth(), freshmanButton.getHeight());
    otherButton = new IFButton("Other", 560, freshmanButton.getY(), freshmanButton.getWidth(), freshmanButton.getHeight());
    schedule.add(freshmanButton);
    schedule.add(sophomoreButton);
    schedule.add(juniorButton);
    schedule.add(seniorButton);
    schedule.add(otherButton);
    
}

//draw
public void draw() {
    background(255);
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

void actionPerformed (GUIEvent e) {
  
}
