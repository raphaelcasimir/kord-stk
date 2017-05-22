/*
           Created/modified by the Application Engineering Group
  
                Questions, bug reports etc to:
  
                E. St. John-Olcayto
                Application Engineering Group 
                The MathWorks, Inc.
                24 Prime Park Way,
                Natick, MA 01760-1500
                Tel.    : (1) 508 647-7426 
                E-mail  : estjohn-olcayto@mathworks.com
                          (ender@mathworks.com)
 
                (c) The MathWorks, Inc.
  
     Filename           : sfun_time.c
     Author(s)          : Ender St. John-Olcayto
     Date created       : September 1, 1998
     Date last modified : June 17, 1999
     Modified by        : Ender St. John-Olcayto
     Description        : Level 2 (C-File) S-function source to delay a
                          simulink simulation so that it operates in
                          "simulated" real-time.  The simulation should be
                          able to run faster than real-time for this function
                          to be of use.
     Notes              : 1) This file is written using non-OS specific code.
                             Finer time-resolution may be achieved by using
                             real-time clocks and timers that are available in
                             systems such as POSIX-complient OSs.
                          2) Performance may suffer on UNIX-like systems due
                             to the non-real-time behavior of such OSs.
                          3) See matlabroot/simulink/src/sfuntmpl.doc
                             for a more detailed explanation of the functions
                             used in this file.
*/

/*
 * You must specify the S_FUNCTION_NAME as the name of your S-function
 * (i.e. replace sfuntmpl with the name of your S-function).
 */

#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  sfun_time

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h"

/*
 *  Include the standard ANSI C header for handling time functions:
 *  ---------------------------------------------------------------
 */
#include <time.h>

                         /*====================*
                          * S-function methods *
                          *====================*/

/*
     (Sub)-function     : mdlInitializeSizes
     Author(s)          : Ender St. John-Olcayto
     Date created       : September 1, 1998
     Date last modified : April 18, 1999
     Modified by        : Ender St. John-Olcayto
     Description        : Provides the sizes information to Simulink.

                          The sizes information is used by Simulink
                          to determine the S-Function block's
                          characteristics (number of inputs, outputs,
                          states, etc.).
*/
static void mdlInitializeSizes(SimStruct *S)
{
/*
 *  The number of expected parameters is 0:
 *  ---------------------------------------
 */
   ssSetNumSFcnParams(S, 0);  /* Number of expected parameters */

/*
 *  Get the expected number of parameters and return if this is
 *  different from the actual number parameters:
 *  --------------------------------------------
 */
   if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) 
   {
      return;
   }

/*
 *  This system has 0 continuous and 0 discrete states:
 *  ---------------------------------------------------
 */
    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

/*
 *  Set the number of input ports to be 1 (return on error):
 *  --------------------------------------------------------
 */
   if (!ssSetNumInputPorts(S, 1))
   {
      return;
   }
/*
 *  Input port 1 has a width of 1
 *  (I/P Port 1, signal 1 (1,1): Simulation time):
 *  ----------------------------------------------
 */
   ssSetInputPortWidth(S, 0, 1);

/*
 *  Direct feedthrough for I/P 1: YES
 *  ---------------------------------
 */
   ssSetInputPortDirectFeedThrough(S, 0, 1);
/*
 *  Set the number of output ports to be 1 (return on error):
 *  ---------------------------------------------------------
 */
   if (!ssSetNumOutputPorts(S, 1))
   {
      return;
   }

/*
 *  Output port 1 has a width of 3:
 *  -------------------------------
 */
   ssSetOutputPortWidth(S, 0, 3);

/*
 *  The number of sample times is 1 in this instance
 *  (need more than 1 for the case of discrete-time elements
 *  in this block.  Since this block does not have any discrete-time
 *  states, the number of sample times remains at 1 for this case):
 *  ---------------------------------------------------------------
 */
   ssSetNumSampleTimes(S, 1);

/*
 *  We need some memory to hold the processor time corresponding
 *  to a simulation time of t=0.  This next line allocates an array
 *  with one element and attaches it to the SimStruct:
 *  --------------------------------------------------
 */
   ssSetNumRWork(S, 1);

   ssSetNumIWork(S, 0);
   ssSetNumPWork(S, 0);
   ssSetNumModes(S, 0);
   ssSetNumNonsampledZCs(S, 0);

   ssSetOptions(S, 0);
}

/*
     (Sub)-function     : mdlInitializeSampleTimes
     Author(s)          : Ender St. John-Olcayto
     Date created       : September 1, 1998
     Date last modified : September 2, 1998
     Modified by        : Ender St. John-Olcayto
     Description        : This function is used to specify the sample 
                          time(s) for the S-function.  The same number of 
                          sample times as specified in ssSetNumSampleTimes
                          must be registered.
     Notes              : The sample times are:
                          1) Sample Time #1 : CONTINUOUS_SAMPLE_TIME
*/
static void mdlInitializeSampleTimes(SimStruct *S)
{
   ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
   ssSetOffsetTime(S, 0, 0.0);
   return;
}

