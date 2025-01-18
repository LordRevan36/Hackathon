import java.util.ArrayList;
//variables
String name;
String subject; //ex: math, science, english
int weight; //0 = no weight, 1 = single weighted, 2 = double weighted
String specialClass; //stores whether a course is ib/ap/honors/acp
int gradeLevel; //grade level required for the class
ArrayList<String> prereqs; //stores list of prereqs
int numCredits; //stores number of credits a course is


//constructor
Course (String n, String s, int w, String sc, int g, int c){
    name = n;
    subject = s;
    weight = w;
    specialClass = sc;
    gradeLevel = g;
    numCredits = c;
}

//behaviours
