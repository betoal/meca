int led = 53;
int photo = A4;
int button = 51;
int val = 0;
int buttonPress;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  
  pinMode(led, OUTPUT);
  pinMode(photo, INPUT);
  pinMode(button, INPUT);

}

void loop() {
  // put your main code here, to run repeatedly:
  val = analogRead(photo);
  buttonPress = digitalRead(button);
  
  if (buttonPress || val < 1000)
    digitalWrite(led, HIGH);
  else
    digitalWrite(led, LOW);
}
