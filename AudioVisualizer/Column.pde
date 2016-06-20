public class Column
{
  public Pair<Integer, Integer>[] columnPositions;
  public byte columnHeight;
  
  public Column(int columnSize, Pair<Integer, Integer> columnPosition)
  {
    columnPositions = new Pair[(int)sq(columnSize)];
    
    int i=0;
    for(int x=0; x < columnSize; x++)
      for(int y=0; y < columnSize; y++, i++)
        columnPositions[i] = new Pair<Integer, Integer>(columnPosition.first + x,
                                                        columnPosition.second + y);
    columnHeight = 0;
  } // Column
  
  public void updateDisplay(ColumnDisplay columnDisplay)
  {
    for(Pair<Integer, Integer> columnPosition : columnPositions)
    {
      columnDisplay.displayArray[columnPosition.first][columnPosition.second]
        = columnHeight;
    }
  } // update
  
} // class Column