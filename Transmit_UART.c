
/**************************************************

file: Transmit_UART.c
purpose: a C code that transmits characters to
the serial port and print them on the screen.

program of rs232 files is a free software and downloded from http://www.teuniz.net/RS-232/.
More details about the author and copyright are in rs232.c and rs232.h.

compile with the command on the terminal: gcc Transmit_UART.c rs232.c -Wall -Wextra -o2 -o test_tx

test_tx.exe is used for compiling Transmit_UART.c. 
Run the transmit code by typing:
./test_tx


**************************************************/

#include <stdlib.h>
#include <stdio.h>
#ifdef _WIN32
#include <Windows.h>
#else
#include <unistd.h>
#endif
#include "rs232.h"



int main()
{  
	  cport_nr=8,        /* COM9 on windows */
      bdrate=9600;       /* 9600 baud rate*/

  char mode[]={'8','N','1',0},
  unsigned char testchar;    /*one byte*/

  testchar=15;           /*the data sent, default value is 15(F) */        

  
  if(RS232_OpenComport(cport_nr, bdrate, mode))   /* open the serial COM port*/
  {
    printf("Can not open comport\n");

    return(0);
  }
  
  while(1)
  {    
     RS232_SendByte(cport_nr, testchar); /*send a byte at a time*/
	 printf("sent: %d\n", testchar);

   #ifdef _WIN32
   Sleep(1000);
   #else
   usleep(1000000);  /* sleep for 1 Second */
   #endif     

  }

  return(0);
}

