// Declara duas variáveis para armazenar as imagens
PImage tile1;
PImage tile2;

void setup() {
  // Define o tamanho da sua tela (pode alterar os valores)
  size(800, 600);
  
  // Carrega as imagens da pasta "data"
  tile1 = loadImage("grama1.png");
  tile2 = loadImage("grama2.png");
}

void draw() {
  // Pega a largura e altura da primeira imagem (assumindo que ambas têm o mesmo tamanho)
  int tileWidth = tile1.width;
  int tileHeight = tile1.height;
  
  // Cria um laço de repetição para percorrer a tela na horizontal (eixo x)
  for (int x = 0; x < width; x += tileWidth) {
    // Cria um laço de repetição para percorrer a tela na vertical (eixo y)
    for (int y = 0; y < height; y += tileHeight) {
      
      // Lógica para alternar as imagens e criar um padrão
      // A expressão (x / tileWidth + y / tileHeight) % 2 == 0 cria um efeito de xadrez
      if ((x / tileWidth + y / tileHeight) % 2 == 0) {
        image(tile1, x, y);
      } else {
        image(tile2, x, y);
      }
      
    }
  }
}
