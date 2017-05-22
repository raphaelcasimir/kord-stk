//Motorregulator: PI (gamle model)
static float K_ff=0.265;   /*initierende værdier for R_arm[k-1] og e_pind[k-1]*/
static float K_a=1100.0;
static float K_p=-400.0; //Must be negative. Consult slja02|csje02 for explanation.
static float V_f=0;
static float Kaw=40000;
