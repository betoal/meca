int pins[] = {30, 31, 32, 33, 34, 35, 36, 37};

void setup() {
  // put your setup code here, to run once;
  Serial.begin(9600);

  for (int i = 0; i < 7; i++)
    pinMode(pins[i], OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly;
  if (Serial.available() > 0) {
    display(Serial.read());
  }
}

/**
 * Displays a segment.
 */
void display(char hex) {
  bool r[7];
  switch (hex) {
    case '0':
      r[0] = 1;
      r[1] = 1;
      r[2] = 1;
      r[3] = 1;
      r[4] = 1;
      r[5] = 1;
      r[6] = 0;
      break;
    case '1':
      r[0] = 0;
      r[1] = 1;
      r[2] = 1;
      r[3] = 0;
      r[4] = 0;
      r[5] = 0;
      r[6] = 0;
      break;
    case '2':
      r[0] = 1;
      r[1] = 1;
      r[2] = 0;
      r[3] = 1;
      r[4] = 1;
      r[5] = 0;
      r[6] = 1;
      break;
    case '3':
      r[0] = 1;
      r[1] = 1;
      r[2] = 1;
      r[3] = 1;
      r[4] = 0;
      r[5] = 0;
      r[6] = 1;
      break;
    case '4':
      r[0] = 0;
      r[1] = 1;
      r[2] = 1;
      r[3] = 0;
      r[4] = 0;
      r[5] = 1;
      r[6] = 1;
      break;
    case '5':
      r[0] = 1;
      r[1] = 0;
      r[2] = 1;
      r[3] = 1;
      r[4] = 0;
      r[5] = 1;
      r[6] = 1;
      break;
    case '6':
      r[0] = 1;
      r[1] = 0;
      r[2] = 1;
      r[3] = 1;
      r[4] = 1;
      r[5] = 1;
      r[6] = 1;
      break;
    case '7':
      r[0] = 1;
      r[1] = 1;
      r[2] = 1;
      r[3] = 0;
      r[4] = 0;
      r[5] = 0;
      r[6] = 0;
      break;
    case '8':
      r[0] = 1;
      r[1] = 1;
      r[2] = 1;
      r[3] = 1;
      r[4] = 1;
      r[5] = 1;
      r[6] = 1;
      break;
    case '9':
      r[0] = 1;
      r[1] = 1;
      r[2] = 1;
      r[3] = 1;
      r[4] = 0;
      r[5] = 1;
      r[6] = 1;
      break;
    case 'a':
      r[0] = 1;
      r[1] = 1;
      r[2] = 1;
      r[3] = 0;
      r[4] = 1;
      r[5] = 1;
      r[6] = 1;
      break;
    case 'b':
      r[0] = 0;
      r[1] = 0;
      r[2] = 1;
      r[3] = 1;
      r[4] = 1;
      r[5] = 1;
      r[6] = 1;
      break;
    case 'c':
      r[0] = 1;
      r[1] = 0;
      r[2] = 0;
      r[3] = 1;
      r[4] = 1;
      r[5] = 1;
      r[6] = 0;
      break;
    case 'd':
      r[0] = 0;
      r[1] = 1;
      r[2] = 1;
      r[3] = 1;
      r[4] = 1;
      r[5] = 0;
      r[6] = 1;
      break;
    case 'e':
      r[0] = 1;
      r[1] = 0;
      r[2] = 0;
      r[3] = 1;
      r[4] = 1;
      r[5] = 1;
      r[6] = 1;
      break;
    case 'f':
      r[0] = 1;
      r[1] = 0;
      r[2] = 0;
      r[3] = 0;
      r[4] = 1;
      r[5] = 1;
      r[6] = 1;
      break;
    default:
      r[0] = 0;
      r[1] = 0;
      r[2] = 0;
      r[3] = 0;
      r[4] = 0;
      r[5] = 0;
      r[6] = 0;
      Serial.println("Hexadecimal incorrecto.");
      break;
  }

  // Shows display
  for (int i = 0; i < 7; i++)
    digitalWrite(pins[i], r[i] ? HIGH : LOW);
}

