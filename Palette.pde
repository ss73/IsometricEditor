class Palette {

  TileSet tiles;
  int columns;
  String[] items;
  int boxSize;
  int paletteWidth;
  int paletteHeight;
  int ratio;
  int selectedIndex = -1;
  int lastSelectedIndex = -1;
  int hoverIndex = -1;
  int lastHoverIndex = -1;
  int dragImageIndex = -1;
  PGraphics buffer;
  
  Palette(TileSet tiles, int columns, int boxSize) {
    this.tiles = tiles;
    this.columns = columns;
    this.boxSize = boxSize;
    items = tiles.getNames();
    paletteWidth = boxSize * columns;
    paletteHeight = boxSize * (1 + (items.length / columns));
    ratio = tiles.get(items[0]).width / boxSize;
    buffer = createGraphics(paletteWidth, paletteHeight);
  }
  
  void setTiles(TileSet tiles) {
    this.tiles = tiles;
    items = tiles.getNames();
    paletteHeight = boxSize * (1 + (items.length / columns));
    ratio = tiles.get(items[0]).width / boxSize;
    buffer = createGraphics(paletteWidth, paletteHeight);
  }
  
  void update() {
    buffer.beginDraw();
    buffer.background(64, 80, 80);
    for(int i = 0; i < items.length; i++) {
      drawTile(i);
    }
    buffer.endDraw();
  }

 void drawTile(int i) {
    PImage tile;
    tile = tiles.get(items[i]);
    int x = boxSize * (i % columns);
    int y = 0 + boxSize * (i / columns); 
    if(i == selectedIndex) {
      buffer.fill(128, 160, 160);
      buffer.rect(x, y, boxSize - 1, boxSize - 1);
    }
    buffer.noFill();
    if(i == hoverIndex) {
      buffer.stroke(255, 255, 255, 128);
    }
    else {
      buffer.stroke(255, 255, 255, 16);
    }
    buffer.image(tile, x, y, boxSize, tile.height/ratio);
    if(dragImageIndex != -1 && i == hoverIndex) {
      PImage dragTile = tiles.get(items[dragImageIndex]);
      buffer.image(dragTile, x, y, boxSize, dragTile.height/ratio);
    }
    buffer.rect(x, y, boxSize - 1, boxSize - 1);
 }

 void setHoverpoint(int x, int y) {
   if(x > 0 && y > 0 && x < paletteWidth && y < paletteHeight) {
     int col = x / boxSize;
     int row = y / boxSize;
     hoverIndex = row * columns + col;
   }
   else {
     hoverIndex = -1;
   }
 }
 
 void startDrag() {
   if(dragImageIndex == -1) {
     dragImageIndex = hoverIndex;
   }
 }
 synchronized void stopDrag() {
   if(dragImageIndex != -1 && hoverIndex >= 0 && hoverIndex < items.length) {
     String[] resorted = new String[items.length];
     String dragged = items[dragImageIndex];
     if(hoverIndex < dragImageIndex) {
       for(int i = 0; i < hoverIndex; i++) {
         resorted[i] = items[i];
       }
       resorted[hoverIndex] = dragged;
       for(int i = hoverIndex + 1; i <= dragImageIndex; i++) {
         resorted[i] = items[i - 1];
       }
       for(int i = dragImageIndex + 1; i < resorted.length; i++) {
         resorted[i] = items[i];
       }
       items = resorted;
     }
     else if(hoverIndex > dragImageIndex) {
       for(int i = 0; i < dragImageIndex; i++) {
         resorted[i] = items[i];
       }
       for(int i = dragImageIndex; i < hoverIndex; i++) {
         resorted[i] = items[i + 1];
       }
       resorted[hoverIndex] = dragged;
       for(int i = hoverIndex + 1; i < resorted.length; i++) {
         resorted[i] = items[i];
       }
       items = resorted;
     }
   }
   dragImageIndex = -1;
 }
 void setSelected(int x, int y) {
   if(x > 0 && y > 0 && x < paletteWidth && y < paletteHeight) {
     int col = x / boxSize;
     int row = y / boxSize;
     selectedIndex = row * columns + col;
     //println(items[selectedIndex]);
   }
 }
 
 String getSelected() {
   return selectedIndex < 0 ? null : items[selectedIndex];
 }
 
 String getTileAtIndex(int index) {
   return items[index];
 }
 
 int getSelectedIndex() {
   return selectedIndex;
 }
 
 void save() {
   saveStrings(tiles.name, items);
 }
 
 void load() {
   String[] vieworder = loadStrings("data/" + tiles.name);
   if(vieworder != null)
     items = vieworder;
 }
}