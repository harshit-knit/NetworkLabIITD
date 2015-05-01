import java.io.*;  
import java.net.*;  
  
class UDPServer  
{  
   public static void main(String args[]) throws Exception  
      {  
         final int sport =40000;
         
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
                  System.out.println("RECEIVED: " + sentence+sentence.length());  

                  
                  InetAddress IPAddress = receivePacket.getAddress();  
                  int port = receivePacket.getPort();  
                  
                  if(sentence.trim().equalsIgnoreCase("xxxx"))
                   {  sentence=new String("welcome");
                     flag=false;
                    } 
                  else
                     sentence=new String("try again");
                  System.out.println("SENT: " + sentence); 
                  sendData = sentence.getBytes();
                  sendPacket=new DatagramPacket(sendData, sendData.length, IPAddress, port);  
                  serverSocket.send(sendPacket);  

               }
               while(true)
               {
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
                  readFile(command[1],serverSocket);
                  readFile(command[2],serverSocket);
                  sendOutput(command[1],command[2],serverSocket,IPAddress,port);

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
        try {
       Process process = new ProcessBuilder("/usr/bin/awk","-f",awkfile,inputfile).start();
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
            
} 
