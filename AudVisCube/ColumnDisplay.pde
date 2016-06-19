public class ColumnDisplay
{
  private FFT fft;
  
  private ArrayShuffler<Float> arrayShuffler;
  
  private float[] spectrum, smoothSpectrum;
  private byte[][] displayArray;
  private byte[] outputArray;
  
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
  } // ColumnDisplay
  
  public void update()
  {
    fft.analyze(spectrum);
    
    Float[] spectrumAsFloat = arrayShuffler.boxFloatArray(sort(spectrum));
    spectrum
      = arrayShuffler.unboxFloatArray(arrayShuffler.pyramidSort(spectrumAsFloat));
    
    for(int i = 0; i < noOfColumns; i++)
    {
      smoothSpectrum[i] += (spectrum[i] - smoothSpectrum[i]) * smoothFactor;
      columns[i].columnHeight
        = (byte)map(smoothSpectrum[i]*height*8, 0, height, 0, 7);
      columns[i].updateDisplay(this);
    } // for
  } // update
  
  public byte[] output()
  {
    int i=0;
    for(int x=0; x < 8; x++)
      for(int y=0; y < 8; y++, i++)
        outputArray[i] = displayArray[y][x];
    
    return outputArray;
  }
  
} // class ColumnDisplay