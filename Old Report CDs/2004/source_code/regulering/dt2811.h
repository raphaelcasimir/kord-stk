void dt2811_init(void);
void dt2811_write_DAC(int nDA, int dig_val);
int dt2811_read_ADC(void);
void trigger(void);

//I/O-card address register definitons (mnemonics)
#define BASE_ADDRESS 0x2E8			//Base Address of I/O-card
#define ADCSR BASE_ADDRESS + 0		//The A/D Control/Staus Register
#define ADGCR BASE_ADDRESS + 1		
#define ADDAT_LOW BASE_ADDRESS + 2
#define ADDAT_HIGH BASE_ADDRESS + 3
#define DADAT_LOW BASE_ADDRESS + 4
#define DADAT_HIGH BASE_ADDRESS + 5
#define DIOP BASE_ADDRESS + 6
#define TMRCTR BASE_ADDRESS + 7
