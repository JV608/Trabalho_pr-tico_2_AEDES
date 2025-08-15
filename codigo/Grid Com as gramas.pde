
PImage grama1;
PImage grama2;

void setup() {
  size(800, 600);

  grama1 = loadImage("grama1.png");
  grama2 = loadImage("grama2.png");
}

void draw() {
  int gramaWidth = grama1.width;
  int gramaHeight = grama1.height;

  for (int x = 0; x < width; x += gramaWidth) {
    for (int y = 0; y < height; y += gramaHeight) {
      if ((x / gramaWidth + y / gramaHeight) % 2 == 0) {
        image(grama1, x, y);
      } else {
        image(grama2, x, y);
      }
      
    }
  }
}


