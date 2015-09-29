  //
  //MUSE OSC SERVER EXAMPLE
  //Copyright Interaxon 2015
  //
  
  import oscP5.*;
  import java.awt.Robot;
  import java.awt.event.*;
  import java.util.Random;
  import java.util.ArrayList;
  boolean debug = false;
 ArrayList<ArrayList<Integer>> rects = new ArrayList<ArrayList<Integer>>();
  ArrayList<Integer>newrect=new ArrayList<Integer>();       
  
  //OSC PARAMETERS & PORTS--------------------------------------
  int recvPort = 5001,newrectcounter=200;
  int counter=0,maxheight=250;
  boolean last1=false,last2=false,down=true;
  OscP5 oscP5;
  boolean djump=false, jump=false;
  boolean gamestate = true;
  //DISPLAY PARAMETERS------------------------------------------
  int WIDTH = 500;
  int HEIGHT = 500;
  
  //Robot bot; 
 int y = 250;
 public static int randInt(int min, int max) {
    Random rand = new Random();
    int randomNum = rand.nextInt((max - min) + 1) + min;
    return randomNum;
}
  
  //SETUP-------------------------------------------------------
  void setup()  {
    print("HI\n");
    size(500,500);
    frameRate(60);
    
    
    /* start oscP5, listening for incoming messages at recvPort */
    oscP5 = new OscP5(this, recvPort);
    background(0);
  }

  //DRAW LOOP -------------------------------------------------
  void draw() {
    background(0);
    if (gamestate == true){
      fill(255,0,0);
      rect(80,y,20,20);
      fill(255);
    textSize(20);
    text(counter,460,480);
    int i=0;
    while (i<rects.size())
    {
      newrect=new ArrayList<Integer>(rects.get(i));
      newrect.set(0,newrect.get(0)-2);
      if (newrect.get(0)==78 || newrect.get(0)==79)counter++;
      if (newrect.get(0)<=0)
      {
        rects.remove(i);
      }
      else 
      {
        rect(newrect.get(0),newrect.get(1),newrect.get(2),newrect.get(3));
        rects.set(i,new ArrayList<Integer>(newrect));
        if (newrect.get(0)<=80 && 100<=newrect.get(0)+newrect.get(2) && newrect.get(1)<=y && y+20<=newrect.get(1)+newrect.get(3))
        {
          gamestate = false;
        }
        i++;
      }
      
      
    }
    
    //Jump
    if (jump)
  {
      y -= 10;
      if (y<=maxheight){
        down = true;
        jump = false;
        if (y<20)y=20;
        }
  }
    else
      {
        y += 2;
        if (y >= 480) {
          y=480;
        }
      }
    //Obstacles
    newrectcounter++;
    if (newrectcounter>=30) //&& rects.size()<4)
    {
      newrectcounter=0;
      newrect.clear();
      newrect.add(500);
      newrect.add(randInt(1,400));
      newrect.add(randInt(20,80));
      newrect.add(randInt(50,150));
      rects.add(newrect);
    }
  }
  else
  {
     background(0);
     textSize(26);
     text("Game Over",180,250);
     
   }
  }
    

  //OSC HANDLER------------------------------------------------
  void oscEvent(OscMessage msg) {
    //print("JASIDAJDIAJDIJDID\n");
    /* print the address path and the type string of the received OscMessage */
    if (debug) {
      print("---OSC Message Received---");
      print(" Address Path: "+msg.addrPattern());
      println(" Types: "+msg.typetag());
    }
    /*if (msg.checkAddrPattern("/muse/eeg")==true) {  
        //for(int i = 0; i < 4; i++) {
        // print("EEG on channel ", i, ": ", msg.get(i).floatValue(), "\n"); 
        //if (msg.get(3).floatValue()>1000)print("BLINK\n");
        //else print("NOTHING\n");
       // print(msg.get(3).floatValue(),"\n");
       // }      
    }*/
    if (msg.checkAddrPattern("/muse/elements/blink")==true) {  
        //for(int i = 0; i < 4; i++) {
        // print("EEG on channel ", i, ": ", msg.get(i).floatValue(), "\n"); 
       // print(counter,"\n");
        //bot.mousePress(1);
       // bot.mouseRelease(1);
        
        if (msg.get(0).intValue()==1)
        {
          //
          //print("BLINK\n");

          last1=true;
          if (!last2)
          { 
            print("BLINK\n");
            jump = true;
          //  counter++;
            maxheight = y-150;
        }
        }
        else
        {
          last1=false;
        }
        last2=last1;
        //print(counter,"\n");
       // print(msg.get(3).floatValue(),"\n");
       // }      
    }

  }
  
