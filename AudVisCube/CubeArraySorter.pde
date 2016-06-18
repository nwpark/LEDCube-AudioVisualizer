public class CubeArraySorter<ArrayType>
{
  private int cubeSize;
  private int nextSmallestDistance;
  private Pair<Integer, Boolean>[][] distFromCenter;
  private float[] twoDPyramidArray;
  
  // constructor
  public CubeArraySorter(int requiredCubeSize)
  {
    cubeSize = requiredCubeSize;
    nextSmallestDistance = (int)(cubeSize/2);
    distFromCenter = new Pair[8][8];
    
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
  } // CubeArraySorter
  
  public float[] twoDPyramidSort(float[] anArray)
  {
    // reset the booleans in distance array
    for(int x=0; x < 8; x++)
      for(int y=0; y < 8; y++)
        distFromCenter[x][y].second = false;
        
    twoDPyramidArray = new float[(int)sq(cubeSize)];
    
    for(int i=0; i < twoDPyramidArray.length; i++)
      insertAtSmallest(anArray[i]);
      
    nextSmallestDistance = (int)(cubeSize/2);
      
    return twoDPyramidArray;
  } // twoDPyramidSort
  
  private void insertAtSmallest(float noToInsert)
  {
    if(nextSmallestDistance >= 0)
    {
      int i=0;
      for(int x=0; x < 8; x++)
        for(int y=0; y < 8; y++, i++)
          if(distFromCenter[x][y].first == nextSmallestDistance
             && !distFromCenter[x][y].second)
          {
            twoDPyramidArray[i] = noToInsert;
            distFromCenter[x][y].second = true;
            return;
          } // if
      nextSmallestDistance--;
      insertAtSmallest(noToInsert);
    } // if
  } // insertAtSmallest
  
  //public ArrayType[] twoDPyramidSort(ArrayType[] anArray)
  //{
  //  // reset the booleans in distance array
  //  for(int x=0; x < 8; x++)
  //    for(int y=0; y < 8; y++)
  //      distFromCenter[x][y].second = false;
        
  //  twoDPyramidArray = new Object[(int)sq(cubeSize)];
    
  //  for(int i=0; i < twoDPyramidArray.length; i++)
  //    insertAtSmallest(anArray[i]);
      
  //  nextSmallestDistance = (int)(cubeSize/2);
      
  //  return (ArrayType[])twoDPyramidArray;
  //} // twoDPyramidSort
  
  //private void insertAtSmallest(ArrayType objectToInsert)
  //{
  //  if(nextSmallestDistance >= 0)
  //  {
  //    int i=0;
  //    for(int x=0; x < 8; x++)
  //      for(int y=0; y < 8; y++, i++)
  //        if(distFromCenter[x][y].first == nextSmallestDistance
  //           && !distFromCenter[x][y].second)
  //        {
  //          twoDPyramidArray[i] = objectToInsert;
  //          distFromCenter[x][y].second = true;
  //          return;
  //        } // if
  //    nextSmallestDistance--;
  //    insertAtSmallest(objectToInsert);
  //  } // if
  //} // insertAtSmallest
  
  public ArrayType[] pyramidSort(ArrayType[] sortedArray, int maxIndex)
  {
    Object[] pyramidArray = new Object[maxIndex + 1];
    int index = 0;
    while(index <= maxIndex / 2)
    {
      pyramidArray[index] = sortedArray[index*2];
      if(maxIndex - index != index)
        pyramidArray[maxIndex - index] = sortedArray[index*2 + 1];
      index++;
    } // while
    
    return (ArrayType[])pyramidArray;
  } // pyramidSort
  
} // class CubeArraySorter