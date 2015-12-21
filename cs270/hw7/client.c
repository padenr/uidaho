/*
    C ECHO client example using sockets
*/

/****************** CLIENT CODE ****************/

#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <stdlib.h>
#include <time.h> 

char* concat(char *s1, char *s2); 

int main(){
  int clientSocket;
  char buffer[1000];
  struct sockaddr_in serverAddr;
  socklen_t addr_size;
  char input[1000]; 
  char message[1000] , server_reply[1000];
  time_t t; 
  srand((unsigned) time(&t));
  int gamenum = 1; 
  char gamenumber[1000];
  char final[1000];  

  /*---- Create the socket. The three arguments are: ----*/
  /* 1) Internet domain 2) Stream socket 3) Default protocol (TCP in this case) */
  clientSocket = socket(PF_INET, SOCK_STREAM, 0);

  /*---- Configure settings of the server address struct ----*/
  /* Address family = Internet */
  serverAddr.sin_family = AF_INET;
  /* Set port number, using htons function to use proper byte order */
  serverAddr.sin_port = htons(4501);
  /* Set IP address to localhost */
  serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
  /* Set all bits of the padding field to 0 */
  memset(serverAddr.sin_zero, '\0', sizeof serverAddr.sin_zero);  

  /*---- Connect the socket to the server using the address struct ----*/
  addr_size = sizeof serverAddr;

  connect(clientSocket, (struct sockaddr *) &serverAddr, addr_size);

  /*---- Read the message from the server into the buffer ----*/
  int flag = 0; 

  while(strcmp(message, "q") != 0)
    {
      
      do{

	flag = 0; 
	memset((message),0,strlen(message)); 
	printf("Enter your choice\n"); 
	scanf("%s", message); 
	
	if(strcmp(message, "q") != 0 && strcmp(message, "p") != 0 && strcmp(message, "r") != 0 && strcmp(message, "s") != 0)
	{
	  printf("Choice not accepted. Try again\n"); 
	  flag = 1; 
	}
	
	if(strcmp(message, "q") == 0)
	  {
	    send(clientSocket , "quit" , strlen("duck"), 0);
	    return 1; 
	  }
    }while(flag == 1);

      int player_choice = 5; 

      if(strcmp(message, "q") == 0)
	player_choice = 3; 
      if(strcmp(message, "r") == 0)
	player_choice = 0; 
      if(strcmp(message, "p") == 0)
	player_choice = 1; 
      if(strcmp(message, "s") == 0)
	player_choice = 2; 

      int winner = 5; 
      sprintf(gamenumber, "%d", gamenum);
      strcat(gamenumber, " "); 

      if(player_choice != 5 && player_choice != 3)
	{
	  winner = (3 + player_choice - (rand() % 3)) % 3; 	         
	}
      if(player_choice == 3)
	{
	  winner = 3; 
	}
    

      if(winner == 1)
	{
	  strcat(final, strcat(gamenumber, "player 1 wins!"));
	  
	  if (send(clientSocket , final , strlen(final) , 0) < 0)
	    {
	      puts("Send failed");
	      return 1;
	    }	  
	} 
      else if(winner == 2)
	{
	  strcat(final, strcat(gamenumber, "player 2 wins!"));
	  if( send(clientSocket , final , strlen(final) , 0) < 0)
	    {
	      puts("Send failed");
	      return 1;
	    }
	}
      else if(winner == 0)
	{
	  strcat(final, strcat(gamenumber, "is a tie!"));
	  if( send(clientSocket , final , strlen(final) , 0) < 0)
	    {
	      puts("Send failed");
	      return 1;
	    }
	}else if(winner == 3)
	  {
	    strcat(final, "quit");
	    if( send(clientSocket , final , strlen(final) , 0) < 0)
	      {
		puts("Send failed");
		return 1;
	      }	
	  }    
      else
	{
	  printf("Error"); 
	}
      
      gamenum++; 

      memset((message),0,strlen(message)); 
      memset((final),0,strlen(final)); 
      memset((gamenumber),0,strlen(gamenumber)); 
      memset((server_reply),0,strlen(server_reply));   
    }
  
  return 0;
}


