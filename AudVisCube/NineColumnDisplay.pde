public class NineColumnDisplay
{
  private FFT fft;
  
  private CubeArraySorter<Float> arraySorter;
  
  private float[] spectrum, smoothSpectrum;
  private byte[][] displayArray;
  private byte[] outputArray;
  private Column[] columns;
  
  // constructor
  public NineColumnDisplay(FFT requiredFFT)
  {
    fft = requiredFFT;
    
    arraySorter = new CubeArraySorter<Float>(8);
    
    columns = new Column[9];
    columns[0] = new Column(2, new Pair<Integer, Integer>(0, 0));
    columns[1] = new Column(2, new Pair<Integer, Integer>(0, 3));
    columns[2] = new Column(2, new Pair<Integer, Integer>(0, 6));
    columns[3] = new Column(2, new Pair<Integer, Integer>(3, 0));
    columns[4] = new Column(2, new Pair<Integer, Integer>(3, 3));
    columns[5] = new Column(2, new Pair<Integer, Integer>(3, 6));
    columns[6] = new Column(2, new Pair<Integer, Integer>(6, 0));
    columns[7] = new Column(2, new Pair<Integer, Integer>(6, 3));
    columns[8] = new Column(2, new Pair<Integer, Integer>(6, 6));
    
    spectrum = new float[9];
    smoothSpectrum = new float[9];
    
    displayArray = new byte[8][8];
    outputArray = new byte[64];
  } // NineColumnDisplay
  
  public void update()
  {
    fft.analyze(spectrum);
    
    Float[] spectrumAsFloat = arraySorter.floatToFloatObject(sort(spectrum));
    spectrum
      = arraySorter.floatObjectToFloat(arraySorter.pyramidSort(spectrumAsFloat));
    
    for(int i = 0; i < 9; i++)
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
  
} // class NineColumnDisplay