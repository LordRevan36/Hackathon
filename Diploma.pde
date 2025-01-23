public class Diploma {
    // Attributes: name, different subjects required, total number of credits required
    String name;
    ArrayList<Subject> subjects;
    int totalCreditsRequired;

    public Diploma(String name) {
        this.name = name;
        subjects = new ArrayList<Subject>();
        totalCreditsRequired = 0;
    }

    public void parseDiploma(String fileName, ArrayList<Course> allCourses) {
        try {
            // Read all lines into a list of strings
            String filePath = sketchPath(fileName); // Replace with correct method to get the file path
            File file = new File(filePath);

            System.out.println("File exists: " + file.exists());
            System.out.println("File absolute path: " + file.getAbsolutePath());
            System.out.println("Working Directory: " + Paths.get("").toAbsolutePath());

            List<String> lines = Files.readAllLines(Paths.get(filePath));
            String temp;

            // Use each line
            for (String line : lines) {
                if (line.startsWith("name")) { // Skip header line
                    continue;
                }

                // Split the line into columns based on the commas between fields
                String[] fields = line.split(",");

                // Create a new Subject object using the first column
                String subjectName = fields[0].trim();
                subjects.add(new Subject(subjectName));
                int lastSubjectIndex = subjects.size() - 1;

                // Iterate through the remaining columns for this subject
                for (int fieldIndex = 1; fieldIndex < fields.length; fieldIndex++) {
                    String field = fields[fieldIndex].trim();

                    // Start parsing each field
                    while (true) {
                        int colonIndex = field.indexOf(":");
                        if (colonIndex == -1) {
                            System.out.println("Invalid format in field: " + field);
                            break; // Exit the loop if format is invalid
                        }

                        // Extract subcategory name
                        String subcategoryName = field.substring(0, colonIndex).trim();

                        // Move past the subcategory name and get the number of credits
                        field = field.substring(colonIndex + 1);
                        colonIndex = field.indexOf(":");
                        if (colonIndex == -1) {
                            System.out.println("Invalid format in field: " + field);
                            break; // Exit the loop if format is invalid
                        }

                        // Extract the number of credits
                        int credits = Integer.parseInt(field.substring(0, colonIndex).trim());

                        // Create a new RequiredCourses object
                        RequiredCourses requiredCourse = new RequiredCourses(subcategoryName);
                        requiredCourse.numRequired = credits;

                        // Add the RequiredCourses object to the current subject
                        subjects.get(lastSubjectIndex).requiredCourses.add(requiredCourse);
                        subjects.get(lastSubjectIndex).numRequired += credits;

                        // Move past the credits to process the course and category list
                        field = field.substring(colonIndex + 1);

                        // Separate classes and categories by '|'
                        String[] classCategoryParts = field.split("\\|");
                        String classesPart = classCategoryParts[0].trim();
                        String categoriesPart = classCategoryParts.length > 1 ? classCategoryParts[1].trim() : "";

                        // Process individual classes
                        String[] classNames = classesPart.split(";");
                        for (String className : classNames) {
                            className = className.trim();
                            boolean courseFound = false;

                            // Look for the class in allCourses
                            for (Course course : allCourses) {
                                if (course.name.equals(className)) {
                                    requiredCourse.courses.add(course);
                                    courseFound = true;
                                    break;
                                }
                            }

                            // Log if the course wasn't found
                            if (!courseFound && !className.isEmpty()) {
                                System.out.println("Course \"" + className + "\" not found during " + name + " search");
                            }
                        }

                        // Process categories
                        String[] categoryNames = categoriesPart.split(";");
                        for (String categoryName : categoryNames) {
                            categoryName = categoryName.trim();
                            if (!categoryName.isEmpty()) {
                                requiredCourse.categories.add(categoryName);
                            }
                        }

                        // Move to the next portion of the field
                        int nextDelimiterIndex = field.indexOf(",");
                        if (nextDelimiterIndex == -1) {
                            break; // Exit the loop when there are no more fields
                        }
                        field = field.substring(nextDelimiterIndex + 1).trim();
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
