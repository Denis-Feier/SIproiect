import processing.serial.*; // Importarea bibliotecii pentru comunicarea seriala
import java.awt.event.KeyEvent; // Importarea bibliotecii pentru a citii date de pe seriala 
                                // Informatiile de pe interfata seriala sunt propagate asincron
                                // De aceea este necesara folosirea mecanismului de evenimente
import java.io.IOException;

Serial portSeriala; // Referinta catre obiectul interfata seriala

String unghi=""; // Unghiul in care este pozitionat servo motorul in format string
String distanta=""; // Distanta de la senzor la obiectul detectat in format string
String cuvantDate=""; // Cuvantul de date citit de pe seriala in format string

float distantaPixeli;
int unghiI, distantaI;
int index1=0;
int index2=0;
// PFont orcFont;

void setup() {
  
 size (1366, 768); //Setam dimensiunea UI-ului
 smooth();
 portSeriala = new Serial(this,"COM4", 9600); // Configurarea obiectului interfata seriala
 portSeriala.bufferUntil('.'); // Separam cuvintele din interfata seriala prin caracterul '.'. Astfel cuvantul pe care o sa il citim o sa contina unghiul despartit de ',' distanta
//  orcFont = loadFont("OCRAExtended-30.vlw");
}

void draw() {
  
  // fill(98,245,31);
  // textFont(orcFont);
 
  noStroke(); // Dezactivam marginea dreptunghiului care reprezinta cadranul radarului
  fill(0,4); 
  rect(0, 0, width, height-height*0.065);  // Se deseneaza cadranul
  
  fill(98,245,31); // Se alege culoarea verde (urmatoarele obiecte vor fi desenate cu verde)
  creazaRadar(); 
  deseneazaLinie();
  detecteazaObiect();
  // drawText();
}

void serialEvent (Serial portSeriala) { // Citim datele de pe portul serial

  // Citim date de pe interfata seriala pana ajungem la caracterul '.';
  cuvantDate = portSeriala.readStringUntil('.'); 
  // Eliminam caracterul '.' din string
  cuvantDate = cuvantDate.substring(0,cuvantDate.length()-1);
  
  index1 = cuvantDate.indexOf(","); // Cautam caracterul ',' si punem pozitia acestuia in intex1
  unghi = cuvantDate.substring(0, index1); // Citim substring-ul de la caracterul de pe pozitia 0 pana la ',' pentru a determina unghiul
  distanta = cuvantDate.substring(index1+1, cuvantDate.length()); // Citim distanta pana la obiectul detectat
  
  // Convertim datele din string in int
  unghiI = int(unghi);
  distantaI = int(distanta);
}

void creazaRadar() {
  pushMatrix();
  translate(width/2,height-height*0.07); // Mutam originea in mijlocul laturii de jos a cadranului
  noFill(); 
  strokeWeight(2);
  stroke(98,245,31); // Se alege culoarea verde
  // Se deseneaza arcele care formeaza radarul
  arc(0,0,(width-width*0.06),(width-width*0.06),PI,TWO_PI); //TWO_PI = 2 * PI 
  arc(0,0,(width-width*0.25),(width-width*0.25),PI,TWO_PI);
  arc(0,0,(width-width*0.5),(width-width*0.5),PI,TWO_PI);
  arc(0,0,(width-width*0.7),(width-width*0.7),PI,TWO_PI);
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

void detecteazaObiect() {
  pushMatrix();
  translate(width/2,height-height*0.07); // Mutam originea in mijlocul laturii de jos a cadranului
  strokeWeight(9);
  stroke(255,10,10); // Se seteaza culoarea rosu
  distantaPixeli = distantaI*((height-height*0.1666)*0.025); // Se converteste distanta de la senzor la obiect din cm in pixeli
  // Se limiteaza distanta pana la 70 cm
  if(distantaI<70){
    // Se deseneaza obiectul in functie de distanta si unghi
  line(distantaPixeli*cos(radians(unghiI)),-distantaPixeli*sin(radians(unghiI)),(width-width*0.5)*cos(radians(unghiI)),-(width-width*0.5)*sin(radians(unghiI)));
  }
  popMatrix();
}

void deseneazaLinie() {
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60); // Se seteaza culoarea verde
  translate(width/2,height-height*0.07); // Mutam originea in mijlocul laturii de jos a cadranului
  line(0,0,(height-height*0.12)*cos(radians(unghiI)),-(height-height*0.12)*sin(radians(unghiI))); // Se deseneaza obiectul in functie de distanta si unghi
  popMatrix();
}

// void drawText() { // draws the texts on the screen
  
//   pushMatrix();
//   if(distantaI>40) {
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
//   text("unghi: " + unghiI +" °", width-width*0.48, height-height*0.0277);
//   text("distanta: ", width-width*0.26, height-height*0.0277);
//   if(distantaI<40) {
//   text("        " + distantaI +" cm", width-width*0.225, height-height*0.0277);
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
