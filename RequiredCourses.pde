public class RequiredCourses {
    String name;
    int numRequired;
    ArrayList<Course> courses;
    ArrayList<String> categories;

    public RequiredCourses(String name) {
        this.name = name;
        numRequired = 0;
        courses = new ArrayList<Course>();
        categories = new ArrayList<String>();
    }

}