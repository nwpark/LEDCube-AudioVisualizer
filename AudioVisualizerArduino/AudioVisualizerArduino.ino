#include <TimerOne.h>
#include "CubeInterface.h"

CubeInterface *cube;
// holds the array retrieved from serial input
byte inBuffer[64];
byte pattern[8][8];

void setup()
{
  // high baud rate to minimize delay and subsequently
  // flickering
  Serial.begin(250000);

  cube = new CubeInterface(1);
  
  for(int i=0; i < 64; i++)
    inBuffer[i] = 0;
}

void loop()
{
  // delay 10 milliseconds
  cube->wait(10);
  
  // request an update
  Serial.println('R');
}

// process an update - method called when there is serial input
void serialEvent()
{
  // read the serial input (expecting 64 bytes)
  // store the bytes in an array
  Serial.readBytes(inBuffer, sizeof(inBuffer));

  // update the cube display based on the input
  if(inBuffer != NULL)
  {
    // apparantly arduino executes additional for loop
    // statements before the first itteration so i=-1
    int i=-1;
    for(int x=0; x < 8; x++)
    {
      // helps with flickering
      cube->writeCube();
      
      for(int y=0; y < 8; y++, i++)
      {
        setColumnHeight(x, y, inBuffer[i]);
      } // for
    } // for
  } // if
} // serialEvent

void setColumnHeight(byte x, byte y, byte height)
{
  // turn off all leds in the column before writing
  // the new height to it
  cube->clearColumn(x, y);
  
  // max height is 8
  if(height > 8)
    height = 8;
  
  // turn on all leds in thecolumn from 0 up to height 
  while(height > 0)
  {
    cube->light(x, y, height-1);
    height--;
  } // while
} // setColumnHeight

