import processing.sound.SoundFile;
import processing.sound.FFT;
import processing.serial.*;

private static SoundFile song;
private static FFT fft;

private static Serial arduinoPort = null;

private static CubeArraySorter<Byte> byteArraySorter;
private static CubeArraySorter<Float> floatArraySorter;

private static float[] spectrum, smoothSpectrum;
private static byte[] outputArray;

private static final int cubeSize = 8;
private static final int bandsToAnalyse = 128;
private static final int bandsToDisplay = 64;
private static final float smoothFactor = 0.2;
private static float rWidth;
 
void setup()
{
  size(640, 360);
  background(255);
  
  try
  {
    arduinoPort = new Serial(this, Serial.list()[1], 250000);
    arduinoPort.bufferUntil('\n');
  }
  catch(ArrayIndexOutOfBoundsException e)
    { println("No serial port available at index 1"); }
  catch(NullPointerException e)
    { println("Failed to open serial port"); }
  
  byteArraySorter = new CubeArraySorter<Byte>(cubeSize);
  floatArraySorter = new CubeArraySorter<Float>(cubeSize);
  
  spectrum = new float[bandsToDisplay];
  smoothSpectrum = new float[bandsToDisplay];
  outputArray = new byte[bandsToDisplay];
  rWidth = width / float(bandsToDisplay);
  
  song = new SoundFile(this, "C:/Users/Nick/Downloads/music.mp3");
  song.cue(52);
  song.play();
 
  fft = new FFT(this, bandsToAnalyse);
  fft.input(song);
  song.play();
}

void draw()
{
  fadeBands();

  fft.analyze();
  
  for(int i=0; i < 16; i++)
  {
    for(int j=i*4; j < (i+1)*4; j++)
      spectrum[j] = fft.spectrum[i];
  }

  spectrum = floatArraySorter.twoDPyramidSort(sort(spectrum));
  
  for(int i = 0; i < bandsToDisplay; i++)
  {
    smoothSpectrum[i] += (spectrum[i] - smoothSpectrum[i]) * smoothFactor;
    outputArray[i] = (byte)map(smoothSpectrum[i]*height*6, 0, height, 0, 7);
    //rect(i*rWidth, height, rWidth, -outputArray[i]*height/7);
    rect(i*rWidth, height, rWidth, -smoothSpectrum[i]*height*5);
  }
}

void serialEvent(Serial arduinoPort)
{
  String val = arduinoPort.readStringUntil('\n');
  
  if(trim(val) != null)
  {
    arduinoPort.write(outputArray);
  }
}

private void fadeBands()
{
  fill(#1A1F18, 70);
  rect(0, 0, width, height);
  fill(-1, 10);
  noStroke();
}

void stop()
{
  arduinoPort.clear();
  arduinoPort.stop();
  song.stop();
}