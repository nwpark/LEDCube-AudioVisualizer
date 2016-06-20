import processing.sound.SoundFile;
import processing.sound.FFT;
import processing.serial.*;

private static SoundFile song;
private static FFT fft;

private static Serial arduinoPort = null;

private static ArrayShuffler<Float> floatArrayShuffler;

private static float[] spectrum, smoothSpectrum;
private static byte[] outputArray;

private static ColumnDisplay smallColumnDisplay, fourColumnDisplay,
                             nineColumnDisplay, sixtyfourColumnDisplay;
private static PyramidDisplay pyramidDisplay;
private static DesktopDisplay desktopDisplay;

private static final int cubeSize = 8;
private static final int bandsToAnalyse = 128;

private enum State { COLUMNS4, COLUMNS9, COLUMNS64, PYRAMID }
private static State currentState;
private static Display currentDisplay;

void setup()
{
  size(640, 360);
  background(255);
  
  // open a connection to the arduino (serial port at index 1)
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
  
  // start playing the song 52 seconds in
  song = new SoundFile(this, "C:/Users/Nick/Downloads/music.mp3");
  song.cue(52);
  song.play();
  
  // create a Fast Fourier Transform and give it the current playing song
  fft = new FFT(this, bandsToAnalyse);
  fft.input(song);
  // start playing song again because fft constructor breaks stuff >.<
  song.play();
  
  // initialize all of the display modes
  init64ColumnDisplay();
  init9ColumnDisplay();
  init4ColumnDisplay();
  initSmallColumnDisplay();
  pyramidDisplay = new PyramidDisplay(fft);
  desktopDisplay = new DesktopDisplay(fft);
  
  // set initial display to show off
  // smallColumnDisplay, fourColumnDisplay, nineColumnDisplay,
  // sixtyfourColumnDisplay
  currentState = State.COLUMNS4;
  currentDisplay = fourColumnDisplay;
} // setup

void draw()
{
  // update the display showing on the computer
  desktopDisplay.update();
  // update the display showing on the led cube
  currentDisplay.update();
} // draw

// this method is called every time serial input is detected
void serialEvent(Serial arduinoPort)
{
  String val = arduinoPort.readStringUntil('\n');
  
  // check if arduino sent a request and send it the current output
  if(trim(val) != null)
    arduinoPort.write(currentDisplay.output());
} // serialEvent

private void init64ColumnDisplay()
{
  Column[] columns = new Column[64];
  int i=0;
  for(int x=0; x < 8; x++)
    for(int y=0; y < 8; y++, i++)
      columns[i] = new Column(1, new Pair<Integer, Integer>(x, y));
  sixtyfourColumnDisplay = new ColumnDisplay(64, columns, fft);
} // init64ColumnDisplay

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
} // init9ColumnDisplay

private void init4ColumnDisplay()
{
  Column[] columns = new Column[4];
  columns[0] = new Column(3, new Pair<Integer, Integer>(0, 0));
  columns[1] = new Column(3, new Pair<Integer, Integer>(0, 5));
  columns[2] = new Column(3, new Pair<Integer, Integer>(5, 0));
  columns[3] = new Column(3, new Pair<Integer, Integer>(5, 5));
  fourColumnDisplay = new ColumnDisplay(4, columns, fft);
} // init4ColumnDisplay

private void initSmallColumnDisplay()
{
  Column[] columns = new Column[4];
  columns[0] = new Column(2, new Pair<Integer, Integer>(1, 1));
  columns[1] = new Column(2, new Pair<Integer, Integer>(1, 5));
  columns[2] = new Column(2, new Pair<Integer, Integer>(5, 1));
  columns[3] = new Column(2, new Pair<Integer, Integer>(5, 5));
  smallColumnDisplay = new ColumnDisplay(4, columns, fft);
} // initSmallColumnDisplay

void stop()
{
  arduinoPort.clear();
  arduinoPort.stop();
  song.stop();
} // stop