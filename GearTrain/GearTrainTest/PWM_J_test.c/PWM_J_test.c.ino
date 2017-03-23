// VARIABLES
#define PWM 9
#define ENABLE_PIN 7
#define FREQ 2000

int Start = 0;
int Stop = 0; 
int count = 0;
bool dir = false;

void setup() {
  Serial.begin(57600);
  pinMode(PWM, OUTPUT);
  pinMode(ENABLE_PIN, OUTPUT);
  digitalWrite(ENABLE_PIN, HIGH);
  /*while (Stop < 100)
  {
    Stop = millis();
    analogWrite(PWM, 150);
  }*/
}

void loop() {
  Start = millis();
  Stop = Start;
  dir = !dir;
  while(Stop - Start < FREQ)
  {
    Serial.print(Stop);
    Serial.print("     ");
    Serial.print(Start);
    Serial.print("\n");
    Stop = millis();
    if(dir == true)
      analogWrite(PWM, 200);
      
    if(dir == false)
      analogWrite(PWM, 54);  
  }
  count++;
  Serial.println(count);
  
  if(count == 5)
  {
    analogWrite(PWM, 127);
    while(1){};
  }
    

}
