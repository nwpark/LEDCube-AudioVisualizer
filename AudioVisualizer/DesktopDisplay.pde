public class DesktopDisplay implements Display
{
  private FFT fft;
  
  private ArrayShuffler<Float> arrayShuffler;
  
  private float[] spectrum, smoothSpectrum;
  private byte[][] displayArray;
  private byte[] outputArray;
  
  private final float smoothFactor = 0.2;
  private final int bandsToDisplay = 16;
  private float rWidth;
  
  // constructor
  public DesktopDisplay(FFT requiredFFT)
  {
    fft = requiredFFT;
    
    arrayShuffler = new ArrayShuffler<Float>(8);
    
    spectrum = new float[bandsToDisplay];
    smoothSpectrum = new float[bandsToDisplay];
    
    outputArray = new byte[64];
    
    rWidth = width / float(bandsToDisplay);
  } // DesktopDisplay
  
  public void update()
  {
    fadeBands();
    
    fft.analyze(spectrum);
    
    Float[] spectrumAsFloat = arrayShuffler.boxFloatArray(sort(spectrum));
    spectrum
      = arrayShuffler.unboxFloatArray(arrayShuffler.pyramidSort(spectrumAsFloat));
    
    for(int i = 0; i < bandsToDisplay; i++)
    {
      smoothSpectrum[i] += (spectrum[i] - smoothSpectrum[i]) * smoothFactor;
      rect(i*rWidth, height, rWidth, -smoothSpectrum[i]*height*5);
    }
  } // update
  
  private void fadeBands()
  {
    fill(#1A1F18, 70);
    rect(0, 0, width, height);
    fill(-1, 10);
    noStroke();
  } // fadeBands
  
  public byte[] output()
  {
    return outputArray;
  }
  
} // class ColumnDisplay