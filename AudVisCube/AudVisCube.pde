import processing.sound.SoundFile;
import processing.sound.FFT;
import processing.serial.*;

private static SoundFile song;
private static FFT fft;

private static Serial arduinoPort = null;

private static ArrayShuffler<Float> floatArrayShuffler;

private static float[] spectrum, smoothSpectrum;
private static byte[] outputArray;

private static ColumnDisplay nineColumnDisplay;
private static ColumnDisplay fourColumnDisplay;
private static ColumnDisplay sixtyfourColumnDisplay;

private static final int cubeSize = 8;
private static final int bandsToAnalyse = 128;
private static final int bandsToDisplay = 64;
private static final float smoothFactor = 0.2;
private static float rWidth;

private enum State { COLUMNS4, COLUMNS9, COLUMNS64 }
private static State currentState;

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
  
  floatArrayShuffler = new ArrayShuffler<Float>(cubeSize);
  
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
  
  init64ColumnDisplay();
  init9ColumnDisplay();
  init4ColumnDisplay();
  
  currentState = State.COLUMNS4;
}

void draw()
{
  //fadeBands();

  //fft.analyze();
  
  //for(int i=0; i < 16; i++)
  //{
  //  for(int j=i*4; j < (i+1)*4; j++)
  //    spectrum[j] = fft.spectrum[i];
  //}

  //spectrum = floatArrayShuffler.twoDPyramidSort(sort(spectrum));
  
  //for(int i = 0; i < bandsToDisplay; i++)
  //{
  //  smoothSpectrum[i] += (spectrum[i] - smoothSpectrum[i]) * smoothFactor;
  //  outputArray[i] = (byte)map(smoothSpectrum[i]*height*6, 0, height, 0, 7);
  //  //rect(i*rWidth, height, rWidth, -outputArray[i]*height/7);
  //  rect(i*rWidth, height, rWidth, -smoothSpectrum[i]*height*5);
  //}
  switch(currentState)
  {
    case COLUMNS4 :
      fourColumnDisplay.update();
      break;
    case COLUMNS9 :
      nineColumnDisplay.update();
      break;
    case COLUMNS64 :
      sixtyfourColumnDisplay.update();
      break;
  }
}

void serialEvent(Serial arduinoPort)
{
  String val = arduinoPort.readStringUntil('\n');
  
  if(trim(val) != null)
  {
    //arduinoPort.write(fourColumnDisplay.output());
    switch(currentState)
    {
      case COLUMNS4 :
        arduinoPort.write(fourColumnDisplay.output());
        break;
      case COLUMNS9 :
        arduinoPort.write(nineColumnDisplay.output());
        break;
      case COLUMNS64 :
        arduinoPort.write(sixtyfourColumnDisplay.output());
        break;
    }
  }
}

private void init64ColumnDisplay()
{
  Column[] columns = new Column[64];
  int i=0;
  for(int x=0; x < 8; x++)
    for(int y=0; y < 8; y++, i++)
      columns[i] = new Column(1, new Pair<Integer, Integer>(x, y));
  sixtyfourColumnDisplay = new ColumnDisplay(64, columns, fft);
}

private void init9ColumnDisplay()
{
  Column[] columns = new Column[9];
  columns[0] = new Column(2, new Pair<Integer, Integer>(0, 0));
  columns[1] = new Column(2, new Pair<Integer, Integer>(0, 3));
  columns[2] = new Column(2, new Pair<Integer, Integer>(0, 6));
  columns[3] = new Column(2, new Pair<Integer, Integer>(3, 0));
  columns[4] = new Column(2, new Pair<Integer, Integer>(3, 3));
  columns[5] = new Column(2, new Pair<Integer, Integer>(3, 6));
  columns[6] = new Column(2, new Pair<Integer, Integer>(6, 0));
  columns[7] = new Column(2, new Pair<Integer, Integer>(6, 3));
  columns[8] = new Column(2, new Pair<Integer, Integer>(6, 6));
  nineColumnDisplay = new ColumnDisplay(9, columns, fft);
}

private void init4ColumnDisplay()
{
  Column[] columns = new Column[4];
  columns[0] = new Column(3, new Pair<Integer, Integer>(0, 0));
  columns[1] = new Column(3, new Pair<Integer, Integer>(0, 5));
  columns[2] = new Column(3, new Pair<Integer, Integer>(5, 0));
  columns[3] = new Column(3, new Pair<Integer, Integer>(5, 5));
  fourColumnDisplay = new ColumnDisplay(4, columns, fft);
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