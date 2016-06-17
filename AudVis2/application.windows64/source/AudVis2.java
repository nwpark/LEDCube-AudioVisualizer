import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.SoundFile; 
import processing.sound.FFT; 
import processing.sound.AudioDevice; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AudVis2 extends PApplet {





// Declare the processing sound variables 
SoundFile sample;
FFT fft;
AudioDevice device;

// Declare a scaling factor
int scale = 5;

// Define how many FFT bands we want
int bands = 128;
int bandsToDisplay = 15;
// declare a drawing variable for calculating rect width
float rWidth;

// Create a smoothing vector
float[] sum = new float[bands];

// Create a smoothing factor
float smooth_factor = 0.2f;

public void setup() {
  
  background(255);

  // If the Buffersize is larger than the FFT Size, the FFT will fail
  // so we set Buffersize equal to bands
  device = new AudioDevice(this, 44000, bands);

  // Calculate the width of the rects depending on how many bands we have
  rWidth = width/PApplet.parseFloat(bandsToDisplay);

  // Load and play a soundfile and loop it. This has to be called 
  // before the FFT is created.
  //sample = new SoundFile(this, "beat.aiff");
  sample = new SoundFile(this, "C:/Users/Nick/Downloads/music.mp3");
  sample.play();

  // Create and patch the FFT analyzer
  fft = new FFT(this, bands);
  fft.input(sample);
}      

public void draw() {
  // Set background color, noStroke and fill color
  //background(204);
  fill(0xff1A1F18, 70);
  rect(0, 0, width, height);
  //fill(0, 0, 255);
  fill(-1, 10);
  noStroke();

  fft.analyze();
  //fft.spectrum = pyramidSort(reverse(sort(fft.spectrum)));
  fft.spectrum = pyramidSort(sort(fft.spectrum), bandsToDisplay - 1);
  for (int i = 0; i < fft.spectrum.length; i++)
  {
    // Smooth the FFT data by smoothing factor
    sum[i] += (fft.spectrum[i] - sum[i]) * smooth_factor;

    // Draw the rects with a scale factor
    rect(i*rWidth, height, rWidth, -sum[i]*height*scale);
  }
}

public float[] pyramidSort(float[] sortedArray, int maxIndex)
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

public float[] randomize(float[] anArray)
{
  int currentIndex = 15;
  float tempValue;
  int randomIndex;
  
  while(currentIndex != 0)
  {
    randomIndex = PApplet.parseInt(random(8));
    
    tempValue = anArray[currentIndex];
    anArray[currentIndex] = anArray[randomIndex];
    anArray[randomIndex] = tempValue;
    currentIndex--;
  }
  
  return anArray;
}
  public void settings() {  size(640, 360); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "AudVis2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
