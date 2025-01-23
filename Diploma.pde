public class Diploma {
    /*attributes: name, different subjects required,
    total number of credits required
    */
    String name;
    ArrayList<Subject> subjects;
    int totalCreditsRequired;

    public Diploma(String name) {
        this.name = name;
        subjects = new ArrayList<Subject>();
        totalCreditsRequired = 0;   
    }
}