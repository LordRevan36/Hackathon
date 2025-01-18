import java.util.ArrayList;
//variables
String name;
String subject; //ex: math, science, english
int weight; //0 = no weight, 1 = single weighted, 2 = double weighted
String specialClass; //stores whether a course is ib/ap/honors/acp
int gradeLevel; //grade level required for the class
ArrayList<String> prereqs; //stores list of prereqs
int numCredits; //stores number of credits a course is
public class Course {
    //variables
    String name;
    String subject; //ex: math, science, english
    int weight; //0 = no weight, 1 = single weighted, 2 = double weighted
    String specialClass; //stores whether a course is ib/ap/honors/acp
    int gradeLevel; //grade level required for the class
    String[] prereq; //stores list of prereq classes
    int numCredits; //stores number of credits a course is
    String description; //stores official description to display upon "more info" request

    //SOMETHING TO THINK ABOUT: for prereq classes, how do we differentiate between the concurrent enrollment requirement and the total completion requirement?

//constructor
Course (String n, String s, int w, String sc, int g, int c){
    name = n;
    subject = s;
    weight = w;
    specialClass = sc;
    gradeLevel = g;
    numCredits = c;
}
    //constructor
    public Course(String name, String subject, int weight, String specialClass, int gradeLevel, int prereqSize, int numCredits, String description) {
        this(name, subject, weight, specialClass, gradeLevel, numCredits, description);
        prereq = new String[prereqSize];
    }
    //another constructor but without creating the array at all
    public Course(String name, String subject, int weight, String specialClass, int gradeLevel, int numCredits, String description) {
        this.name = name;
        this.subject = subject;
        this.weight = weight;
        this.specialClass = specialClass;
        this.gradeLevel = gradeLevel;
        this.numCredits = numCredits;
        this.description = description;
    }
    //default constructor for overriding values after creation
    public Course(String name) {
        //this calls another constructor matching the parameters enters
        this(name, "none", 0, "none", 0, 0, "none");
    }

    

    //behaviours

    //can be used to debug stuff with creating courses
    public String courseToString(boolean desc) {
        String weightWord;
        switch (weight) {
            case 0:
                weightWord = "Unweighted";
                break;
            case 1:
                weightWord = "Single-Weighted";
                break;
            case 2:
                weightWord = "Double-Weighted";
                break;
            default:
                weightWord = "Unweighted";
                break;
        }
        String prereqsAsString = "";
        for (String req : prereq) {
            prereqsAsString += req + ", ";
        }
        String result = name + " (" + subject + "), " + weightWord + ", " + specialClass + ", Grade: " + gradeLevel + "+, Prereqs: " + prereqsAsString + numCredits + " credits.";
        if (desc) {
            result += "\nDescription: " + description;
        }
        return result;
    }
}