#undef MDL_INITIALIZE_CONDITIONS   /* Change to #define to include function */
#if defined(MDL_INITIALIZE_CONDITIONS)
/*
     (Sub)-function     : mdlInitializeConditions
     Author(s)          : Ender St. John-Olcayto
     Date created       : September 1, 1998
     Date last modified : September 2, 1998
     Modified by        : Ender St. John-Olcayto
     Description        : In this function, the initial continuous and
                          discrete states should be set.  The initial
                          states are placed in the state vector [x_c', x_d']'.
                          The continuous and discrete states are accessed via 
                          the macros ssGetContStates(S) and 
                          ssGetRealDiscStates(S) respectively.

                          Other initialization activities can be performed
                          here but the author prefers to do these within
                          the function mdlStart in order to define tasks
                          more clearly.  However, this does result in the
                          additional overhead of another function call.

    Note                : This routine will be called at the start of 
                          simulation and if it is present in an enabled 
                          subsystem configured to reset states, it will be 
                          called when the enabled subsystem restarts execution 
                          to reset the states.
*/
static void mdlInitializeConditions(SimStruct *S)
{
   return;
}
#endif /* MDL_INITIALIZE_CONDITIONS */


#define MDL_START  /* Change to #undef to remove function */
#if defined(MDL_START) 
/*
     (Sub)-function     : mdlStart
     Author(s)          : Ender St. John-Olcayto
     Date created       : September 1, 1998
     Date last modified : September 2, 1998
     Modified by        : Ender St. John-Olcayto
     Description        : This function is called once at start of model 
                          execution.  Various start-up functionality is 
                          performed here.

                          In this case, the work-vectors are set to their
                          required values.
*/
static void mdlStart(SimStruct *S)
{
   real_T *p2t_RealWork, 
           t_StartTime;

   p2t_RealWork=ssGetRWork(S);

   t_StartTime=(real_T) clock();
   t_StartTime=t_StartTime/CLOCKS_PER_SEC;

   p2t_RealWork[0]=t_StartTime;

   return;
}
#endif /*  MDL_START */


/*
     (Sub)-function     : mdlOutputs
     Author(s)          : Ender St. John-Olcayto
     Date created       : September 1, 1998
     Date last modified : April 15, 1999
     Modified by        : Ender St. John-Olcayto
     Description        : The outputs of the S-function are computed here.
     Notes              : The outputs are:
                          1) The simulation time
                             (i/p #1 ==> direct feedthrough)
*/
static void mdlOutputs(SimStruct *S, int_T tid)
{
   real_T            *p2t_Yport1=NULL,
                      t_SimTime,
                      t_Diff=0.0,
                      t_StartTime,
                      t_CurrTime;

   InputRealPtrsType  t_Uport1=NULL;

/*
 *  Assign the pointer to each output port to separate variables:
 *  -------------------------------------------------------------
 */
   p2t_Yport1=ssGetOutputPortRealSignal(S, 0);

/*
 *  Assign the pointer to each input port to separate variables:
 *  ------------------------------------------------------------
 */
   t_Uport1 = ssGetInputPortRealSignalPtrs(S, 0);

   t_SimTime=*t_Uport1[0];
   t_StartTime=ssGetRWorkValue(S,0);

   while (t_Diff<t_SimTime)
   {
      t_CurrTime=(real_T) clock();
      t_CurrTime=(real_T) t_CurrTime/CLOCKS_PER_SEC;
      t_Diff=t_CurrTime-t_StartTime;
   }

   p2t_Yport1[0]=t_CurrTime;
   p2t_Yport1[1]=t_StartTime;
   p2t_Yport1[2]=t_SimTime;
   

   return;
}


#undef MDL_UPDATE  /* Change to #define to include function */
#if defined(MDL_UPDATE)
/*
     (Sub)-function     : mdlUpdate
     Author(s)          : Ender St. John-Olcayto
     Date created       : September 1, 1998
     Date last modified : September 2, 1998
     Modified by        : Ender St. John-Olcayto
     Description        : Discrete state updates are performed here.
                          Other tasks that need to be performed at each of
                          the various sample times can be done here as well.
*/
static void mdlUpdate(SimStruct *S, int_T tid)
{
   return;
}
#endif /* MDL_UPDATE */


#undef MDL_DERIVATIVES  /* Change to #define to include function */
#if defined(MDL_DERIVATIVES)
/*
     (Sub)-function     : mdlDerivatives
     Author(s)          : Ender St. John-Olcayto
     Date created       : September 1, 1998
     Date last modified : September 2, 1998
     Modified by        : Ender St. John-Olcayto
     Description        : Continuous state updates are performed here.
*/
static void mdlDerivatives(SimStruct *S)
{
   return;
}
#endif /* MDL_DERIVATIVES */


/*
     (Sub)-function     : mdlTerminate
     Author(s)          : Ender St. John-Olcayto
     Date created       : September 1, 1998
     Date last modified : June 17, 1999
     Modified by        : Ender St. John-Olcayto
     Description        : This function is used to perform any actions
                          that are necessary at the termination of a 
                          simulation.  For example, if memory was allocated 
                          in mdlInitializeConditions, this is the place to 
                          free it.
*/
static void mdlTerminate(SimStruct *S)
{
   return;
}

/*
 *  Required S-function trailer:
 *  ----------------------------
 */
#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
