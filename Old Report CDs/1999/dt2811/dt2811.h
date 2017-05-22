\begin{verbatim}
#define MODE 0
#define GAIN 0

void dt2811_init(); /* Initialize */
float dt2811_setFreq(float freq); /* Set frequency */
void dt2811_setChannel(int channel, float value); /* Make convertion */
float dt2811_getChannel(int channel); /* Read convertion */
void installIntrVect( void interrupt (*InterruptRoutine)() ); /* Install interrupt routine */
void uninstallIntrVect(); /* Uninstall interrupt routine */

#include "dt2811.c"
\end{verbatim}
