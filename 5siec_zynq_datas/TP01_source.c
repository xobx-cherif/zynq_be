/*********************************************************************************
** Zynq native ARM A9 programming examples : Core0 timer examples ****************
** By: Bilel CHERIF **************************************************************
** Note: This example uses the scu timer to controll the mio pin 7 and ***********
** change the pin signal each time the loaded ticks are consumed *****************
** the autoload option is active so the pin will reverse its state over and  *****
** over forever ******************************************************************
**********************************************************************************/

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include"xgpiops.h"

//timer and gic header files
#include "xscugic.h"
#include "xil_exception.h"
#include "xscutimer.h"

#define GPIO_ID 		XPAR_PS7_GPIO_0_DEVICE_ID
#define TIMER_DEVICE_ID		XPAR_XSCUTIMER_0_DEVICE_ID
#define INTC_DEVICE_ID		XPAR_SCUGIC_SINGLE_DEVICE_ID
#define TIMER_IRPT_INTR		XPAR_SCUTIMER_INTR



#define TIMER_LOAD_VALUE	32500000
#define LED_PIN 7
#define B1 50
#define B2 51

static XGpioPs led;		//GPIO
static XScuGic Intc; 		//GIC
static XScuTimer Timer;		//timer


static void SetupInterruptSystem(XScuGic *GicInstancePtr,
		XScuTimer *TimerInstancePtr, u16 TimerIntrId);

static void TimerIntrHandler(void *CallBackRef);

XGpioPs_Config * gpio_config;
XScuTimer_Config *TMRConfigPtr;     //timer config

u8 toggle=1;
u8 presc=0;

int main()
{



    init_platform();

    init();

    //printf("\n\rINSA COURSE BY BILEL \n\r");


    while(1){

    	if(XGpioPs_ReadPin(&led, B1)==1){
    		presc++;

    		XScuTimer_SetPrescaler(&Timer,presc );
    		printf("the prescalar is %d ",XScuTimer_GetPrescaler(&Timer));
    		XScuTimer_LoadTimer(&Timer, TIMER_LOAD_VALUE);
    		XScuTimer_EnableAutoReload(&Timer);
    		XScuTimer_Start(&Timer);
    		while(XGpioPs_ReadPin(&led, B1)==1);
    		}

    	if(XGpioPs_ReadPin(&led, B2)==1){
    	    		presc--;
    	    		if (presc < 0) presc=0;

    	    		XScuTimer_SetPrescaler(&Timer,presc );
    	    		printf("the prescalar is %d ",XScuTimer_GetPrescaler(&Timer));
    	    		XScuTimer_LoadTimer(&Timer, TIMER_LOAD_VALUE);
    	    		XScuTimer_EnableAutoReload(&Timer);
    	    		XScuTimer_Start(&Timer);
    	    		while(XGpioPs_ReadPin(&led, B2)==1);
    	 	}

    //XGpioPs_WritePin(&led, LED_PIN, toggle);

    }

    printf("should never reach this region \n\r");

    cleanup_platform();
    return 0;
}



void init(){

	gpio_config = XGpioPs_LookupConfig(GPIO_ID);

	XGpioPs_CfgInitialize(&led, gpio_config,
				gpio_config->BaseAddr);

	XGpioPs_SetDirectionPin(&led, LED_PIN, 1);
	XGpioPs_SetOutputEnablePin(&led, LED_PIN, 1);

	XGpioPs_SetDirectionPin(&led, B1, 0);
	XGpioPs_SetDirectionPin(&led, B2, 0);

	//timer initialisation
	TMRConfigPtr = XScuTimer_LookupConfig(TIMER_DEVICE_ID);
	 XScuTimer_CfgInitialize(&Timer, TMRConfigPtr,
					TMRConfigPtr->BaseAddr);
	 XScuTimer_SelfTest(&Timer);
	 //load the timer
	 XScuTimer_LoadTimer(&Timer, TIMER_LOAD_VALUE);
	 XScuTimer_EnableAutoReload(&Timer);


	 //set up the interrupts
	 SetupInterruptSystem(&Intc, &Timer,TIMER_IRPT_INTR);

	 //start timer
	 XScuTimer_Start(&Timer);



}

static void SetupInterruptSystem(XScuGic *GicInstancePtr,
		XScuTimer *TimerInstancePtr, u16 TimerIntrId)
{

	XScuGic_Config *IntcConfig; //GIC config
	//Xil_ExceptionInit();
	//initialise the GIC
	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	XScuGic_CfgInitialize(GicInstancePtr, IntcConfig,
					IntcConfig->CpuBaseAddress);
    	//connect to the hardware
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
				(Xil_ExceptionHandler)XScuGic_InterruptHandler,
				GicInstancePtr);

	//set up the timer interrupt
	XScuGic_Connect(GicInstancePtr, TimerIntrId,
					(Xil_ExceptionHandler)TimerIntrHandler,
					(void *)TimerInstancePtr);
	//enable the interrupt for the Timer at GIC
	XScuGic_Enable(GicInstancePtr, TimerIntrId);
	//enable interrupt on the timer
	XScuTimer_EnableInterrupt(TimerInstancePtr);
	// Enable interrupts in the Processor.
	Xil_ExceptionEnableMask(XIL_EXCEPTION_IRQ);
}

static void TimerIntrHandler(void *CallBackRef)
{

	XScuTimer *TimerInstancePtr = (XScuTimer *) CallBackRef;
	XScuTimer_ClearInterruptStatus(TimerInstancePtr);
	toggle=!toggle;
	XGpioPs_WritePin(&led, LED_PIN, toggle);
	printf("****Timer Event!!!!!!!!!!!!!****\n\r");
	printf("the prescalar is %d ",XScuTimer_GetPrescaler(&Timer));

}

