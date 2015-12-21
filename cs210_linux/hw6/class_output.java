/* 
   Paden Rumsey     hw6 
   CS270            class_output.java
*/ 
import java.io.*;
import java.lang.*;
import java.util.*;


/* this class acts as glorified 
   storage structure. there are three strings
   that are appended to every single time
   a string is passed over from uml2uni
*/

public class class_output{

    /* class name stores the appropriate class name 
       class parameters stores the list of parameters in 
       the correct format. Class methods stores methods 
       both ordinary and from associations
    */
    
    private String class_name;
    private String class_parameters;
    private String class_methods; 

    // no argument constructor
    
    public void class_output()
    {
	class_name = "";
	class_parameters = "";
	class_methods = ""; 

    }

    //argument constructor
    
    public void class_output(String name)
    {
	class_name = name;
	class_parameters = "";
	class_methods = "";
    }

    //sets class name
    
    public void set_name(String name)
    { 
	class_name = name;
    }

    //sets class name for aggregations, compositions, and associations
    public void set_weird_name(String name)
    {
	StringBuilder construct_string = new StringBuilder();

	construct_string.append("class ");
	construct_string.append(name);

	class_name = construct_string.toString();

    }

    //appends a superclass to the class string

    public void add_superclass(String superclass)
    {
	StringBuilder construct_string = new StringBuilder();

	construct_string.append(class_name);
	construct_string.append(" : ");
	construct_string.append(superclass);

	class_name = construct_string.toString(); 

    }

    //appends parameters to the parameter list

    public void add_parameters(String parameters)
    {
	StringBuilder construct_string = new StringBuilder();

	if(class_parameters != null)
	    {
		construct_string.append(class_parameters);
		construct_string.append(", ");
	    }
	construct_string.append(parameters);

	class_parameters = construct_string.toString(); 

    }

    //appends methods to the method listing
    
    public void add_methods(String methods)
    {
        StringBuilder construct_string = new StringBuilder();
	
	if(class_methods != null)
	    {construct_string.append(class_methods);}
	construct_string.append(System.getProperty("line.separator"));
	construct_string.append("   method "); 
	construct_string.append(methods);
	construct_string.append(System.getProperty("line.separator"));
	construct_string.append("   end"); 

	class_methods = construct_string.toString(); 
	
    }

    //add agg adds the method and parameter from
    // association to the appropriate string

    public void add_agg(String method, String param)
    {
	StringBuilder construct_string = new StringBuilder();
	
	if(class_methods != null)
	    {construct_string.append(class_methods);}
	construct_string.append(System.getProperty("line.separator"));
	construct_string.append("   ");
	construct_string.append(method);
	construct_string.append(System.getProperty("line.separator"));
	construct_string.append("      ");
	construct_string.append(param);
	construct_string.append(" := x"); 
	construct_string.append(System.getProperty("line.separator"));
	construct_string.append("   end");

	class_methods = construct_string.toString();
    }

    //adds the appropriate strings from a composition

    public void add_comp(String param)
    {
	StringBuilder construct_string = new StringBuilder();
	
	if(class_methods != null)
	    {construct_string.append(class_methods);}
	construct_string.append(System.getProperty("line.separator"));
	construct_string.append("   initially");
	construct_string.append(System.getProperty("line.separator"));
	construct_string.append("   ");
	construct_string.append(param);
	construct_string.append(" := ");
	construct_string.append(param);
	construct_string.append("()"); 
	construct_string.append(System.getProperty("line.separator"));
	construct_string.append("   end");

	class_methods = construct_string.toString();
    }


    //the three print functions were for testing purposes

    public void print_name()
    {
	System.out.println(class_name);
    }

     public void print_parameters()
    {
	System.out.println(class_parameters);
    }
     public void print_methods()
    {
	System.out.println(class_methods);
    }

    //this actually prints the file uml2uni.icn. It is called
    // from uml2uni for every hash entry and it appends to
    // the file as it goes. the keyword "true on new FileOutputStream
    // makes the appending possible. 

    public void print_file() throws FileNotFoundException, UnsupportedEncodingException
    {
	if(class_parameters == null)
	    class_parameters = "";
	if(class_methods == null)
	    class_methods = "";

	PrintWriter writer = new PrintWriter(new FileOutputStream( new File("uml2uni.icn"), true));
	class_parameters = String.format("%s(%s)", class_name, class_parameters);
	class_methods = String.format("%s\n", class_methods);
	writer.println(class_parameters);
	writer.println(class_methods);
	writer.println("end\n"); 
	writer.close();
	    
    }
}
    
