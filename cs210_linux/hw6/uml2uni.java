/*  Paden Rumsey         CS_210 
    hw6                  12/07/15
    uml2uni.java
*/ 

import java.io.*;
import java.lang.*;
import java.util.*;


/* There are two main class of which this is the first. This primarily
   does the tokenizing of the file. It takes the strings. Identifies them
   then tokenizes them some more.
*/

public class uml2uni{

    /* output is a Hash that stores my own defined class_output objects class_output is 
       the second class I made. object_count is the array counter for classes which is 
       an array that helps create new objects to be stored in the hash. It arbitrarily large.
       Method count and param_count track how many compositions and aggregations there are
       so I can append the appropriate string count onto params and methods
       current_class stores the class name that was previously stored in the hash so the program
       knows what line currently should go to what place in the hash map. 
    */  
    
    private HashMap<String, class_output> output = new HashMap<String, class_output>(); 
    private int object_count = 0;
    private class_output[] classes = new class_output[500];
    private String current_class = null;
    private int method_count = 0;
    private int param_count = 0;
    
    public static void main(String []args) throws IOException
    {
        uml2uni object = new uml2uni(); //create object to use non-static variables

	for(int i=0; i < 500; i++)
	    {
		object.classes[i] = new class_output(); //populate array with my objects

	    }

	
	object.line_reader(args[0]); //declare a line reader with file neame

	
	for (Map.Entry<String, class_output> entry : object.output.entrySet())
	    {
		entry.getValue().print_file(); //when everything is stored call a print method for each object
	    }
	
    }

    /* this opens the file to be read and read line by line*/ 
   
    public void line_reader(String file) throws IOException,FileNotFoundException
    {
	
	    BufferedReader br = new BufferedReader(new FileReader(file)); 
	    String line;
	    while ((line = br.readLine()) != null) {
		line = line.trim();
		line = line.replaceAll("\"([\\*]*)\"", "");
	        tokenizer(line);  
	    }
    }

    /* this function identifies the type of string that the line
       is and sends it to the appropriate funciton to be be further
       tokenized and stored
    */ 

    public void tokenizer(String uml_line)
    {
	String outcome = "nothing";
	
	if(uml_line.matches("class ([A-Za-z\"]+(\\{*| \\{*))")) 
	    {class_tokenizer(uml_line);}
	else if(uml_line == "\\{")
	    {/* do nothing */}
	else if(uml_line.matches("([A-Za-z_.0-9 \"]+) <\\|-- ([A-Za-z_.\"0-9 ]+)"))
	    {superclass_tokenizer(uml_line);}
	else if(uml_line.matches("(\\s*[A-Za-z_.0-9 \"]+) : ([A-Za-z_.0-9 \"]+)"))
	    {parameter_tokenizer(uml_line);}
	else if(uml_line.matches("(\\+*-*[A-Za-z_.0-9, \"]+)\\(([A-Za-z_,\\.\\s]*)\\)"))
	    {method_tokenizer(uml_line);}
	else if(uml_line.matches("([A-Za-z_.0-9 \"]+) : ([A-Za-z_.0-9 \"]*)\\(([A-Za-z_,\\.\\s]*)\\)"))
	    {method_tokenizer(uml_line);}
	else if(uml_line.matches("([A-Za-z_.0-9 \"]+) (o--|o-left-|o-right-|o-up-|o-down-) ([A-Za-z_.0-9 \"]+)"))
	    {aggregation_tokenizer(uml_line);}
	else if(uml_line.matches("([A-Za-z_.0-9 \"]+) (\\*--|\\*-left-|\\*-right-|\\*-up-|\\*-down-) ([A-Za-z_.0-9 \"]+)"))
	    {composition_tokenizer(uml_line);}
	else if(uml_line.matches("([A-Za-z_.0-9 \"]+) (o--|o-left-|o-right-|o-up-|o-down-) ([A-Za-z_.0-9 \"]*) : ([A-Za-z_.0-9]+)"))
	    {aggregation_tokenizer(uml_line);}
	else if(uml_line.matches("([A-Za-z_.0-9 \"]+) (\\*--|\\*-left-|\\*-right-|\\*-up-|\\*-down-) ([A-Za-z_.0-9 \"]+) : ([A-Za-z_.0-9]+)"))
	    {composition_tokenizer(uml_line);}
	else if(uml_line.matches("([A-Za-z_.0-9 \"]+) (--|-left-|-right-|-up-|-down-) ([A-Za-z_.0-9 \"]+) : ([A-Za-z_.0-9]+)"))
	    {agg_label_tokenizer(uml_line, "AGG_DASH");}
	else if(uml_line.matches("([A-Za-z_. \"0-9]+) (-->|-left->|-right->|-up->|-down->) ([A-Za-z_. \"0-9]+) : ([A-Za-z_.0-9]+)"))
	    {agg_label_tokenizer(uml_line, "AGG_ARROW");}
	else
	    {/*do nothing with line if no match*/}

	
	       
    }

