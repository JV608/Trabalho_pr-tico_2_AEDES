class Parede {
  float x, y;
  float custo;
  PImage imagem;
  
  // NOVAS VARIÁVEIS para o sistema de vida
  float vidaMax = 100; // Vida inicial da parede
  float vidaAtual;
  
  // Variáveis para converter posições do mouse em índices de grid
  int linha, coluna;

  Parede(float x, float y, float custo, PImage img) {
    this.x = x;
    this.y = y;
    this.custo = custo;
    this.imagem = img;
    this.vidaAtual = vidaMax;
    
    // Calcula a linha e coluna a partir das coordenadas
    // Essas variáveis são úteis para remover o obstáculo do grafo
    float l = width / (float)f;
    float h = (height - faixaAltura) / (float)n;
    this.coluna = (int)(x / l);
    this.linha = (int)((y - faixaAltura) / h);
  }
  
  void show() {
    float l = width / (float)f;
    float h = (height - faixaAltura) / (float)n;
    image(imagem, this.x - l / 2, this.y - h / 2, l, h);
    showBarraVida();
  }
  
  void showBarraVida() {
    float l = width / (float)f;
    float vidaBarraLargura = l * (vidaAtual / vidaMax);
    
    // Fundo da barra de vida (cinza)
    fill(50, 50, 50);
    noStroke();
    rect(x - l/2, y - 25, l, 5);
    
    // Barra de vida (verde)
    fill(0, 255, 0);
    rect(x - l/2, y - 25, vidaBarraLargura, 5);
  }
  
  // NOVO: Método para a parede tomar dano
  void tomarDano(float dano) {
    vidaAtual -= dano;
    if (vidaAtual < 0) {
      vidaAtual = 0;
    }
  }
  
  // NOVO: Método para verificar se a parede foi destruída
  boolean foiDestruida() {
    return vidaAtual <= 0;
  }
  
  // NOVOS MÉTODOS para obter as coordenadas do grid
  int getLinha() {
    return this.linha;
  }
  
  int getColuna() {
    return this.coluna;
  }
}
