//imports
//this is to import the lazygui library if we want it
//import com.krab.lazy.*;
//these are all for the fileReader function
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

//variables
ArrayList<Diploma> diplomas;
ArrayList<Course> courses;
User user;


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
}

//draw
public void draw() {

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