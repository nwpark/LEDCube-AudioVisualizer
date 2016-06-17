import ddf.minim.Minim;
import ddf.minim.AudioPlayer;
import ddf.minim.analysis.FFT;
import processing.serial.*;

Minim minim;
AudioPlayer song;
FFT fft;

Serial arduinoPort;
String val;
byte[] outputArray;
Pair<Integer, Boolean>[][] distFromCenter;
int nextSmallest = 4;

float[] sum;
float[] spectrum;
float[] newSpectrum;
float smoothFactor = 0.2;
int bandsToDisplay = 64;
float rWidth;
 
void setup()
{
  size(640, 360);
  background(255);
  
  arduinoPort = new Serial(this, Serial.list()[1], 250000);
  arduinoPort.bufferUntil('\n');
 
  minim = new Minim(this);
 
  song = minim.loadFile("C:/Users/Nick/Downloads/music.mp3", 512);
  song.play();
 
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  initDistArray();
  
  sum = new float[bandsToDisplay];
  spectrum = new float[fft.specSize()];
  rWidth = width/float(bandsToDisplay);
  newSpectrum = new float[bandsToDisplay];
  
  outputArray = new byte[bandsToDisplay];
}

void draw()
{
  fill(#1A1F18, 70);
  rect(0, 0, width, height);
  fill(-1, 10);
  noStroke();

  fft.forward(song.mix);

  for(int i = 0; i < fft.specSize(); i++)
  {
    spectrum[i] = fft.getBand(i);
  }

  int bandsToAverage = fft.specSize() / bandsToDisplay;
  for(int i=0; i < bandsToDisplay; i++)
  {
    for(int j=i*bandsToAverage; j < (i+1)*bandsToAverage; j++)
      newSpectrum[i] += spectrum[j];
    newSpectrum[i] /= (fft.specSize() / bandsToDisplay);
    
    //newSpectrum[i] = (int)map(newSpectrum[i], 0, 5, 0, 8);
  }
  
  //newSpectrum = pyramidSort(sort(newSpectrum), bandsToDisplay - 1);
  newSpectrum = sort(newSpectrum);
  nextSmallest = 4;
  
  resetDistArray();
  
  for(int i = 0; i < bandsToDisplay; i++)
  {
    sum[i] += (newSpectrum[i] - sum[i]) * smoothFactor;
    insertAtSmallest((byte)map(sum[i], 0, 15, 0, 8));
    rect(i*rWidth, height, rWidth, -outputArray[i]*50);
  }
}

void serialEvent(Serial arduinoPort)
{
  val = arduinoPort.readStringUntil('\n');
  
  if(trim(val) != null)
  {
    arduinoPort.write(outputArray);
  }
}

float[] pyramidSort(float[] sortedArray, int maxIndex)
{
  float[] pyramidArray = new float[maxIndex + 1];
  int index = 0;
  while(index <= maxIndex / 2)
  {
    pyramidArray[index] = sortedArray[index*2];
    if(maxIndex - index != index)
      pyramidArray[maxIndex - index] = sortedArray[index*2 + 1];
    index++;
  }
  
  return pyramidArray;
}

void initDistArray()
{
  distFromCenter = new Pair[8][8];
  
  for(int x=0; x < 8; x++)
  {
    for(int y=0; y < 8; y++)
    {
      distFromCenter[x][y]
        = new Pair<Integer, Boolean>(int(sqrt(sq((x < 4) ? (3.5-x) : (x-3.5))
                                              +sq((y < 4) ? (3.5-y) : (y-3.5)))), false);
      print(distFromCenter[x][y].first + ", ");
    }
    println();
  }
}

void resetDistArray()
{
  for(int x=0; x < 8; x++)
    for(int y=0; y < 8; y++)
      distFromCenter[x][y].second = false;
}

void insertAtSmallest(byte noToInsert)
{
  if(nextSmallest >= 0)
  {
    int i=0;
    for(int x=0; x < 8; x++)
      for(int y=0; y < 8; y++, i++)
        if(distFromCenter[x][y].first == nextSmallest 
           && !distFromCenter[x][y].second)
        {
          outputArray[i] = noToInsert;
          distFromCenter[x][y].second = true;
          return;
        }
    nextSmallest--;
    insertAtSmallest(noToInsert);
  }
}

void stop()
{
  arduinoPort.clear();
  arduinoPort.stop();
}