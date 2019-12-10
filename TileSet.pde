class TileSet {
  
  HashMap tiles = new HashMap();
  String name;
  
  TileSet(String name) {
    this.name = name;
    load(name);
  }

  TileSet(String[] names) {
    for(int i = 0; i < names.length; i++) {
      load(names[i]);
    }
  }


  void load(String filename) {
    XML xml = loadXML(filename + "_sheet.xml");
    PImage spriteSheet = loadImage(xml.getString("imagePath"));

    XML[] children = xml.getChildren("SubTexture");
    for (int i = 0; i < children.length; i++) {
      String name = children[i].getString("name");
      int x = children[i].getInt("x");
      int y = children[i].getInt("y");
      int w = children[i].getInt("width");
      int h = children[i].getInt("height");
      //println(name + " : " + x + ", " + y + " [" + w + ", " + h + "]");
      PImage img = spriteSheet.get(x, y, w, h);
      //img.resize(128, 0);
      tiles.put(name, img);
    }
  }
  
  PImage get(String name) {
    return (PImage)tiles.get(name);
  }
  
  int getSize() {
    return tiles.size();
  }
  
  String[] getNames() {
    int x = 0;
    String[] result = new String[getSize()];
    for(java.util.Iterator i = tiles.keySet().iterator(); i.hasNext();) {
      result[x++] = (String)i.next();
    }
    return result;
  }
}