public class PyramidDisplay implements Display
{
  private FFT fft;
  
  private ArrayShuffler<Float> arrayShuffler;
  
  private float[] spectrum, smoothSpectrum;
  private byte[][] displayArray;
  private byte[] outputArray;
  
  // constructor
  public PyramidDisplay(FFT requiredFFT)
  {
    fft = requiredFFT;
    
    arrayShuffler = new ArrayShuffler<Float>(8);
    
    spectrum = new float[64];
    smoothSpectrum = new float[64];
    
    displayArray = new byte[8][8];
    outputArray = new byte[64];
  } // ColumnDisplay
  
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
      //rect(i*rWidth, height, rWidth, -outputArray[i]*height/7);
      //rect(i*rWidth, height, rWidth, -smoothSpectrum[i]*height*5);
    }
  } // update
  
  public byte[] output()
  {
    return outputArray;
  }
  
} // class ColumnDisplay