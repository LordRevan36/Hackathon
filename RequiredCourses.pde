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

    public String toString(int courseNumLimit) {
        String result = name + " (" + numRequired + "): ";
        int num = 0;
        for (String category : categories) {
            result += category + ", ";
            num++;
            if (num >= courseNumLimit) {
                if (courseNumLimit == categories.size()) {
                    return result.substring(0,result.length() - 2);
                }
                return result + "and more";
            }
        }
        for (Course course : courses) {
            result += course.name + ", ";
            num++;
            if (num >= courseNumLimit) {
                result += "and more--";
                break;
            }
        }
        String temp = result;
        result = temp.substring(0, temp.length() - 2);
        return result;
    }
    
    

}