    /*all of the "blank_tokenizer" classes follow a similar organization
      clean the line of everything I don't want (spaces, commas, brackets)
      then grab the appropriate pieces (class names, superclass names, param names)
      and then store those pieces in objects in my hash using functions from the second
      class class_output */
    
    public void class_tokenizer(String class_line)
    {

        class_line = class_line.replaceAll(" \\{", "");
	class_line = class_line.replaceAll("[\"\\{]", "");
        String hash_name = class_line.replaceAll("class ", "");

	
	try{
	    output.put(hash_name, classes[object_count]);

	    output.get(hash_name).set_name(class_line);

	    object_count++; //increase object count to get new object reference 
    
	}catch (NullPointerException e)
	    {
		System.out.println("Error in class tokenizer \n");
	    }

	current_class = hash_name; //the current class becomes the one just stored
    }

    /* same as class_tokenizer with slightly different tokenizing and
       different functions from other class called */
    
    public void parameter_tokenizer(String parameter_line)
    {
        parameter_line = remove_quotes(parameter_line);
    
	String c_name = get_first(parameter_line, "PARAMETER");
	String p_name = null;
	
	if(output.get(c_name) != null)
	    {
		p_name = get_latter(parameter_line, "PARAMETER");
		output.get(c_name).add_parameters(p_name); 
	    }
	else
	    {
		p_name = get_first(parameter_line, "PARAMETER");
		output.get(current_class).add_parameters(p_name); 
	    }

    }

    /* same as class_tokenizer with slightly different tokenizing and
       different functions from other class called */
    
    public void method_tokenizer(String method_line)
    {
        method_line = method_line.replaceAll("\\+ ", "");
	method_line = method_line.replaceAll("\\- ", "");

	String c_name = get_first(method_line, "METHOD");
	String m_name = null;
	
	if(output.get(c_name) != null)
	    {
		m_name = get_latter(method_line, "METHOD");
		output.get(c_name).add_methods(m_name); 
	    }
	else
	    {
		m_name = get_first(method_line, "METHOD");
		output.get(current_class).add_methods(m_name); 
	    }
    }

    /* same as class_tokenizer with slightly different tokenizing and
       different functions from other class called */

    public void superclass_tokenizer(String s_class_line)
    {
	s_class_line = remove_quotes(s_class_line);
	String c_name = get_latter(s_class_line, "SUPERCLASS");
	String superclass = get_first(s_class_line, "SUPERCLASS");

	output.get(c_name).add_superclass(superclass); 
	
    }

    /* this one requireds more work than the others simply
       because I need to be able to tokenize more specificly
       I need to grab both classes and then send those to 
       a corresponding function in class_output*/

    /* SIDE NOTE: Completely forgot about String.format so there are lots of 
       stringbuilder lines in this. I could have shortened the code massively
       Hind sight is 20/20
    */ 

