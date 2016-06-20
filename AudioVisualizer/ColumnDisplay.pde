public class ColumnDisplay implements Display
{
  private FFT fft;
  
  private ArrayShuffler<Float> arrayShuffler;
  
  private float[] spectrum, smoothSpectrum;
  private byte[][] displayArray;
  private byte[] outputArray;
  
  private static final float smoothFactor = 0.2;
  private int shuffleTimeout;
  
  private int noOfColumns;
  private Column[] columns;
  
  // constructor
  public ColumnDisplay(int requiredNoOfColumns, Column[] requiredColumns,
                       FFT requiredFFT)
  {
    fft = requiredFFT;
    
    arrayShuffler = new ArrayShuffler<Float>(8);
    
    noOfColumns = requiredNoOfColumns;
    columns = requiredColumns;
    
    spectrum = new float[noOfColumns];
    smoothSpectrum = new float[noOfColumns];
    
    displayArray = new byte[8][8];
    outputArray = new byte[64];
    
    shuffleTimeout = millis();
  } // ColumnDisplay
  
  // update the displayArray[][] based 
  public void update()
  {
    // get the current frequency bands of the audio and store them in spectrum
    fft.analyze(spectrum);
    
    //Float[] spectrumAsFloat = arrayShuffler.boxFloatArray(sort(spectrum));
    //spectrum
    //  = arrayShuffler.unboxFloatArray(arrayShuffler.pyramidSort(spectrumAsFloat));
    
    // update the height of each column
    for(int i = 0; i < noOfColumns; i++)
    {
      // smooth out the rate at which each value in the spectrum changes
      smoothSpectrum[i] += (spectrum[i] - smoothSpectrum[i]) * smoothFactor;
      // map the spectrum value to a value between 0 and 7 (height of cube)
      columns[i].columnHeight
        = (byte)map(smoothSpectrum[i]*height*8, 0, height, 0, 7);
      // column objects update this dispayArray[][] based on their height
      columns[i].updateDisplay(this);
    } // for
    
    // calculate the average amplitude at the current time in the audio
    int meanAmplitude = 0;
    for(Column column : columns)
      meanAmplitude += column.columnHeight;
    meanAmplitude /= noOfColumns;
    
    // randomly shuffle the columns if the amplitude is below 2
    if(meanAmplitude <= 2 && millis() >= shuffleTimeout)
    {
      columns = arrayShuffler.randomize(columns);
      // dont shuffle columns more than 4 times per second
      shuffleTimeout = millis() + 250;
    }
  } // update
  
  // return the arry to be sent to the microcontroller
  public byte[] output()
  {
    // copy the 2d displayArray into a single dimensional array
    int i=0;
    for(int x=0; x < 8; x++)
      for(int y=0; y < 8; y++, i++)
        outputArray[i] = displayArray[y][x];
    
    return outputArray;
  } // output
  
} // class ColumnDisplay