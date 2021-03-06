import java.io.*;  
import java.net.*;  
  
class UDPClient  
{  
   public static void main(String args[]) throws Exception  
   {  
      final String host="localhost";
      final int port=40000;
      BufferedReader inFromUser =  
         new BufferedReader(new InputStreamReader(System.in));  
  
      DatagramSocket clientSocket = new DatagramSocket();  
 //Client Socket is created  
  
      InetAddress IPAddress = InetAddress.getByName(host);  
 //Gets the IP Address   
  
      
      int attempt=3;
      boolean flag=true;
      while(attempt>0 &&flag)
      {    
         byte[] sendData = new byte[1024];  
      byte[] receiveData = new byte[1024];  
      String sentence;
      DatagramPacket sendPacket,receivePacket;
         System.out.print("Please enter Secret code: ");
         sentence = inFromUser.readLine();  
         sendData = sentence.getBytes();  

          sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress, port);  
         clientSocket.send(sendPacket);  
  
          receivePacket = new DatagramPacket(receiveData, receiveData.length);  
         clientSocket.receive(receivePacket);   

         receiveData= receivePacket.getData();  
         sentence=new String(receiveData);
         System.out.println("FROM SERVER : " +sentence) ;  
         attempt--;
         if(sentence.trim().equalsIgnoreCase("welcome"))
            flag=false;
      }
      if(flag)
      {
         System.out.println("connection refused due to wrong password");   
         System.exit(1);
      }  
       while(true)
      {  
         String command[]=null;
         byte[] receiveData = new byte[1024];  
         byte[] sendData = new byte[1024];
         DatagramPacket receivePacket,sendPacket;  
         String sentence;
          System.out.print("Please enter Command$ ");
          sentence = inFromUser.readLine();     
          command =sentence.split(" ");  
          if(command[0].trim().equalsIgnoreCase("close"))
           {
            break;
           } 
          while(!command[0].trim().equalsIgnoreCase("execawk"))
         {
            System.out.print("Wrong command Entered \nPlease enter Command$ ");
          sentence = inFromUser.readLine();     
          command =sentence.split(" "); 
         }
         
         System.out.println("starting sending dialog AWK FILE "+command[1]+" "+"INPUT FILE"+command[2] );
         sendData = sentence.getBytes();  

          sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress, port);  
         clientSocket.send(sendPacket);  
         sendfile(command[1],clientSocket,IPAddress,port);
         sendfile(command[2],clientSocket,IPAddress,port);
         readOutput(clientSocket);
       }  
    
      
      clientSocket.close();  
   }  
   public static void sendfile( String filename,DatagramSocket clientSocket,InetAddress IPAddress,int port ) throws IOException
{
   
       FileInputStream fis = null;
    BufferedInputStream bis = null;
    DatagramPacket sendPacket=null;
        System.out.println("Waiting...");
        try {
       
          // send file
          File myFile = new File (filename);
        
            int bytesTotal=(int)myFile.length();
        byte [] sendData  = new byte [bytesTotal];
      int current = 0;
          fis = new FileInputStream(myFile);
          bis = new BufferedInputStream(fis);
          System.out.println("Sending " + filename+ "(" + sendData.length + " bytes)");
          bis.read(sendData,current,sendData.length);
         
         sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress, port);  
         clientSocket.send(sendPacket); 
           
         
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
      public static void readOutput(DatagramSocket clientSocket) throws IOException
    {

      final  int OUT_SIZE = 1000000;
      
       DatagramPacket receivePacket=null;
   byte[] receiveData = new byte[OUT_SIZE]; 
    
      System.out.println("Waiting for output...");
   

   //  do {
         receivePacket = new DatagramPacket(receiveData, receiveData.length);  
         clientSocket.receive(receivePacket);  
         receiveData= receivePacket.getData();  
          String sentence=new String(receiveData).trim();
           
             System.out.println(sentence);
             
            
           
     //} while(bytesRead > -1);

      
}

  
            
} 