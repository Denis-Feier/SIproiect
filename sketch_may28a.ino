#include <Servo.h> //impotarea librariei pentru servo-motor
 
const int trigPin = 10; // setarea pinului trig pentru senzorul cu ultrasunete
const int echoPin = 11; // setarea pinului echo pentru senzorul cu ultrasunete

long duration;
int distance;

Servo myServo; // Referinta catre obiectul servo(pentru a controla servo-motorul)

void setup() {
  pinMode(trigPin, OUTPUT); // Seteaza trigPin ca output
  pinMode(echoPin, INPUT); // Seteaza echoPin ca Input
  Serial.begin(9600);
  myServo.attach(3); // Setarea pinului la care ii legata intrarea de date a servo-motorului
}

void loop() {
  
  for(int i=15;i<=165;i++){ // Rotirea servo-motorului de la 15 la 165 de grade
  myServo.write(i); // Screrea pe pinul corespunzator a valorii unghiului
  delay(5); // Delay 5 milisecunde
  distance = calculateDistance();// Functie care calculeaza distanta de la senzorul cu ultrasunete la obiect

  Serial.print(i); // Printeaza unghiul pe seriala
  Serial.print(","); // Atasarea unui caracter despartitor pentru a putea fi parsat in UI
  Serial.print(distance); // Printarea distantei masurate pe seriala
  Serial.print("."); // Caracter '.' remnifica trimiterea cu succes a unui pachet complet de date
  }

  // Repetarea procesului anterior pornind de la 165 de grade si revenind la 15 grade
  for(int i=165;i>15;i--){  
  myServo.write(i);
  delay(30);
  distance = calculateDistance();
  Serial.print(i);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(".");
  }
}


// Functie folosita pentru a calcula distanta masurata de senzorul cu ultrasunete
int calculateDistance(){ 
  
  digitalWrite(trigPin, LOW); // Se seteaza pinul corespunzator intrarii trig a senzorului cu ultra sunete pe 0 logic
                              // In aceasta situatie sezorul nu va emite impulsuri de ultra sunete
  delayMicroseconds(2);       // Delay de 2 microsecunde
                              // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);      // Se seteaza pinul corespunzator intrarii trig a senzorului cu ultra sunete pe 1 logic
                              // In aceasta situatie sezorul va emite 8 impulsuri ultrasonice de frecventa 40KHz

  digitalWrite(trigPin, LOW); // Se seteaza pinul corespunzator intrarii trig a senzorului cu ultra sunete pe 0 logic 
                              // Aceasta pentru a opri trimiterea de impulsuri pentru a se pregati citirea

  duration = pulseIn(echoPin, HIGH); // Citim informatiile de pe echoPin (pin-ul corespunzator iesirii echo a senzorului cu ultra sunete)
                                      // Functia pulseIn determina cat timp a stat echoPin pe 1 logic
  distance = duration*0.034/2;  // Aceasta formula ajuta la determinarea distantei in cm
                                // Formula pleaca de la distanta sunetului in aer
                                // Viteza sunetului in aer este 343 m/s sau 0,034 cm/μs
                                // Rezultatul se imparte la 2 datorita timpului necesar impulsurilor de a lovi obiectul detectat si de a se intoarce inapoi la receptor
  return distance;
}