    public void aggregation_tokenizer(String agg_line)
    {
	agg_line = remove_for_agg(agg_line);

	String c_name = get_first(agg_line, "AGGREGATION"); //call function with appropriate "type"
	String agg_name = get_latter(agg_line, "AGGREGATION");
	StringBuilder construct_param = new StringBuilder();

	construct_param.append(agg_name);                       //create appropriate output for storage
	construct_param.append("_");
	construct_param.append(Integer.toString(param_count));

	String param = construct_param.toString(); 

	param_count++;

	StringBuilder construct_method = new StringBuilder(); 

	construct_method.append("method link_");
	construct_method.append(agg_name);
	construct_method.append("_");
	construct_method.append(Integer.toString(method_count)); 
	construct_method.append("(x)");

	String method = construct_method.toString();

	method_count++;

	//if the hash name already exists then just add a param
        // if not create a new class and add the param
  
	if(output.get(c_name) != null)
	    {
		agg_name = get_latter(agg_line, "AGGREGATION");
		output.get(c_name).add_agg(method, param);
		output.get(c_name).add_parameters(param); 
	    }
	else
	    {
		agg_name = get_first(agg_line, "AGGREGATION"); 
		output.put(c_name, classes[object_count]);
		output.get(c_name).set_weird_name(c_name);
		current_class = c_name;
		object_count++;
		output.get(c_name).add_parameters(param);
		output.get(c_name).add_agg(method, param); 
	    }
    }

    /* follows the same basic outline as the aggregation tokenizer */ 

     public void composition_tokenizer(String comp_line)
    {
	comp_line = remove_for_agg(comp_line);

	String c_name = get_first(comp_line, "COMPOSITION");
	String comp_name = get_latter(comp_line, "COMPOSITION");

	StringBuilder construct_param = new StringBuilder();

	construct_param.append(comp_name);
	construct_param.append("_");
	construct_param.append(Integer.toString(param_count));

	String param = construct_param.toString();

	param_count++;
  
	if(output.get(c_name) != null)
	    {
		comp_name = get_latter(comp_line, "COMPOSITION");
		output.get(c_name).add_parameters(param);
		output.get(c_name).add_comp(param); 
	    }
	else
	    {
		comp_name = get_first(comp_line, "COMPOSITION"); 
		output.put(c_name, classes[object_count]);
		output.get(c_name).set_weird_name(c_name);
		current_class = c_name; 
		object_count++;
		output.get(c_name).add_parameters(param);
		output.get(c_name).add_comp(param); 
	    }
    }

    /* follows the same basic method as the aggregation tokenizer except
       this one has to define a method to be stored as well */ 

    public void agg_label_tokenizer(String agg_line, String type)
    {

	agg_line = remove_quotes(agg_line);
	String label = get_label(agg_line, type); 
	agg_line = remove_label(agg_line);
	String c_name = get_first(agg_line, type);
	String agg_name = get_latter(agg_line, type);


	StringBuilder construct_param = new StringBuilder();

	construct_param.append("label_"); 
	construct_param.append(agg_name);
	construct_param.append("_");
	construct_param.append(Integer.toString(param_count));

	String param = construct_param.toString(); 

	param_count++;

	StringBuilder construct_method = new StringBuilder();

	construct_method.append("method link_");
	construct_method.append(label);
	construct_method.append("_"); 
	construct_method.append(agg_name);
	construct_method.append("_");
	construct_method.append(Integer.toString(method_count)); 
	construct_method.append("(x)");

	String method = construct_method.toString(); 

	method_count++; 
  
	if(output.get(c_name) != null)
	    {
		agg_name = get_latter(agg_line, type);
		output.get(c_name).add_agg(method, param);
		output.get(c_name).add_parameters(param); 
	    }
	else
	    {
		agg_name = get_first(agg_line, type); 
		output.put(c_name, classes[object_count]);
		output.get(c_name).set_weird_name(c_name);
		current_class = c_name; 
		object_count++;
		output.get(c_name).add_parameters(param);
		output.get(c_name).add_agg(method, param); 
	    }
    }

    /* remove all the "bad" things for aggregation */
    
    public String remove_for_agg(String bad_line)
    {
	String good_line = bad_line.replaceAll("\".*?\" ", "");
	good_line = good_line.replaceAll(" : ([A-Za-z_\\. \"0-9]*)", "");

	return good_line;

    }

    /* removes everything between two quotes and all * in a quoted
       line. There were some files with * in the quoted items
    */ 

