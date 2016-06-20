public class Column
{
  public Pair<Integer, Integer>[] subColumnPositions;
  public byte columnHeight;
  
  public Column(int columnSize, Pair<Integer, Integer> columnPosition)
  {
    subColumnPositions = new Pair[(int)sq(columnSize)];
    
    int i=0;
    for(int x=0; x < columnSize; x++)
      for(int y=0; y < columnSize; y++, i++)
        subColumnPositions[i] = new Pair<Integer, Integer>(columnPosition.first + x,
                                                        columnPosition.second + y);
    columnHeight = 0;
  } // Column
  
  public void updateDisplay(ColumnDisplay columnDisplay)
  {
    for(Pair<Integer, Integer> columnPosition : subColumnPositions)
    {
      columnDisplay.displayArray[columnPosition.first][columnPosition.second]
        = columnHeight;
    }
  } // update
  
} // class Column