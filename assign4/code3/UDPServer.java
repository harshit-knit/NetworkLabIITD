import java.io.*;  
import java.net.*;  
  import java.util.*;
class UDPServer  
{  
   public static void main(String args[]) throws Exception  
      {  
         final int sport =40000;
         int portlist[]={30001,30002,30003,30004,30005,30006,30007,30008,30009,300010};
                  int count=0;
         ArrayList<Integer> cport=new ArrayList<Integer>();
         DatagramSocket serverSocket = new DatagramSocket(sport);  
  //Server Socekt Created  
  
                  boolean flag=true;
                  
                  
                  while(flag)
                  {   
                     byte[] receiveData = new byte[1024];  
                     byte[] sendData = new byte[1024];
                     DatagramPacket receivePacket,sendPacket;  
                     String sentence;

                  receivePacket = new DatagramPacket(receiveData, receiveData.length);  
                  serverSocket.receive(receivePacket);  
                  receiveData= receivePacket.getData();  
                  sentence=new String(receiveData);
                  System.out.println("RECEIVED: " + sentence);  

                  
                  InetAddress IPAddress = receivePacket.getAddress();  
                  int port = receivePacket.getPort();  
                  
                  if(sentence.trim().equals("xxxx"))
                   {  sentence=new String("welcome");
                      System.out.println("SENT: " + sentence); 
                      sendData = sentence.getBytes();
                      sendPacket=new DatagramPacket(sendData, sendData.length, IPAddress, port);  
                      serverSocket.send(sendPacket); 
                      count++;
                      sentence=new String(""+portlist[count]);
                      System.out.println("SENT: " + sentence); 
                          sendData = sentence.getBytes();
                           sendPacket=new DatagramPacket(sentence.getBytes(),sentence.length(),IPAddress,port);
                         serverSocket.send(sendPacket);
                       if(count==1)
                       { 
                      Thread th=new AWKthread(portlist[count],cport);

                      
                         th.start();
                      }
                      else
                       {
                       System.out.println("client port "+port);
                          cport.add(port);
                            
                       } 
           /*         else 
                    {
                       Thread th1=new WALLthread(portlist[count],IPAddress,port);

                       System.out.println("SENT: " + sentence); 
                        sendData = sentence.getBytes();
                        sendPacket=new DatagramPacket(sentence.getBytes(),sentence.length(),IPAddress,port);
                        serverSocket.send(sendPacket);
                        th1.start();

                }*/
                    } 
                  else
                  {
                     sentence=new String("try again");
                  System.out.println("SENT: " + sentence); 
                  sendData = sentence.getBytes();
                  sendPacket=new DatagramPacket(sendData, sendData.length, IPAddress, port);  
                  serverSocket.send(sendPacket);  
                }

               }

      }   
      
    public static void readFile(String filename,DatagramSocket serverSocket) throws IOException
    {

      final  int FILE_SIZE = 10000000;
      FileOutputStream fos = null;
      BufferedOutputStream bos = null;
       DatagramPacket receivePacket=null;
   byte[] receiveData = new byte[FILE_SIZE]; 
    try {
      System.out.println("Waiting...");
      File myFile = new File ("server_"+filename);
      fos = new FileOutputStream(myFile);
      bos = new BufferedOutputStream(fos);
    int bytesRead;
      int current = 0;

   //  do {
         receivePacket = new DatagramPacket(receiveData, receiveData.length);  
         serverSocket.receive(receivePacket);  
         receiveData= receivePacket.getData();  
          String fileData=new String(receiveData).trim();
          bytesRead=fileData.length();
         if(bytesRead >= 0)
         {  
             bos.write(fileData.getBytes(), current ,bytesRead);
             current += bytesRead;
            
          }   
     //} while(bytesRead > -1);

      
      bos.flush();
      System.out.println("File " + filename+ " downloaded (" + current + " bytes read)");
      System.out.println("transfer completed");
    }
    catch(Exception e)
    {
      e.printStackTrace();
    }
    finally {
      if (fos != null) fos.close();
      if (bos != null) bos.close();
   
    }
  }

public static void sendOutput( String awkfile,String inputfile,DatagramSocket serverSocket,InetAddress IPAddress,int port ) throws IOException
{
     final  int FILE_SIZE = 10000;
     InputStream fis =null;
    BufferedInputStream bis = null;
    DatagramPacket sendPacket=null;
        System.out.println("Waiting...");
        try {Process process=null;
          if(inputfile!=null)
           { 
        process = new ProcessBuilder("/usr/bin/awk","-f",awkfile,inputfile).start();
     }
     else
     {
       process = new ProcessBuilder("/usr/bin/awk","-f",awkfile,awkfile).start();
    }
fis = process.getInputStream();
//InputStreamReader isr = new InputStreamReader(fis)
          // send file
         
        byte [] sendData  = new byte [FILE_SIZE];
      int current = 0;
          
          bis = new BufferedInputStream(fis);
          System.out.println("Sending " + awkfile+ "(" + sendData.length + " bytes)");
          bis.read(sendData,current,sendData.length);
         
         sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress, port);  
         serverSocket.send(sendPacket); 
           
         
          System.out.println(" Transfer Done.");
          
        }
        catch(Exception e)
        {
         e.printStackTrace();
        }
        finally {
          
          if (fis != null) fis.close();
          if (bis != null) bis.close();
        }
      }
            
 
