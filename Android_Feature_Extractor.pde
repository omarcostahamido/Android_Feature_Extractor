/* 
  Developed by Omar Costa Hamido
  April 2016
  https://github.com/omarcostahamido
  www.omarcostahamido.com/contactos
  en.omarcostahamido.com/contacts
 
  Required libraries:
  oscP5
  http://www.sojamo.de/oscP5
  Ketai
  http://ketai.org/
*/

import oscP5.*;
import netP5.*;

import ketai.ui.*;
import ketai.sensors.*;

OscP5 oscP5;
NetAddress wekAddress;
KetaiSensor sensor;

String wekIP="";
boolean ready=false;
float rotX, rotY, rotZ;

void setup() {
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(LANDSCAPE);
  textSize(height/22);//32
  textAlign(CENTER, CENTER);
  frameRate(25);

  oscP5 = new OscP5(this,9000);
  wekAddress = new NetAddress("null", 6448);
}

void draw() {
  background(81);
  
  if (ready==false)
  {
    text("Where is Wekinator? (Insert IP)", width/4, height/5);   
    text(wekIP, width/5, height/5+(height/18));//+50
    text("Continuously sends 3 inputs to Wekinator\n"
    + "Using message /wek/inputs, to port 6448\n"
    + "\n"
    + "Tip: increase the \"screen on\" time of your android device.",
    width/2, 5*height/6);
  }
  else
  {
    text("Android Feature Extractor" + "\n"
      + "\n"
      + "x: " + nfp(rotX, 1, 2) + " " 
      + "y: " + nfp(rotY, 1, 2) + " " 
      + "z: " + nfp(rotZ, 1, 2) + "\n"
      + "\n"
      + "#flawless", width/2, height/2);
      
    text("en.omarcostahamido.com/contacts"
    ,width/2,height-(height/22));//-20
    
    //send it to wek now
    OscMessage afeMessage = new OscMessage("/wek/inputs");
      afeMessage.add((float)rotX); 
      afeMessage.add((float)rotY);
      afeMessage.add((float)rotZ);
    oscP5.send(afeMessage, wekAddress);
  }
}

//--------

void mousePressed() 
{ 
  if (ready==false)
  {
    KetaiKeyboard.toggle(this);
  }
}

void keyPressed()
{
  if (key==RETURN || key==ENTER)
  {
    wekAddress = new NetAddress(wekIP, 6448);
    ready=true;
  }
  wekIP+=str(key);
}

//------

void onRotationVectorEvent(float x, float y, float z)
{
  rotX = x;
  rotY = y;
  rotZ = z;
}