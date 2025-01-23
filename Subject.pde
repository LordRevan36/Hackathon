public class Subject {
    //attributes : name of category, number of courses, courses that count toward category
    String name;
    int numRequired;
    ArrayList<RequiredCourses> requiredCourses;

    public Subject(String name) {
        this.name = name;
        numRequired = 0;
        requiredCourses = new ArrayList<RequiredCourses>();
    }

}
