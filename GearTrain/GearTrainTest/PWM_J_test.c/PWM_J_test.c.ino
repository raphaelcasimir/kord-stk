
// VARIABLES
#define PWM 9
#define ENABLE_PIN 7
#define FREQ 500

int Start = 0;
int Stop = 0; 
int count = 0;
bool dir = false;

void setup() {
  Serial.begin(57600);
  pinMode(PWM, OUTPUT);
  pinMode(ENABLE_PIN, OUTPUT);
  digitalWrite(ENABLE_PIN, HIGH);
  /*while (1)
  {
    analogWrite(PWM, 140);
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
      analogWrite(PWM, 165);
      
    if(dir == false)
      analogWrite(PWM, 90);  
  }
  count++;
  Serial.println(count);
  
  if(count == 2)
  {
    analogWrite(PWM, 127);
    while(1){};
  }
    

}
