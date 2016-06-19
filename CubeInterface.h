#ifndef CubeInterface_H
#define CubeInterface_H

#include <Arduino.h>

class CubeInterface
{
  public:
    CubeInterface(int requiredDelay);
    ~CubeInterface();
    void light(int x, int y, int z);
    void off(int x, int y, int z);
    void clearAll();
    void clearColumn(byte x, byte y);
    void writeCube();
    void wait(int t);
    void copyArray();
  private:
    void highBit();
    void lowBit();
    void latch();
};

#endif
