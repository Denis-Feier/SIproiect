import processing.serial.*; // Importarea bibliotecii pentru comunicarea seriala
import java.awt.event.KeyEvent; // Importarea bibliotecii pentru a citii date de pe seriala 
                                // Informatiile de pe interfata seriala sunt propagate asincron
                                // De aceea este necesara folosirea mecanismului de evenimente
import java.io.IOException;

Serial myPort; // Referinta catre obiectul interfata seriala

String angle=""; // Unghiul in care este pozitionat servo motorul in format string
String distance=""; // Distanta de la senzor la obiectul detectat in format string
String data=""; // Cuvantul de date citit de pe seriala in format string
String noObject; // String utilizat pentru afisarea mesajelor in UI

float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;
// PFont orcFont;

void setup() {
  
 size (1366, 768); //Setam dimensiunea UI-ului
 smooth();
 myPort = new Serial(this,"COM4", 9600); // Configurarea obiectului interfata seriala
 myPort.bufferUntil('.'); // Separam cuvintele din interfata seriala prin caracterul '.'. Astfel cuvantul pe care o sa il citim o sa contina unghiul despartit de ',' distanta
//  orcFont = loadFont("OCRAExtended-30.vlw");
}

void draw() {
  
  // fill(98,245,31);
  // textFont(orcFont);
 
  noStroke(); // Dezactivam marginea dreptunghiului care reprezinta cadranul radarului
  fill(0,4); 
  rect(0, 0, width, height-height*0.065);  // Se deseneaza cadranul
  
  fill(98,245,31); // Se alege culoarea verde (urmatoarele obiecte vor fi desenate cu verde)
  drawRadar(); 
  drawLine();
  drawObject();
  // drawText();
}

void serialEvent (Serial myPort) { // Citim datele de pe portul serial

  // Citim date de pe interfata seriala pana ajungem la caracterul '.';
  data = myPort.readStringUntil('.'); 
  // Eliminam caracterul '.' din string
  data = data.substring(0,data.length()-1);
  
  index1 = data.indexOf(","); // Cautam caracterul ',' si punem pozitia acestuia in intex1
  angle= data.substring(0, index1); // Citim substring-ul de la caracterul de pe pozitia 0 pana la ',' pentru a determina unghiul
  distance= data.substring(index1+1, data.length()); // Citim distanta pana la obiectul detectat
  
  // Convertim datele din string in int
  iAngle = int(angle);
  iDistance = int(distance);
}

void drawRadar() {
  pushMatrix();
  translate(width/2,height-height*0.074); // Mutam originea in mijlocul laturii de jos a cadranului
  noFill(); 
  strokeWeight(2);
  stroke(98,245,31); // Se alege culoarea verde
  // Se deseneaza arcele care formeaza radarul
  arc(0,0,(width-width*0.0625),(width-width*0.0625),PI,TWO_PI);
  arc(0,0,(width-width*0.27),(width-width*0.27),PI,TWO_PI);
  arc(0,0,(width-width*0.479),(width-width*0.479),PI,TWO_PI);
  arc(0,0,(width-width*0.687),(width-width*0.687),PI,TWO_PI);
  // Se deseneaza liniile care formeaza radarul
  line(-width/2,0,width/2,0);
  line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
  line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
  line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
  line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
  line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));
  line((-width/2)*cos(radians(30)),0,width/2,0);
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width/2,height-height*0.074); // Mutam originea in mijlocul laturii de jos a cadranului
  strokeWeight(9);
  stroke(255,10,10); // Se seteaza culoarea rosu
  pixsDistance = iDistance*((height-height*0.1666)*0.025); // Se converteste distanta de la senzor la obiect din cm in pixeli
  // Se limiteaza distanta pana la 40 cm
  if(iDistance<40){
    // Se deseneaza obiectul in functie de distanta si unghi
  line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)),(width-width*0.505)*cos(radians(iAngle)),-(width-width*0.505)*sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60); // Se seteaza culoarea verde
  translate(width/2,height-height*0.074); // Mutam originea in mijlocul laturii de jos a cadranului
  line(0,0,(height-height*0.12)*cos(radians(iAngle)),-(height-height*0.12)*sin(radians(iAngle))); // Se deseneaza obiectul in functie de distanta si unghi
  popMatrix();
}

// void drawText() { // draws the texts on the screen
  
//   pushMatrix();
//   if(iDistance>40) {
//   noObject = "Out of Range";
//   }
//   else {
//   noObject = "In Range";
//   }
//   fill(0,0,0);
//   noStroke();
//   rect(0, height-height*0.0648, width, height);
//   fill(98,245,31);
//   textSize(25);
  
//   text("10cm",width-width*0.3854,height-height*0.0833);
//   text("20cm",width-width*0.281,height-height*0.0833);
//   text("30cm",width-width*0.177,height-height*0.0833);
//   text("40cm",width-width*0.0729,height-height*0.0833);
//   textSize(40);
//   text("Object: " + noObject, width-width*0.875, height-height*0.0277);
//   text("Angle: " + iAngle +" °", width-width*0.48, height-height*0.0277);
//   text("Distance: ", width-width*0.26, height-height*0.0277);
//   if(iDistance<40) {
//   text("        " + iDistance +" cm", width-width*0.225, height-height*0.0277);
//   }
//   textSize(25);
//   fill(98,245,60);
//   translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
//   rotate(-radians(-60));
//   text("30°",0,0);
//   resetMatrix();
//   translate((width-width*0.503)+width/2*cos(radians(60)),(height-height*0.0888)-width/2*sin(radians(60)));
//   rotate(-radians(-30));
//   text("60°",0,0);
//   resetMatrix();
//   translate((width-width*0.507)+width/2*cos(radians(90)),(height-height*0.0833)-width/2*sin(radians(90)));
//   rotate(radians(0));
//   text("90°",0,0);
//   resetMatrix();
//   translate(width-width*0.513+width/2*cos(radians(120)),(height-height*0.07129)-width/2*sin(radians(120)));
//   rotate(radians(-30));
//   text("120°",0,0);
//   resetMatrix();
//   translate((width-width*0.5104)+width/2*cos(radians(150)),(height-height*0.0574)-width/2*sin(radians(150)));
//   rotate(radians(-60));
//   text("150°",0,0);
//   popMatrix(); 
// }
