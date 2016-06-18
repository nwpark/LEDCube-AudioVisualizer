import processing.sound.SoundFile;
import processing.sound.FFT;
import processing.sound.AudioDevice;

SoundFile sample;
FFT fft;
AudioDevice device;

// Scaling factor
int scale = 5;

// Number of FFT bands
int bands = 128;
int bandsToDisplay = 32;

float rWidth;

// Create a smoothing vector
float[] sum = new float[bands];

// Create a smoothing factor
float smooth_factor = 0.2;

void setup() {
  size(640, 360);
  background(255);

  // If the Buffersize is larger than the FFT Size, the FFT will fail
  // so we set Buffersize equal to bands
  device = new AudioDevice(this, 44000, bands);

  // Set width to fit all rectangles on screen
  rWidth = width/float(bandsToDisplay);

  // Load and play a soundfile and loop it. This has to be called 
  // before the FFT is created.
  //sample = new SoundFile(this, "beat.aiff");
  sample = new SoundFile(this, "C:/Users/Nick/Downloads/music.mp3");
  sample.play();

  // Create and patch the FFT analyzer
  fft = new FFT(this, bands);
  fft.input(sample);
  sample.play();
}      

void draw() {
  // Set background color, noStroke and fill color
  //background(204);
  fill(#1A1F18, 70);
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

float[] randomize(float[] anArray)
{
  int currentIndex = 15;
  float tempValue;
  int randomIndex;
  
  while(currentIndex != 0)
  {
    randomIndex = int(random(8));
    
    tempValue = anArray[currentIndex];
    anArray[currentIndex] = anArray[randomIndex];
    anArray[randomIndex] = tempValue;
    currentIndex--;
  }
  
  return anArray;
}

void stop()
{
  sample.stop();
}