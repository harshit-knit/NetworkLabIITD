#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<errno.h>
#include<signal.h>
#include"service.h"
#include<sys/socket.h>
#include<arpa/inet.h>
#include<semaphore.h>
#define PORT 30000
#define QUEUE 1000
#define BUF_SIZE 255
/**
semaphore used for mutual exclusive excess to file
*/
sem_t sem;
/**
Socket Descriptor Identifier
*/
int listener_id;
/** 
Signal Handler for QueryServer
*/
int catch_signal(int sig,void (*handler)(int))
{
	struct sigaction action;
	action.sa_handler=handler;
	sigemptyset(&action.sa_mask);
	action.sa_flags=0;
	return sigaction(sig,&action,NULL);
}
/**
this function is used for shuting down the Query Server
*/
void handle_shutdown(int sig)
{
	if(listener_id)
		shutdown(listener_id,2);
	fprintf(stderr,"Bye...Shutting Down FTP Server");
	exit(EXIT_SUCCESS);
}
/**
This is main function in this query server is implemented

*/
int main()
{
	sem_init(&sem,1,1);	
	int serr=catch_signal(SIGINT,handle_shutdown);
	if(serr==-1)
	{
		error("can't register Handle");
	}	
	listener_id=open_listener_socket();
	
	bind_to_port(listener_id,PORT);
	int lerr=listen(listener_id,QUEUE);
	if(lerr==-1)
	{
		error("can't listen on socket");
	}
	
	struct sockaddr_storage client_address;
	unsigned int address_size=sizeof(client_address);
	fprintf(stderr,"Waiting for connection\n");
	char buf[BUF_SIZE];
	while(1)
	{
		int connect_id=accept(listener_id,(struct sockaddr*)&client_address,&address_size);
		
		if(connect_id==-1)
		{
			error("can't open secondary socket\n");
		}
		pid_t pid=fork();
		if(pid==-1)
		{
			error("can't fork child process\n");
		}
		else if(pid==0)
		{	
			close(listener_id);
			//fprintf(stderr,"client_id  %d connected\n",connect_id);
			say(connect_id,"Welcome to QUERY  SERVER v1.0\r\n");
			
			while(1){
			say(connect_id,"QUERY$ ");
			memset(buf,sizeof(buf),0);
			hear(connect_id,buf,sizeof(buf));
			 char res[BUF_SIZE];
			memset(buf,sizeof(res),0);
			remove_spaces(buf,res);
			int code=find_command(res);
			
			fprintf(stdout,"code %d ||command %s\n",code,res);
			char * pch=NULL;
			char  name[40],entry[40],email[40];
			memset(buf,sizeof(name),0);
			memset(buf,sizeof(entry),0);
			memset(buf,sizeof(email),0);
			switch(code)
			{
				case -1:say(connect_id,"Wrong Command \r\n");
					break;
				case 1:	
  					pch= strtok (res," ");
					pch = strtok (NULL, " ");
					searchByName(pch,connect_id);
					break;
				case 2:	 pch=NULL;
  					pch= strtok (res," ");
					pch = strtok (NULL, " \r\n");
					searchByEntry(pch,connect_id);					
					break;
				case 3:  pch=NULL;
  					pch= strtok (res," ");
					pch = strtok (NULL, " ");
					searchByYear(pch,connect_id);
					break;
				case 4: pch=NULL;
					int count=0;
					pch= strtok (res," ");
  					while (pch != NULL)
  					{
   						  pch = strtok (NULL, " ");
						if(count==0)
						strcpy(name,pch);
						if(count==1)	
						strcpy(entry,pch);
						if(count==2)
						strcpy(email,pch);
						count++;
  					}
					if(count!=4)
						say(connect_id,"Column mismatch \r\n");
					else
					{
						sem_wait(&sem);
						addRecord(name,entry,email,connect_id);
						sem_post(&sem);
					}
					break;
				case 5: say(connect_id,"You are being disconnected from server \r\n");
					exit(EXIT_SUCCESS);
			}
			}
			//fprintf(stderr,"client_id  %d disconnected\n",connect_id);
		}
		else
		{
			close(connect_id);
		}
	}
	return 0;
}
