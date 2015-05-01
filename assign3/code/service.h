/**
*This is home page for documantation of QueryServer
*@mainpage QueryPage
*@section files File Names
*    -# server.c
*    -# service.c
*    -# service.h
*    -# makefile
*@section server Running Server
*    -# $ gcc -o QueryServer server.c service.c -lpthread     
*    -# $ make
*@section client Running Client
*    -#   $ telnet <hostaddress> <portno>
*@section execution Execution Directive
*    -# name <NAME> 
*    -# entry <ENTRYNO>
*    -# return *
*    -# return <YEAR>
*    -# add <NAME> <ENTRYNO> <EMAILID
*    -# quit 
*/
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<errno.h>
#include<signal.h>

#include<sys/socket.h>
#include<arpa/inet.h>
void error(char *msg);
int open_listener_socket();
int catch_signal(int signal,void (*handler)(int));
void handle_shutdown(int signal);
void bind_to_port(int socket,int port);
void connect_to_port(int socket,char* addres,int port);
int say(int socket,char *s);
int hear(int socket ,char *buf ,int len);
int find_command(char *bigString);
void remove_spaces(const char *input, char *result);
void searchByName(char* name,int s);
void  searchByEntry(char* entry,int s);
void searchByYear(char* year,int s);
void print_record(int s);
void addRecord(char* a,char *b,char *c,int s); 
