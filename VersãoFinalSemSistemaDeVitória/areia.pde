class Areia{
  float x, y;
  float custo;
  PImage imagem;

  
  // Variáveis para converter posições do mouse em índices de grid
  int linha, coluna;

  Areia(float x, float y, float custo, PImage img) {
    this.x = x;
    this.y = y;
    this.custo = custo;
    this.imagem = img;
    
 
    float l = width / (float)f;
    float h = (height - faixaAltura) / (float)n;
    this.coluna = (int)(x / l);
    this.linha = (int)((y - faixaAltura) / h);
  }
  
  void show() {
    float l = width / (float)f;
    float h = (height - faixaAltura) / (float)n;
   image(imagem, this.x - l / 2, this.y - h / 2, l , h + 2);
    
 
   
  }
  
 
 
  int getLinha() {
    return this.linha;
  }
  
  int getColuna() {
    return this.coluna;
  }
}