public static void sendBroadcast( String file,DatagramSocket serverSocket,InetAddress IPAddress,int port ) throws IOException
{
     final  int FILE_SIZE = 10000;
     FileInputStream fis =null;
    BufferedInputStream bis = null;
    DatagramPacket sendPacket=null;
        System.out.println("Waiting...");
        try {
      
//InputStreamReader isr = new InputStreamReader(fis)
          // send file
         fis=new FileInputStream(new File(file));
        byte [] sendData  = new byte [FILE_SIZE];
      int current = 0;
          
          bis = new BufferedInputStream(fis);
          System.out.println("Sending " + file+ "(" + sendData.length + " bytes)");
          bis.read(sendData,current,sendData.length);
         
         sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress, port);  
         serverSocket.send(sendPacket); 
           
         
          System.out.println(" Transfer Done.");
          
        }
        catch(Exception e)
        {
         e.printStackTrace();
        }
        finally {
          
          if (fis != null) fis.close();
          if (bis != null) bis.close();
        }
      }
            
} 
 class AWKthread extends Thread
      {

        private int port;
        private List<Integer> portlist;
   public AWKthread(int number, List<Integer> portlist)
   {
      this.port= number;
      this.portlist=portlist;
   }
       public void run() 
              { 
                try{
               while(true)
               {
                
                DatagramSocket serverSocket = new DatagramSocket(port);  
                  byte[] receiveData = new byte[1024];  
                     byte[] sendData = new byte[1024];
                     String command[]=null;
                     DatagramPacket receivePacket,sendPacket;  
                     String sentence;
                  receivePacket = new DatagramPacket(receiveData, receiveData.length);  
                  serverSocket.receive(receivePacket);  
                  receiveData= receivePacket.getData();  
                  sentence=new String(receiveData);
                  System.out.println("RECEIVED: " + sentence);  
                 InetAddress  IPAddress = receivePacket.getAddress();  
                  int port = receivePacket.getPort(); 
                  command=sentence.split(" ");
                  if(command[0].trim().equalsIgnoreCase("execawk"))
                  { 
                    UDPServer.readFile(command[1],serverSocket);
                    UDPServer.readFile(command[2],serverSocket);
                    UDPServer.sendOutput(command[1],command[2],serverSocket,IPAddress,port);
                    if(command.length >3 && command[3].trim().equals("-b"))
                     {
                       for(Integer i : portlist)
                      {
                        
                      UDPServer.sendOutput(command[1],command[2],serverSocket,IPAddress,i); 
                
                    }

                     } 

                  }
                  if(command[0].trim().equalsIgnoreCase("exeawk"))
                  { 
                    UDPServer.readFile(command[1],serverSocket);
                    
                    UDPServer.sendOutput(command[1],null,serverSocket,IPAddress,port);
                    if(command.length >2 && command[2].trim().equals("-b"))
                     {
                       for(Integer i : portlist)
                      {
                        
                      UDPServer.sendOutput(command[1],command[2],serverSocket,IPAddress,i); 
                
                    }

                     } 

                  }
                  if(command[0].trim().equalsIgnoreCase("wall"))
                   {
                    if(command[1].trim().equals("-f"))
                     {
                     UDPServer.sendBroadcast(command[2],serverSocket,IPAddress,port); 
                  System.out.println("SENT: to ever one from file  " + command[2]);
                    
                      for(Integer i : portlist)
                      {
                        
                      UDPServer.sendBroadcast(command[2],serverSocket,IPAddress,i); 
                
                    }


                     }
                     else
                     { 
                      sentence="";
                      for(int i=1;i<command.length;i++)
                    sentence+=" "+new String(command[i]);
                  System.out.println("SENT: to every one " + sentence);
                    sendData = sentence.getBytes();
                  sendPacket=new DatagramPacket(sendData, sendData.length, IPAddress, port);  
                  serverSocket.send(sendPacket); 
                      for(Integer i : portlist)
                      {
                        
                  sendPacket=new DatagramPacket(sendData, sendData.length, IPAddress,i);  
                  serverSocket.send(sendPacket); 
                
                    }
                   } 
                  } 
                  serverSocket.close();
          }  
        }catch(Exception e)
        {e.printStackTrace();
        }
        }
 }

 
