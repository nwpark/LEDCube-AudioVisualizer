import java.util.Arrays;

public class ArrayShuffler<ArrayType>
{
  private int cubeSize;
  private int nextSmallestDistance;
  
  private ArrayList<ArrayType> twoDPyramidArray;
  private Pair<Integer, Boolean>[][] distFromCenter;
  
  // constructor
  public ArrayShuffler(int requiredCubeSize)
  {
    cubeSize = requiredCubeSize;
    
    // used for twoDPyramidSort
    nextSmallestDistance = (int)(cubeSize/2);
    distFromCenter = new Pair[8][8];
    
    // calculate this distance of each index from the centre of the cube
    for(int x=0; x < 8; x++)
    {
      for(int y=0; y < 8; y++)
      {
        distFromCenter[x][y]
          = new Pair<Integer, Boolean>
                    ((int)(sqrt(sq((x < 4) ? (3.5-x) : (x-3.5))
                                +sq((y < 4) ? (3.5-y) : (y-3.5)))), false);
      } // for
    } // for
  } // ArrayShuffler
  
  // reorder the given sorted array to have largest elements in the middle
  public <ArrayType> ArrayType[] pyramidSort(ArrayType[] sortedArray)
  {
    ArrayList<ArrayType> pyramidArray
      = new ArrayList<ArrayType>(Arrays.asList(sortedArray));
    int maxIndex = sortedArray.length - 1;
    int index = 0;
    while(index <= maxIndex / 2)
    {
      //pyramidArray[index] = sortedArray[index*2];
      sortedArray[index] = pyramidArray.get(index*2);
      if(maxIndex - index != index)
        //pyramidArray[maxIndex - index] = sortedArray[index*2 + 1];
        sortedArray[maxIndex - index] = pyramidArray.get(index*2 + 1);
      index++;
    } // while
    
    return sortedArray;
  } // pyramidSort
  
  // randomize the indexes of the elements in a given array
  public <ArrayType> ArrayType[] randomize(ArrayType[] anArray)
  {
    int index = anArray.length, randomIndex;
    ArrayType tempValue;
    
    while(index != 0)
    {
      randomIndex = (int)random(index);
      index--;
      
      tempValue = anArray[index];
      anArray[index] = anArray[randomIndex];
      anArray[randomIndex] = tempValue;
    } // while
    
    return anArray;
  } // randomize
  
  // stupid algorithm.. why did i make this recursive?? :S
  // reorders a sorted array to have the largest elements in the middle when
  // viewed as a 2d array
  public ArrayType[] twoDPyramidSort(ArrayType[] sortedArray)
  {
    // reset the booleans in distance array
    for(int x=0; x < 8; x++)
      for(int y=0; y < 8; y++)
        distFromCenter[x][y].second = false;
        
    twoDPyramidArray = new ArrayList<ArrayType>(Arrays.asList(sortedArray));
    
    for(int i=0; i < sortedArray.length; i++)
      insertAtSmallest(sortedArray[i]);

    nextSmallestDistance = (int)(cubeSize/2);
    
    return twoDPyramidArray.toArray(sortedArray);
  } // twoDPyramidSort
  
  // helper method for twoDPyramidSort algorithm
  private void insertAtSmallest(ArrayType objectToInsert)
  {
    if(nextSmallestDistance >= 0)
    {
      int i=0;
      for(int x=0; x < 8; x++)
        for(int y=0; y < 8; y++, i++)
          if(distFromCenter[x][y].first == nextSmallestDistance
                 && !distFromCenter[x][y].second)
          {
            twoDPyramidArray.set(i, objectToInsert);
            distFromCenter[x][y].second = true;
            return;
          } // if
      nextSmallestDistance--;
      insertAtSmallest(objectToInsert);
    } // if
  } // insertAtSmallest
  
  public Float[] boxFloatArray(float[] anArray)
  {
    Float[] floatObjectArray = new Float[anArray.length];
    for(int i=0; i < anArray.length; i++)
      floatObjectArray[i] = anArray[i];
      
    return floatObjectArray;
  } // floatToFloatObject
  
  public float[] unboxFloatArray(Float[] anArray)
  {
    float[] floatArray = new float[anArray.length];
    for(int i=0; i < anArray.length; i++)
      floatArray[i] = anArray[i];
      
    return floatArray;
  } // floatToFloatObject
  
} // class ArrayShuffler