import ddf.minim.Minim;
import ddf.minim.AudioPlayer;
import ddf.minim.analysis.FFT;
import processing.serial.*;

private static Minim minim;
private static AudioPlayer song;
private static FFT fft;

private static Serial arduinoPort = null;

private static CubeArraySorter<Byte> byteArraySorter;
private static CubeArraySorter<Float> floatArraySorter;

private static float[] spectrum, smoothSpectrum;
private static byte[] outputArray;

private static final int cubeSize = 8;
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
 
  minim = new Minim(this);
  song = minim.loadFile("C:/Users/Nick/Downloads/music.mp3", 512);
  song.play();
 
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  byteArraySorter = new CubeArraySorter<Byte>(cubeSize);
  floatArraySorter = new CubeArraySorter<Float>(cubeSize);
  
  spectrum = smoothSpectrum = new float[bandsToDisplay];
  outputArray = new byte[bandsToDisplay];
  rWidth = width / float(bandsToDisplay);
}

void draw()
{
  fill(#1A1F18, 70);
  rect(0, 0, width, height);
  fill(-1, 10);
  noStroke();

  fft.forward(song.mix);

  int bandsToAverage = fft.specSize() / bandsToDisplay;
  for(int i=0; i < bandsToDisplay; i++)
  {
    for(int j=i*bandsToAverage; j < (i+1)*bandsToAverage; j++)
      spectrum[i] += fft.getBand(j);
    spectrum[i] /= (fft.specSize() / bandsToDisplay);
  }

  spectrum = floatArraySorter.twoDPyramidSort(sort(spectrum));
  
  for(int i = 0; i < bandsToDisplay; i++)
  {
    smoothSpectrum[i] += (spectrum[i] - smoothSpectrum[i]) * smoothFactor;
    outputArray[i] = (byte)map(smoothSpectrum[i], 0, 15, 0, 8);
    rect(i*rWidth, height, rWidth, -outputArray[i]*50);
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

void stop()
{
  arduinoPort.clear();
  arduinoPort.stop();
}