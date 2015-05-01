#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<errno.h>
#include<signal.h>
#include<ctype.h>
#include<sys/socket.h>
#include<arpa/inet.h>
#include<semaphore.h>
#include"service.h"
/**
 Defines the The Size of Buffer
*/
#define BUF_SIZE 255
/**
  This function is used for printing error message to stderr stream
@param msg it is pointer to the error mesaage
*/	
void error(char *msg)
{
	fprintf(stderr,"%s %s\n",msg,strerror(errno));
	exit(EXIT_FAILURE);
}
/**
This function is used for Case-Insesitive Comparision of string pointed by pStr1 and pStr2
upto length of Count Character
@param pStr1 pointer to first string
@param pStr2 pointer to second string
*/
int strnicmp(const char *pStr1, const char *pStr2, size_t Count)
{
    char c1, c2;
    int  v=0;

    if (Count == 0)
        return 0;

    do {
        c1 = *pStr1++;
        c2 = *pStr2++;
        
        v = tolower(c1) - tolower(c2);
    } while ((v == 0) && (c1 != '\0') && (--Count > 0));

    return v;
}
/**
This function is used for creating socket descriptor 
@return handle of socket
*/
int open_listener_socket()
{
	int s=socket(AF_INET,SOCK_STREAM,0);
	if(s==-1)
	{
		error("can't open socket");
	}
	return s;
}
/** 
this function is used for returning a string from which spaces has been removed
@param input original string
@param result final string
*/ 
void remove_spaces(const char *input, char *result)
{
  int i=0, j = 0;	
while(input[i]==' ')
	i++;
  for (; input[i] != '\0'; i++) {
     result[j++] = input[i];}
  
  result[j] = '\0';
}
/** 
this function is used for binding socket  to port
@param socket socket descriptor
@param port port no for binding
*/ 
void bind_to_port(int socket,int port)
{
	struct sockaddr_in saddress;
	bzero(&saddress,sizeof(saddress));
	saddress.sin_family=AF_INET;
	saddress.sin_port=(in_port_t)htons(port);
	saddress.sin_addr.s_addr=htonl(INADDR_ANY);
	int reuse =1;
	int r=setsockopt(socket,SOL_SOCKET,SO_REUSEADDR,&reuse,sizeof(saddress));
	if(r==-1)
	{
		error("can't use reuse option");
	}
	int b=bind(socket,(struct sockaddr*)&saddress,sizeof(saddress));
	if(b==-1)
	{
		error("can't bind to socket");
	}
}
/**
This is used for connecting socket to a port
@param socket socket identifier
@param address ip address of system 
@param port port number
*/
void connect_to_port(int socket,char* address,int port)
{
	struct sockaddr_in server;
	bzero(&server,sizeof(server));
	server.sin_addr.s_addr=inet_addr(address);
	server.sin_family=AF_INET;
	server.sin_port=(in_port_t)htons(port);
	if(connect(socket,(struct sockaddr*)&server,sizeof(server))<0)
	{
            error("could not connect");
	}
}
/** 
This method is used for writing message to the socket
@param socket socket identifier
@param s message to send to socket
*/
int say(int socket,char *s)
{
	int r=send(socket,s,strlen(s),0);
	if(r==-1)
	{
		error("error talking to client");
	}
	return r;
}
/**
This method is used for reading message form Socket
@param socket socket descriptor
@param buf pointer to Message
@param len length of message
*/ 
int hear(int socket ,char *buf ,int len)
{
	int slen=len;
	int c=recv(socket,buf,len,0);
	while(c>0 && buf[c-1]!='\n')
	{
		buf+=c;
		len-=c;
		c=recv(socket,buf,len,0);
	}	
	if(c<0)
	{
		return c;
	}
	else if(c==0)
	{
		buf[0]='\0';
	}
	else
	{
		buf[c-1]='\0';
	}
	return slen-len;
}
/**
This is used for extracting the code corresponding  to a command
@param bigString pointer to message containing command
*/ 
int find_command(char *bigString)
{
	char* subString[]={"name","entry","return","add","quit"};
	
	int j,k,i;

	int mismatch[5]={0,0,0,0,0};
	for( k=0;k<5;k++)
	{
	for( j=0;j<strlen(subString[k]) ;j++,i++)
	{
		if(bigString[j]!=subString[k][j])
			{
				mismatch[k]=1;
				break;
			}
	}
	if(bigString[j]!=' ')
		mismatch[k]=1;
	if(bigString[j]=='\r'||bigString[j]=='\n')
		mismatch[k]=0;
	
	}
	if(mismatch[0]==1&&mismatch[1]==1&&mismatch[2]==1&&mismatch[3]==1&&mismatch[4]==1)
	{
		return -1;
	}
	else if(mismatch[0]==0)
		return 1;
	else if(mismatch[1]==0)
		return 2;
	else if(mismatch[2]==0)
		return 3;
	else if(mismatch[3]==0)
		return 4;
	else return 5;
	
}
/**
this method is used for printing all records of database
@param s socket descriptor
*/
void print_record(int s)
{
	char *result=malloc(240);
	
	FILE* fp=fopen("database.txt","r"); 
	char a[40],b[40],c[40];
   	fseek(fp,SEEK_SET,0);
	
	while(feof(fp)==0)
	{
	if(fscanf(fp,"%s %s %s",a,b,c)==3)
	{	sprintf(result,"%s\t%s\t%s\n",a,b,c);
		say(s,result);}
	}
	//say(s,result);
	fclose(fp);
}
/**
this method this used for searching records in database using name of student and printing all matched records
@param name name of student
*/	
void searchByName(char* name,int s)
{
	char *result=malloc(240);
	
	FILE* fp=fopen("database.txt","r"); 
	char a[40],b[40],c[40];
   	 fseek(fp,0,SEEK_SET);
	int flag=1;
	while(feof(fp)==0)
	{
	int r=fscanf(fp,"%s %s %s",a,b,c);
	if(r==3)
	if(strnicmp(name,a,strlen(a))==0)
	{
		flag=0;
		sprintf(result,"%s\t%s\t%s\n",a,b,c);
		say(s,result);
	}
	}
	if(flag)
	say(s,"record not found\r\n");
	
	//say(s,result);
	fclose(fp);
	
	
}
/**
this method this used for searching records in database using enrollment Number of student and printing all matched records
@param name enrollment Number of student
*/
void searchByEntry(char* name,int s)
{

	char *result=malloc(240);
	FILE* fp=fopen("database.txt","r"); 
	char a[40],b[40],c[40];
    fseek(fp,0,SEEK_SET);
	int flag=1;
	while(feof(fp)==0)
	{
	int r=fscanf(fp,"%s %s %s",a,b,c);
	if(r==3)
	if(strnicmp(name,b,strlen(b))==0)
	{flag=0;
	sprintf(result,"%s\t%s\t%s\n",a,b,c);
	say(s,result);
	}
	}
	if(flag)
	say(s,"record not found\r\n");
	//say(s,result);
	fclose(fp);
	
	
}
/**
this method this used for searching records in database using enrollment Year of student and printing all matched records
@param name enrollment Year of student
*/
void searchByYear(char* name,int s)
{
	if(name[0]=='*')
	{	print_record(s);
		return;
	}
	char *result=malloc(240);
	FILE* fp=fopen("database.txt","r"); 
	char a[40],b[40],c[40];
        fseek(fp,0,SEEK_SET);
	int flag=1;
	while(feof(fp)==0)
	{
	int r=fscanf(fp,"%s %s %s",a,b,c);
	if(r==3)
	
	if(strncmp(b,name,4)==0)
	{flag=0;
	
	sprintf(result,"%s\t%s\t%s\n",a,b,c);
	say(s,result);}
	}
	if(flag)
	say(s,"record not found\r\n");
	//say(s,result);
	fclose(fp);
	
	
}
/**
This function is used for inserting student record in database
@param name name of Student
@param entry entry number of Student
@param email email of Student  
*/
void addRecord(char* name,char* entry,char* email,int s)
{
	
	FILE* fp=fopen("database.txt","a"); 
	
        fseek(fp,0,SEEK_END);

	if(fprintf(fp,"%s\t%s\t%s\n",name,entry,email)!=0)
	say(s,"record inseted in database\r\n");
	
	fclose(fp);


}



