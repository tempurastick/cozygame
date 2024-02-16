class Font {
  PImage fontSheet;
  PImage[] characters;
  int lineHeight;
  int base;
  int charCount;
  float spacing = 8;

  Font() {
    fontSheet = loadImage("WhitePeaberryOutline.png");
    parseFontInfo("WhitePeaberryOutline.xml");
  }

  // bitmap font so we pass whatever string we want in here
  void draw(String text, float x, float y) {
    for (int i = 0; i < text.length(); i++) {
      char letter = text.charAt(i);

      if (letter == ' ') { // Handle space character separately
        x += spacing; // Add spacing for the space character
      } else {
        // otherwise lowercase would register as empty
        if (Character.isLowerCase(letter)) {
          letter = Character.toUpperCase(letter);
        }
        // - ASCI
        int index = letter -32;
        if (index >= 0 && index < characters.length && characters[index] != null) {
          image(characters[index], x, y);
          x += characters[index].width-9; // Add some spacing between characters
        }
      }
    }
  }

  void parseFontInfo(String filename) {
    XML fontXML = loadXML(filename);
    if (fontXML != null) {
      XML info = fontXML.getChild("info");
      lineHeight = info.getInt("lineHeight");
      base = info.getInt("base");

      XML chars = fontXML.getChild("chars");
      charCount = chars.getInt("count");
      characters = new PImage[charCount];

      XML[] charElements = chars.getChildren("char");
      for (int i = 0; i < charElements.length; i++) {
        XML charElement = charElements[i];
        int id = charElement.getInt("id") - 32; // Subtract 32 to convert from 1-based index to 0-based index
        int x = charElement.getInt("x");
        int y = charElement.getInt("y");
        int width = charElement.getInt("width");
        int height = charElement.getInt("height");
        int xoffset = charElement.getInt("xoffset");
        int yoffset = charElement.getInt("yoffset");
        characters[id] = fontSheet.get(x, y, width, height);
      }
    } else {
      println("Error loading XML file");
    }
  }
}
