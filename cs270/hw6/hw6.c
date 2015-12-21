/*
  Paden Rumsey       CS_270
  11/17/2015         hw5
*/

#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <sys/types.h>
#include <dirent.h>
#include <limits.h>
#include <sys/stat.h>
#include <sys/uio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <fcntl.h>

void ls_dirtime(DIR *dir, struct dirent *dirent, struct stat fileStat, char *currDir); 
int ls_filetype(DIR *dir, struct dirent *dirent, struct stat fileStat, char *currDir);  /*file type funciton */  /* prints files and times */ 
int is_ascii(char *contents); 

int main(int argc, char *argv[]) {

  DIR *dir;                   /*pointer to Dir*/
  struct dirent *dirent;     /* struct for the directory entry */
  char cwd[1024];            /* char to hold the current directory */ 
  struct stat fileStat;     /* struct for filestat */ 
  
  if (getcwd(cwd, sizeof(cwd)) == NULL)  /*get current working directory */ 
    perror("getcwd() error");
   
   
  if (NULL == (dir = opendir(cwd))) {   /* open the diretory */ 
     fprintf(stderr,"%d (%s) opendir %s failed\n", errno, strerror(errno), cwd);
     return 2;
   }

  

  if(argv[1] == NULL) /*if 2nd argument is null o file options execute regular ls */ 
     {
       while (NULL != (dirent = readdir(dir)))
	 {
	   if(strcmp(dirent->d_name, ".") != 0 && strcmp(dirent->d_name, "..") != 0) /* use a string comparison to not read directory "." and ".." */  
	     {                                                                       /* since regular ls command does not read those */
	       printf("%s\n", dirent->d_name);                                       /* print the directory entry */ 
	     }
	 }
     }
  else if(strcmp(argv[1], "-t") == 0) /* see if the -t command is used */ 
     {
       ls_dirtime(dir, dirent, fileStat, cwd); /* if it is call the function dirtime to print */ 
     }                                        /* filenames and times */ 
  else if(strcmp(argv[1], "-f") == 0)        /* same thing except for file type */ 
     {
       ls_filetype(dir, dirent, fileStat, cwd);
     }
   else
     {
       printf("That file extension is not recognized.\n"); /* an unrecognized command was entered */ 
     }
 
}

void ls_dirtime(DIR *dir, struct dirent *dirent, struct stat fileStat, char *currDir) /* prints files and times */ 
{

  currDir = strcat(currDir, "/"); /* technique to get absolute path append / */ 
  
  while (NULL != (dirent = readdir(dir))) /* while there are more entries to be read */ 
    {
      if(strcmp(dirent->d_name, ".") != 0 && strcmp(dirent->d_name, "..") != 0) /*compare strings to not get "." or ".." file */ 
	{
	  
	  char path[1024]; /*store the absolute path */ 
	  
	  strcpy(path, currDir); /* copy the curr Directory path */ 
	  strcat(path, dirent->d_name); 	  /* append the name on to get absolute path */ 
	  
	  if(stat(path, &fileStat) == -1) /* get file descriptions or fail */ 
	    {
	      perror("stat");
	      exit(EXIT_FAILURE);
	    }
	  printf("File Name - %s \nLast Status Change -  %sLast Access Time   -  %sLast Modified Time -  %s \n", dirent->d_name, ctime(&fileStat.st_ctime), ctime(&fileStat.st_atime), ctime(&fileStat.st_mtime));  /* got file names now print in a loop */ 
	   
	  memset(path, 0, 255); /*clear the path pointer */  
	}
    }
}

int ls_filetype(DIR *dir, struct dirent *dirent, struct stat fileStat, char *currDir) /*file type funciton */ 
{

  currDir = strcat(currDir, "/");      /*append the / on to get absolute path */ 
  printf("File Name - File Type \n"); 
  
  while (NULL != (dirent = readdir(dir))) /* while more dir entires */ 
    {
      if(strcmp(dirent->d_name, ".") != 0 && strcmp(dirent->d_name, "..") != 0)
	{

	  int file;          /* stores file descriptor int */ 
	  char path[1024];  /* stores absolute path */ 
	  const char *ret;  /*stores substring of str str or null pointer */ 
	  
	  strcpy(path, currDir);
	  strcat(path, dirent->d_name);  /*concatenate absolute path */ 
	  
	
	  char data[1000];   /*to store the stuff from file */ 
	  int readingerror;  /*stores the reading error number */ 
	  FILE *fp;         /* file pointer to fgets */ 
	  
	  fp = fopen(path, "r"); /*open with absolute path */ 
	  
	  if(fgets(data, 100, fp) == NULL) /* check for successful open */ 
	    {
	      printf("%s", path); 
	      perror("Error opening file");
	      return(-1); 
	    }
	  else if((ret = strstr(data, "%!PS-Adobe")) != NULL) /* if te %!PS-Adobe was found in file then assume PDF */ 
	    {
	      printf("%s - %s\n", dirent->d_name, "Postscript File"); /*print out name and file type */ 
	      }
	  else if((ret = strstr(data, "\r\n")) != NULL) /*if a return carriage then new line was found assume DOS file */ 
	    {
	      printf("%s - %s\n", dirent->d_name, "DOS File");
	    }
	  else if((data[0] == 127) && (data[1] == 'E') && (data[2] == 'L') && (data[3] == 'F')) /* if 127 is first byte then next three are ELF then ELF */ 
	    {
	      printf("%s - %s\n", dirent->d_name, "ELF File");
	    }
	  else if((is_ascii(data)) == 1) /* call funciton to iterate through byte to check if regular file */ 
	    {
	      printf("%s - %s\n", dirent->d_name, "Regular File");
	    }
	  else
	    {
	      printf("%s - %s\n", dirent->d_name, "Unidentifiable Binary File");  /* if not any of those then its unidentifiable */ 
	    }
	 
	  
	  memset(path, 0, 255);  /* clear path */ 
	}
    }
}


int is_ascii(char *contents)
{

  int i;

  
  for(i = 0; i < strlen(contents); i++) /* loop through array checking characters that might be bigger than 127 */ 
    {
      if(contents[i] > 127)
	{
	  return -1; /* if there are return a negative one to get false */ 
	}
    }
  
  return 1;   
}

 
