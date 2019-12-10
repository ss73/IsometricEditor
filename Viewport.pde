class Viewport {
  PGraphics buffer;
  Grid grid;
  Grid world;
  TileSet tiles;
  Palette palette;
  int hoverX = -1;
  int hoverY = -1;
  int hoverZ = 0;
  int worldX = -1;
  int worldY = -1;
  int zMax;
  boolean alpha = false;
  
  Viewport(Grid world, int x, int y, int w, int h, TileSet tiles, Palette palette) {
    this.world = world;
    worldX = x;
    worldY = y;
    this.grid = world.getViewport(x, y, w, h);
    zMax = grid.xSize;
    this.tiles = tiles;
    this.palette = palette;
    buffer = createGraphics(1024, 720);
  }
  
  void setHoverpoint(int col, int row, int layer) {
    hoverX = col;
    hoverY = row;
    hoverZ = layer;
  }

  int[] getHoverpoint() {
    int[] coords = new int[3];
    coords[0] = hoverX; coords[1] = hoverY; coords[2] = hoverZ;
    return coords;
  }

  void setHoverpoint(int col, int row) {
    hoverX = col;
    hoverY = row;
  }
  
  void toggleAlpha() {
    alpha = !alpha;
  }
  
  void cursorZ(int delta) {
    hoverZ = hoverZ + delta;
  }

  void addZMax(int delta) {
    zMax = zMax + delta;
    if(zMax < 1) {
      zMax = 1;
    }
    else if (zMax > grid.zSize) {
      zMax = grid.zSize;
    }
  }
  
  void clearHoverpointTile() {
    setTileAt(null, hoverX, hoverY, hoverZ);
  }
  
  void setTileAt(String tile, int x, int y, int z) {
    grid.setTileAt(tile, x, y, z);
    world.setTileAt(tile, worldX + x, worldY + y, z);
  }
  
  void move(int deltaX, int deltaY) {
    worldX = worldX + deltaX;
    worldY = worldY + deltaY;
    if (worldX < 0 ) {
      worldX = 0;
    }
    else if (worldX >= world.xSize - grid.xSize) {
      worldX = world.xSize - grid.xSize;
    }
    if (worldY < 0 ) {
      worldY = 0;
    }
    else if (worldY >= world.ySize - grid.ySize) {
      worldY = world.ySize - grid.ySize;
    }
    grid = world.getViewport(worldX, worldY, grid.xSize, grid.ySize);
    //println("x=" + worldX + " y=" + worldY + " w=" + grid.xSize + " h=" + grid.ySize);
  }
  
  void update() {
    buffer.beginDraw();
    buffer.clear();
    for(int y = 0; y < grid.ySize; y++) {
      for(int x = 0; x < grid.xSize; x++) {
        for(int z = 0; z < grid.zSize && z < zMax; z++) {
          if(grid.getTileAt(x, y, z) != null) {
            PImage tile = tiles.get(grid.getTileAt(x, y, z));
            int yOffset = 64 - tile.height - z * 16; 
            if(alpha) {
              buffer.tint(255, 140 - 10 * z);
            }
            else {
              buffer.tint(255, 255);
            }
            buffer.image(tile, 384 + (x - y) * 64, 256 + yOffset + (y + x) * 32);
          }
          if(x == hoverX && y == hoverY && palette.getSelectedIndex() >= 0) {
            PImage tile = tiles.get(palette.getSelected());
            int yOffset = 64 - tile.height - hoverZ * 16; 
            buffer.tint(255, 126);
            buffer.image(tile, 384 + (x - y) * 64, 256 + yOffset + (y + x) * 32);
            buffer.tint(255, 255);
          }
        }
      }
    }
    buffer.endDraw();
  }
}