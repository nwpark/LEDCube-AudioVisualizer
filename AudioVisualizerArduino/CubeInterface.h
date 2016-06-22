#ifndef CubeInterface_H
#define CubeInterface_H

#include <Arduino.h>

class CubeInterface
{
  public:
    CubeInterface(byte requiredDelay);
    ~CubeInterface();
    void light(byte x, byte y, byte z);
    void lightLayer(byte layer);
    void off(byte x, byte y, byte z);
    void clearAll();
    void clearLayer(byte layer);
    void clearColumn(byte x, byte y);
    void writeCube();
    void wait(int t);
    boolean ledStatus[8][8][8];
  private:
    void highBit();
    void lowBit();
    void latch();
};

#endif