    public String remove_quotes(String bad_line)
    {
        String good_line = bad_line.replaceAll("\\*", ""); 
	good_line = bad_line.replaceAll("\".*?\"\\s", "");

	return good_line;
    }

    /* the functions get_first and get_latter get the names of
       classes associated with compositions, aggregations, and 
       user-defined associations as well as parameter and method names
       the function is called with the appropriate type
    */ 
    
    public String get_first(String line, String type)
    {
	switch(type) {
	case "PARAMETER": 
	    line = line.replaceAll("\\s: ([A-Za-z_\\.\\s\"0-9]*)", "");
	    break;
	case "METHOD":
	    line = line.replaceAll("\\s: ([A-Za-z_\\.\\s\"0-9,]*)\\(([A-Za-z_,\\.\\s]*)\\)", "");
	    break;
	case "AGGREGATION":
	    line = line.replaceAll("\\s(o--|o-left-|o-right-|o-up-|o-down-)(\\s[A-Za-z_\\.\"0-9]*)", "");
	    break;
	case "COMPOSITION":
	    line = line.replaceAll("\\s(\\*--|\\*-left-|\\*-right-|\\*-up-|\\*-down-) ([A-Za-z_\\.\\s\"0-9]*)", "");
	    break;
	case "AGG_DASH":
	    line = line.replaceAll("\\s(--|-left-|-right-|-up-|-down-) ([A-Za-z_\\.\\s\"0-9]*)", "");
	    break;
	case "AGG_ARROW":
	    line = line.replaceAll("\\s(-->|-left->|-right->|-up->|-down->) ([A-Za-z_\\.\"0-9]*)", "");
	    break;
	case "SUPERCLASS":
	    line = line.replaceAll("\\s(<\\|--|<\\|<\\|-left-|<\\|-right-|<\\|-up-|<\\|-down-) ([A-Za-z_\\.\\s\"0-9]*)", "");
	    break;
	}
	    
	    return line;
    }

    
    public String get_latter(String line, String type)
    {
	
	switch(type) {
	case "PARAMETER": 
	    line = line.replaceAll("([A-Za-z_\\.\\s\"0-9]*\\(*\\)) :\\s", "");
	    break;
	case "METHOD":
	    line = line.replaceAll("([A-Za-z_\\.\\s\"0-9,]*) :\\s", "");
	    break;
	case "AGGREGATION":
	    line = line.replaceAll("([A-Za-z_\\.\\s\"0-9]*) (o--|o-left-|o-right-|o-up-|o-down-)\\s", "");
	    break;
	case "COMPOSITION":
	    line = line.replaceAll("([A-Za-z_\\.\\s\"0-9]*) (\\*--|\\*-left-|\\*-right-|\\*-up-|\\*-down)\\s", "");
	    break;
	case "AGG_DASH":
	    line = line.replaceAll("([A-Za-z_\\.\\s\"0-9]*) (--|-left-|-right-|-up-|-down-) ", "");
	    break;
	case "AGG_ARROW":
	    line = line.replaceAll("([A-Za-z_\\.\\s\"0-9]*) (-->|-left->|-right->|-up->|-down->) ", ""); 
	    break; 
	case "SUPERCLASS":
	    line = line.replaceAll("([A-Za-z_\\.\\s\"0-9]*) (<\\|--|<\\|<\\|-left-|<\\|-right-|<\\|-up-|<\\|-down-)\\s", "");
	    break;
	}
	return line;
    }

    /* this function gets the label off of the appropriate user-defined associations */ 
    
    public String get_label(String line, String type)
    {
	if(type == "AGG_ARROW")
	    {
		line = line.replaceAll("([A-Za-z0-9_\\.]*) (-->|-down->|-left->|-right->|-up->) ([A-Za-z0-9_\\.]*) : ", "");
	    }
	else
	    {
		line = line.replaceAll("([A-Za-z0-9_\\.]*) (--|-left-|-right-|-up-|-down-) ([A-Za-z0-9_\\.]*) : ", "");
	    }
		
	return line;
	
    }

    /*this function removes labels from strings */
    
    public String remove_label(String line)
    {
	line = line.replaceAll("\\s:\\s([A-Za-z0-9_\\.]*)", "");
	return line;
    }
}
