public class Column
{
  public Pair<Integer, Integer>[] subColumnPositions;
  public byte columnHeight;
  
  public Column(int columnSize, Pair<Integer, Integer> columnPosition)
  {
    subColumnPositions = new Pair[(int)sq(columnSize)];
    
    // calculate the coordinates of all sub columns needed to make up this column
    int i=0;
    for(int x=0; x < columnSize; x++)
      for(int y=0; y < columnSize; y++, i++)
        subColumnPositions[i] = new Pair<Integer, Integer>(columnPosition.first + x,
                                                        columnPosition.second + y);
                                                        
    // initial height is 0
    columnHeight = 0;
  } // Column
  
  // update the displayArray[][] in the given ColumnDisplay based this column's height
  public void updateDisplay(ColumnDisplay columnDisplay)
  {
    for(Pair<Integer, Integer> columnPosition : subColumnPositions)
    {
      columnDisplay.displayArray[columnPosition.first][columnPosition.second]
        = columnHeight;
    }
  } // update
  
} // class Column