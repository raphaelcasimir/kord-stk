#define PWM 9
#define ENABLE_PIN 7

void setup() {
  // put your setup code here, to run once:
  pinMode(PWM, OUTPUT);
  pinMode(ENABLE_PIN, OUTPUT);
  digitalWrite(ENABLE_PIN, HIGH);
}

void loop() {
  // put your main code here, to run repeatedly:
  analogWrite(PWM, 155);
  
}
