// Variable for statespace regulation with sampletime 1/50 sek.
// LQR polplacering
static float phi11=1.006;       // phi matrix for estimator
static float phi12=0.02004;
static float phi21=0.5584;
static float phi22=1.006;
static float Lr=17.4708;        // estimator gain
static float gam1=0.0002002;    // gamma matrix for estimator
static float gam2=0.02004;
static float a=-0.7962;         // parameter for short stick
static float b=-27.87;
static float k1=0.2461;         // statespace feedback matrix K 
static float k2=105.5858;
static float k3=558.6803;
static float k4=2949.4;
float x1 = 0.0;                 // states for state space model
float x2 = 0.0;
float x3 = 0.0;
float x4 = 0.0;
float xm = 0.0;                 // temporary controller state
float u_volt = 0.0;             // output to motor in volts
float u = 0.0;                  // output to motor in IO-card value 0-4095
float n_bar = 0.2408;           // input reference gain
float y = 0.0;                  // angle between arm and pind  
int V_SS = 0;                   // output voltage as integer
static float V_deadzone=1.3;    // Deadzone voltage