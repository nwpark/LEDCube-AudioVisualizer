#ifndef CubeInterface_H
#define CubeInterface_H

#include <Arduino.h>

class CubeInterface
{
  public:
    CubeInterface(byte requiredDelay);
    ~CubeInterface();
    void light(byte x, byte y, byte z);
    void off(byte x, byte y, byte z);
    void clearAll();
    void clearColumn(byte x, byte y);
    void writeCube();
    void wait(byte t);
  private:
    void highBit();
    void lowBit();
    void latch();
};

#endif
