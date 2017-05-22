#include <stdio.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h> //Used by read() & close()
#include <stdlib.h>


#define MES_LEN 4
#define GET 10000
#define DELAY 200000

static int buffer[MES_LEN+1];
static char IntegerArray[3];

void int2char(int Integer);
int regulator_classical(float omega_value, float theta_a_value, float theta_p_value, float theta_a_ref);

int main(void)
{
	int length, i, intprint;
	int devnum,q=0,x;
	FILE *fp_usr;
	char destfile[] = "regulator_data.txt";
	char devicefile[] = "/dev/regulator_device";
  	
    devnum = open(devicefile, O_RDONLY);
    fp_usr = fopen(destfile, "w");
	
    while((q<=GET))
    {	
        for(x=0;x<=DELAY;x++);
    	length = read(devnum, buffer, MES_LEN);
    	printf("Faerdig om: %d\n", GET-q);
        for(i=0;i<=MES_LEN;)
        {
            int2char(buffer[i]);          
            for(intprint=0;intprint<=3;)
            {
                fputc(IntegerArray[intprint], fp_usr);
                intprint++;
            }
            fputc(0x20, fp_usr);
    	i++;
        }
        q++;
    }
    
    fclose(fp_usr);
    close(devnum);
    return 0;
}

void int2char(int Integer)
{
    unsigned char Thousands, Hundreds, Tens, Ones;
    Thousands = (Integer / 1000);
    Hundreds = (Integer - (Thousands*1000)) / 100;
    Tens = (Integer - (Thousands*1000) - (Hundreds*100)) / 10;
    Ones = (Integer - (Thousands*1000) - (Hundreds*100) - (Tens*10));
    IntegerArray[0] = Thousands+48;
    IntegerArray[1] = Hundreds+48;
    IntegerArray[2] = Tens+48;
    IntegerArray[3] = Ones+48;
}

