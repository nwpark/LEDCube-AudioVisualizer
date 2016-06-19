#include "CubeInterface.h"

const byte ANODE_PINS[64][2] =
  {{6, 0}, {5, 0}, {4, 0}, {3, 0}, {2, 0}, {1, 0}, {0, 0}, {7, 0},
   {6, 2}, {5, 2}, {4, 2}, {3, 2}, {2, 2}, {1, 2}, {0, 2}, {7, 2},
   {6, 5}, {5, 5}, {4, 5}, {3, 5}, {2, 5}, {1, 5}, {0, 5}, {7, 5},
   {6, 7}, {5, 7}, {4, 7}, {3, 7}, {2, 7}, {1, 7}, {0, 7}, {7, 7},
   {6, 6}, {5, 6}, {4, 6}, {3, 6}, {2, 6}, {1, 6}, {0, 6}, {7, 6},
   {6, 4}, {5, 4}, {4, 4}, {3, 4}, {2, 4}, {1, 4}, {0, 4}, {7, 4},
   {6, 3}, {5, 3}, {4, 3}, {3, 3}, {2, 3}, {1, 3}, {0, 3}, {7, 3},
   {6, 1}, {5, 1}, {4, 1}, {3, 1}, {2, 1}, {1, 1}, {0, 1}, {7, 1}};

const byte CATHODE_PINS[8] = {0, 1, 2, 3, 4, 5, 6, 7};

boolean ledStatus[8][8][8];
byte currentLayer = 0;
byte cubeDelay;

const byte CLEAR_PIN = 12;
const byte CLOCK_PIN = 11;
const byte LATCH_PIN = 10;
const byte BLANK_PIN = 9;
const byte DATA_PIN = 8;

// constructor
CubeInterface::CubeInterface(byte requiredDelay)
{
  cubeDelay = requiredDelay;

  for(byte x = 0; x < 8; x++)
    for(byte y = 0; y < 8; y++)
      for(byte z = 0; z < 8; z++)
        ledStatus[x][y][z] = LOW;

  pinMode(CLEAR_PIN, OUTPUT);
  pinMode(CLOCK_PIN, OUTPUT);
  pinMode(LATCH_PIN, OUTPUT);
  pinMode(BLANK_PIN, OUTPUT);
  pinMode(DATA_PIN, OUTPUT);
  digitalWrite(CLEAR_PIN, HIGH);
  digitalWrite(BLANK_PIN, LOW);
} // CubeInterface

// destructor
CubeInterface::~CubeInterface(){}

void CubeInterface::light(byte x, byte y, byte z)
{
  ledStatus[x][y][z] = HIGH;
} // light

void CubeInterface::off(byte x, byte y, byte z)
{
  ledStatus[x][y][z] = LOW;
} // off

void CubeInterface::clearAll()
{
  for(byte x = 0; x < 8; x++)
    for(byte y = 0; y < 8; y++)
      for(byte z = 0; z < 8; z++)
        ledStatus[x][y][z] = LOW;
} // clearAll

void CubeInterface::clearColumn(byte x, byte y)
{
  for(byte z=0; z < 8; z++)
    ledStatus[x][y][z] = LOW;
} // clearColumn

void CubeInterface::highBit()
{
  digitalWrite(DATA_PIN, HIGH);
  digitalWrite(CLOCK_PIN, HIGH);
  digitalWrite(CLOCK_PIN, LOW);
  digitalWrite(DATA_PIN, LOW);
} // highBit

void CubeInterface::lowBit()
{
  digitalWrite(CLOCK_PIN, HIGH);
  digitalWrite(CLOCK_PIN, LOW);
} // lowBit

void CubeInterface::latch()
{
  digitalWrite(LATCH_PIN, HIGH);
  digitalWrite(LATCH_PIN, LOW);
} // latch

void CubeInterface::writeCube()
{
  for(byte i = 0; i < 8; i++)
  {
    if(CATHODE_PINS[i] == currentLayer)
      highBit();
    else
      lowBit();
  } // for

  for(byte i = 0; i < 64; i++)
    if(ledStatus[ANODE_PINS[i][0]]
                [ANODE_PINS[i][1]]
                [currentLayer] == HIGH)
      highBit();
    else
      lowBit();

  if(currentLayer < 7)
    currentLayer++;
  else
    currentLayer = 0;

  latch();
} // writeCube

void CubeInterface::wait(byte t)
{
  while(t > 0)
  {
    writeCube();
    delayMicroseconds(10);
    t--;
  } // while
} // wait
