public class PyramidDisplay implements Display
{
  private FFT fft;
  
  private ArrayShuffler<Float> arrayShuffler;
  
  private float[] spectrum, smoothSpectrum;
  private byte[] outputArray;
  
  private final float smoothFactor = 0.2;
  private final int bandsToDisplay = 64;
  
  // constructor
  public PyramidDisplay(FFT requiredFFT)
  {
    fft = requiredFFT;
    
    arrayShuffler = new ArrayShuffler<Float>(8);
    
    spectrum = new float[64];
    smoothSpectrum = new float[64];
    
    outputArray = new byte[64];
  } // PyramidDisplay
  
  public void update()
  {
    //fadeBands();
    
    fft.analyze();
    
    for(int i=0; i < 16; i++)
    {
      for(int j=i*4; j < (i+1)*4; j++)
        spectrum[j] = fft.spectrum[i];
    }
    
    Float[] spectrumAsFloat = arrayShuffler.boxFloatArray(sort(spectrum));
    spectrum
      = arrayShuffler.unboxFloatArray(arrayShuffler.twoDPyramidSort(spectrumAsFloat));
    
    for(int i = 0; i < bandsToDisplay; i++)
    {
      smoothSpectrum[i] += (spectrum[i] - smoothSpectrum[i]) * smoothFactor;
      outputArray[i] = (byte)map(smoothSpectrum[i]*height*6, 0, height, 0, 7);
    }
  } // update
  
  public byte[] output()
  {
    return outputArray;
  } // output
  
} // class ColumnDisplay