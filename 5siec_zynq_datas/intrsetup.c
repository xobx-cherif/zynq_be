#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include"xgpiops.h"

//timer and gic header files
#include "xscugic.h"
#include "xil_exception.h"
#include "xscutimer.h"


#define TIMER_DEVICE_ID		XPAR_XSCUTIMER_0_DEVICE_ID
#define INTC_DEVICE_ID		XPAR_SCUGIC_SINGLE_DEVICE_ID
#define TIMER_IRPT_INTR		XPAR_SCUTIMER_INTR

#define TIMER_LOAD_VALUE	0xEE6B280


#define GPIO_ID XPAR_PS7_GPIO_0_DEVICE_ID
#define LED_PIN 7


// periph instances
XGpioPs led;
static XScuGic Intc; //GIC
static XScuTimer Timer;//timer


//config ptrs
	XGpioPs_Config * gpio_config;


	XScuTimer_Config *TMRConfigPtr; 


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
	printf("****Timer Event!!!!!!!!!!!!!****\n\r");
	printf("the prescalar is %d ",XScuTimer_GetPrescaler(&Timer));

}
