TileSet tiles;
Palette palette;
Grid grid;
Viewport viewport;
String[] tilesetNames = {"landscapeTiles", "cityTiles"};
int activeTilesetIndex = 0;

void setup() {
  frameRate(15);
  colorMode(RGB, 255, 255, 255);
  size(1280, 720);

  tiles = new TileSet(tilesetNames);
  palette = new Palette(new TileSet(tilesetNames[activeTilesetIndex]), 6, 32);
  palette.load();
  
  grid = new Grid(60, 60, 7);
  grid.fill(palette.getTileAtIndex(121));
  viewport = new Viewport(grid, 0, 0, 7, 7, tiles, palette);
}

void draw() {
  clear();
  int[] location = getMouseGridLocation();
  viewport.setHoverpoint(location[0], location[1]);
  viewport.update();
  image(viewport.buffer, 0, 0);
  palette.setHoverpoint(mouseX - width + palette.buffer.width, mouseY);
  palette.update();
  image(palette.buffer, width - palette.buffer.width, 0);
}

void mouseClicked() {
  if(mouseX < width - palette.buffer.width) {
    int[] location = getMouseGridLocation();
    int col = location[0];
    int row = location[1];
    viewport.setTileAt(palette.getSelected(), col, row, viewport.hoverZ);
  }
  else {
    palette.setSelected(mouseX - width + palette.buffer.width, mouseY);
  }
}


void mouseDragged() {
  if(mouseX > width - palette.buffer.width) {
    palette.startDrag();
  }
}

void mouseReleased() {
  palette.stopDrag();
}

void keyPressed() {
  switch(key) {
    case '+' :  viewport.cursorZ(1);
                break;
    case '-' :  viewport.cursorZ(-1);
                break;
    case 'l' :  palette.load();
                break;
    case 't' :  viewport.toggleAlpha();
                break;
    case 'p' :  activeTilesetIndex++;
                activeTilesetIndex = activeTilesetIndex % tilesetNames.length;
                TileSet ts = new TileSet(tilesetNames[activeTilesetIndex]);
                palette.setTiles(ts);
                palette.load();
                break;
    case 's' :  palette.save();
                break;
    case 'x' :  viewport.clearHoverpointTile();
                break;
    case '<' :  viewport.addZMax(-1);
                break;
    case '>' :  viewport.addZMax(1);
                break;
    default  :  switch(keyCode) {
                  case UP    :  viewport.move(0, -1);
                                break;
                  case DOWN  :  viewport.move(0, 1);
                                break;
                  case LEFT  :  viewport.move(-1, 0);
                                break;
                  case RIGHT :  viewport.move(1, 0);
                                break;
                  default    :  // No action
                                break;
                }
                break;
  }
  
}

int[] getMouseGridLocation() {
    int x2d = (2 * (mouseY - 256) + (mouseX - 448)) / 2;
    int y2d = (2 * (mouseY - 256) - (mouseX - 448)) / 2;
    int col = x2d / 64;
    int row = y2d / 64;
    int[] result = new int[2];
    result[0] = col;
    result[1] = row;
    return result;
}