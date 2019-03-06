#include <SoftwareSerial.h>

int beeInput = 11;
int beeOutput = 10;
int led1 = 7;
int led2 = 6;
int led3 = 5;
int button = 4;

SoftwareSerial xbee_serial(beeInput, beeOutput);

void setup() {

  //Serial.begin(9600);
  // put your setup code here, to run once:
  pinMode(beeInput, INPUT);
  pinMode(beeOutput, OUTPUT);
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);
  pinMode(button, INPUT);

  xbee_serial.begin(9600);
}

int r;
void loop() {
  // put your main code here, to run repeatedly:
  r = xbee_serial.read();
  switch (r) {
    case 1:
      digitalWrite(led1, HIGH);
      digitalWrite(led2, LOW);
      digitalWrite(led3, LOW);
      break;
    case 2:
      digitalWrite(led2, HIGH);
      digitalWrite(led1, LOW);
      digitalWrite(led3, LOW);
      break;
    case 3:
      digitalWrite(led3, HIGH);
      digitalWrite(led1, LOW);
      digitalWrite(led2, LOW);
      break;
    case 4:
      digitalWrite(led1, LOW);
      digitalWrite(led2, LOW);
      digitalWrite(led3, LOW);
      break;
      
  }
  if (digitalRead(button))
    xbee_serial.write("Boton apretado.");
}
