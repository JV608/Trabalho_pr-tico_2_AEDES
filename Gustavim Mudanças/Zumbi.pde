class zombie extends Inimigo{
    
  float vx, vy;
  float d;
  int cor;
  ArrayList<PVector> caminho;
  int idxDestino;
 
  public zombie(ArrayList<Integer> caminhoIndices, Grafo grafo) {
    super(); 
    this.hp = 4;
    this.recompensa = 25;
    this.x = grafo.posicoes[caminhoIndices.get(0)].x;
    this.y = grafo.posicoes[caminhoIndices.get(0)].y;
    this.vx = 0;
    this.vy = 0;
    this.d = 50;
    this.cor = color((int) random(255), (int) random(255), (int) random(255));
    
    caminho = new ArrayList<PVector>();
    for(int i : caminhoIndices) {
      caminho.add(grafo.posicoes[i].copy()); 
    }
    
    idxDestino = 1; 
  }

  @Override
  public void move() {
    if (idxDestino >= caminho.size()) return; // terminou o caminho
    PVector destino = caminho.get(idxDestino);
    float dx = destino.x - x;
    float dy = destino.y - y;
  
    float fatorSuavizacao = 0.1; 
    vx = lerp(vx, 0.03 * dx, fatorSuavizacao);
    vy = lerp(vy, 0.03 * dy, fatorSuavizacao);

    x += vx;
    y += vy;
    
    // se chegou perto do destino, passa pro próximo
    if (dist(x, y, destino.x, destino.y) < 2) {
      idxDestino++;
    }
 }
 
   int getPosicaoAtualIndex(Grafo grafo) {
      int linha = floor(y / (height / (float)n));
      int coluna = floor(x / (width / (float)f));
      return linha * f + coluna;
  }
  
  @Override
  public void desenha(){
    image(zumbi, x - 20, y - 25, 50, 50);
 }
  
  @Override
  void atualizarCaminho(ArrayList<Integer> novoCaminhoIndices, Grafo grafo) {
    ArrayList<PVector> novoCaminho = new ArrayList<PVector>();
    for (int i : novoCaminhoIndices) {
    novoCaminho.add(grafo.posicoes[i].copy());
  }
   caminho = novoCaminho;
 }
}
