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
boolean nextStatus[8][8][8];
int currentLayer = 0;
int cubeDelay;

const int CLEAR_PIN = 12;
const int CLOCK_PIN = 11;
const int LATCH_PIN = 10;
const int BLANK_PIN = 9;
const int DATA_PIN = 8;

// constructor
CubeInterface::CubeInterface(int requiredDelay)
{
  cubeDelay = requiredDelay;

  for(int x = 0; x < 8; x++)
    for(int y = 0; y < 8; y++)
      for(int z = 0; z < 8; z++)
        ledStatus[x][y][z] = LOW;

  pinMode(CLEAR_PIN, OUTPUT);
  pinMode(CLOCK_PIN, OUTPUT);
  pinMode(LATCH_PIN, OUTPUT);
  pinMode(BLANK_PIN, OUTPUT);
  pinMode(DATA_PIN, OUTPUT);
  digitalWrite(CLEAR_PIN, HIGH);
  digitalWrite(BLANK_PIN, LOW);
}

// destructor
CubeInterface::~CubeInterface(){}

void CubeInterface::light(int x, int y, int z)
{
  ledStatus[x][y][z] = HIGH;
}

void CubeInterface::off(int x, int y, int z)
{
  ledStatus[x][y][z] = LOW;
}

void CubeInterface::clearAll()
{
  for(int x = 0; x < 8; x++)
    for(int y = 0; y < 8; y++)
      for(int z = 0; z < 8; z++)
        ledStatus[x][y][z] = LOW;
}

void CubeInterface::nextUpdate()
{
  nextStatus[x][y][z] = HIGH;
}

void CubeInterface::update()
{
  for(int x=0; x < 8; x++)
    for(int y=0; y < 8; y++)
      for(int z=0; z < 8; z++)
        ledStatus[x][y][z] = nextStatus[x][y][z];
}

void CubeInterface::clearNextStatus()
{
  for(int x = 0; x < 8; x++)
    for(int y = 0; y < 8; y++)
      for(int z = 0; z < 8; z++)
        ledStatus[x][y][z] = LOW;
}

void CubeInterface::highBit()
{
  digitalWrite(DATA_PIN, HIGH);
  digitalWrite(CLOCK_PIN, HIGH);
  digitalWrite(CLOCK_PIN, LOW);
  digitalWrite(DATA_PIN, LOW);
}

void CubeInterface::lowBit()
{
  digitalWrite(CLOCK_PIN, HIGH);
  digitalWrite(CLOCK_PIN, LOW);
}

void CubeInterface::latch()
{
  digitalWrite(LATCH_PIN, HIGH);
  digitalWrite(LATCH_PIN, LOW);
}

void CubeInterface::writeCube()
{
  for(int i = 0; i < 8; i++)
  {
    if(CATHODE_PINS[i] == currentLayer)
      highBit();
    else
      lowBit();
  }

  for(int i = 0; i < 64; i++)
    if(oldStatus[ANODE_PINS[i][0]]
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
}

void CubeInterface::wait(int t)
{
  while(t >= 0)
  {
    for(int i = 0; i < 8; i++)
    {
      if(CATHODE_PINS[i] == currentLayer)
        highBit();
      else
        lowBit();
    }

    for(int i = 0; i < 64; i++)
      if(ledStatus[ANODE_PINS[i][0]]
                  [ANODE_PINS[i][1]]
                  [currentLayer] == HIGH)
        highBit();
      else
        lowBit();

    // top 2 layers aint work :(
    if(currentLayer < 7)
      currentLayer++;
    else
      currentLayer = 0;

    latch();
    delayMicroseconds(10);
    t-=2;
  }
}
