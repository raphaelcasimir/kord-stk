
// VARIABLES
#define PWM 9
#define ENABLE_PIN 7
#define FREQ 2500

int Start = 0;
int Stop = 0;
int count = 0;
bool dir = false;
int up = 155;
int down = 100;

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
        Stop = millis();
        if(dir == true)
        {
            analogWrite(PWM, up);
        }


        if(dir == false)
        {
            analogWrite(PWM, down);

        }

    }
    if(dir == true)
        up = up + 3;
    else
        down = down - 3;
    count++;
    Serial.println(count);

    if(count == 8)
    {
        analogWrite(PWM, 127);
        while(1){};
    }


}