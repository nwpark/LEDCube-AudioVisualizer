#include <TimerOne.h>
#include <CubeInterface.h>

CubeInterface cube(1);
byte inBuffer[64];
byte pattern[8][8];

void setup()
{
  Serial.begin(250000);
  for(byte i=0; i < 64; i++)
    inBuffer[i] = 0;
}

void loop()
{
  cube.wait(10);

  // request an update
  Serial.println('R');
}

// process an update - method called when there is serial input
void serialEvent()
{
  Serial.readBytes(inBuffer, sizeof(inBuffer));
  
  if(inBuffer != NULL)
  {
    //cube.clearAll();
    cube.reduceAlphaAll(2);
    byte i=-1;
    for(byte x=0; x < 8; x++)
      for(byte y=0; y < 8; y++, i++)
      {
        if(inBuffer[i] > 8)
          inBuffer[i] = 8;
        byte height = inBuffer[i];
        while(height > 0)
        {
          cube.light(x, y, height-1);
          height--;
        }
      }
  }
}
