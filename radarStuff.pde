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

void setup() {
  
 size (1366, 768); //Setam dimensiunea UI-ului
 smooth();
 portSeriala = new Serial(this,"COM4", 9600); // Configurarea obiectului interfata seriala
 portSeriala.bufferUntil('.'); // Separam cuvintele din interfata seriala prin caracterul '.'. Astfel cuvantul pe care o sa il citim o sa contina unghiul despartit de ',' distanta

}

void draw() {
  
  noStroke(); // Dezactivam marginea dreptunghiului care reprezinta cadranul radarului
  fill(0, 4);
  rect(0, 0, width, height-height*0.065);  // Se deseneaza cadranul
  
  fill(98,245,31); // Se alege culoarea verde (urmatoarele obiecte vor fi desenate cu verde)
  creazaRadar(); 
  deseneazaLinie();
  detecteazaObiect();

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

