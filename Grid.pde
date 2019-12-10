class Grid {
  String[][][] gridTiles;
  int xSize;
  int ySize;
  int zSize;
  
  public Grid(int xSize, int ySize, int zSize) {
    this.xSize = xSize;
    this.ySize = ySize;
    this.zSize = zSize;
    gridTiles = new String[xSize][ySize][zSize];
  }
  
  void fill(String tile) {
    for(int y = 0; y < ySize; y++) {
      for(int x = 0; x < xSize; x++) {
        setTileAt(tile, x, y, 0);
      }
    }
  }
  
  void setTileAt(String tile, int x, int y, int z) {
    if(x >= 0 && x < xSize && y >= 0 && y < ySize && z >= 0 && z < zSize) {
      gridTiles[x][y][z] = tile;
    }
    else {
      //gridTiles[x][y][z] = tile;
      println("bummer x, y, z = " + x + ", " + y + ", " + z);
    }
  }
  
  String getTileAt(int x, int y, int z) {
    return gridTiles[x][y][z];
  }
  
  void clearTileAt(int x, int y, int z) {
    gridTiles[x][y][z] = null;
  }
  
  void copyGridInto(Grid source, int x0, int y0) {
    for(int z = 0; z < source.zSize; z++) {
      for(int y = y0; y < source.ySize; y++) {
        for(int x = x0; x < source.xSize; x++) {
          String tile = source.getTileAt(x, y, z);
          setTileAt(tile, x0 + x, y0 + y, z); 
        }
      }
    }
  }
  
  Grid getViewport(int x0, int y0, int w, int h) {
    Grid result = new Grid(w, h, zSize);
    for(int z = 0; z < zSize; z++) {
      for(int y = y0; y < y0 + h; y++) {
        for(int x = x0; x < x0 + w; x++) {
          String tile = getTileAt(x, y, z);
          result.setTileAt(tile, x - x0, y - y0, z); 
        }
      }
    }
    return result;
  }
}