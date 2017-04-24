// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input on analog pin 0:
  int PotArm = analogRead(A0);
  int PotStick = analogRead(A1);
  if (PotArm >= 381 && PotArm <= 670)
  {
    int MappedPotArm1 = map(PotArm, 381, 670, 0, 90);
  }
  if (PotArm <= 380 && PotArm >= 89)
  {
    int MapedPotArm2 = map(PotArm, 380, 89, 0, -90);
  }
  if (PotStick >= 535 && PotStick <= 823)
  {
    int MappedPotStick1 = map(PotStick, 535, 823, 0, 90);
  }
  if (PotStick <= 534 && PotStick >= 248)
  {
    int MappedPotStick2 = map(PotStick, 534, 248, 0, -90);
  }
  delay(1);        // delay in between reads for stability
}
