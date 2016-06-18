#include <TimerOne.h>
#include <CubeInterface.h>

CubeInterface cube(1);
byte inBuffer[64];
byte pattern[8][8];

void setup()
{
  Serial.begin(250000);
  for(int i=0; i < 64; i++)
    inBuffer[i] = 0;
}

void loop()
{
  cube.wait(10);

  // request an update
  Serial.println('R');
}

// process the update - method called when there is serial input
void serialEvent()
{
  Serial.readBytes(inBuffer, sizeof(inBuffer));
  
  if(inBuffer != NULL)
  {
    cube.clearAll();
    int i=0;
    for(int x=0; x < 8; x++)
      for(int y=0; y < 8; y++, i++)
      {
        if(inBuffer[i] > 7)
          inBuffer[i] = 7;
        int height = inBuffer[i];
        if(height > 0)
          while(height >= 0)
          {
            cube.light(x, y, height);
            height--;
          }
      }
  }
}
