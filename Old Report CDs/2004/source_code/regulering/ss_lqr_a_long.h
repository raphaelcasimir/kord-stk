// Variable for statespace regulation with sampletime 1/50 sek.
// LQR polplacering
static float phi11=1.003;       // phi matrix for estimator
static float phi12=0.02002;
static float phi21=0.279;
static float phi22=1.003;
static float Lr=13.0359;        // estimator gain
static float gam1=0.0002001;    // gamma matrix for estimator
static float gam2=0.02002;
static float a=-0.7962/2.0;         // parameter for short stick
static float b=-27.87/2.0;
static float k1=0.2448;         // statespace feedback matrix K 
static float k2=100.529;
static float k3=465.5189;
static float k4=1737.8;
float x1 = 0.0;                 // states for state space model
float x2 = 0.0;
float x3 = 0.0;
float x4 = 0.0;
float xm = 0.0;                 // temporary controller state
float u_volt = 0.0;             // output to motor in volts
float u = 0.0;                  // output to motor in IO-card value 0-4095
float n_bar = 24.1759;           // input reference gain
float y = 0.0;                  // angle between arm and pind  
int V_SS = 0;                   // output voltage as integer
static float V_deadzone=1.3;    // Deadzone voltage
