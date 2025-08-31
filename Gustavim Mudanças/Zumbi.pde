class zombie extends Inimigo{
    
  float vx, vy;
  float d;
  int cor;
  ArrayList<PVector> caminho;
  int idxDestino;
  
  PImage[] animacao;
  int frameAtual = 0;
  int contadorFrames = 0;
  int velocidadeAnimacao = 10;
 
  public zombie(ArrayList<Integer> caminhoIndices, Grafo grafo,PImage[] imgs) {
    super(); 
    this.hp = 4;
    this.recompensa = 25;
    this.x = grafo.posicoes[caminhoIndices.get(0)].x;
    this.y = grafo.posicoes[caminhoIndices.get(0)].y;
    this.vx = 0;
    this.vy = 0;
    this.d = 50;
    this.cor = color((int) random(255), (int) random(255), (int) random(255));
    this.animacao = imgs;
     
    caminho = new ArrayList<PVector>();
    for(int i : caminhoIndices) {
      caminho.add(grafo.posicoes[i].copy()); 
    }
    
    idxDestino = 1; 
  }

  @Override
  public void move() {
    if (idxDestino >= caminho.size()) return; // Terminou o caminho ou não tem caminho
    PVector destino = caminho.get(idxDestino);
    float dx = destino.x - x;
    float dy = destino.y - y;
  
    float fatorSuavizacao = 0.1; 
    vx = lerp(vx, 0.12 * dx, fatorSuavizacao);
    vy = lerp(vy, 0.12 * dy, fatorSuavizacao);

    x += vx;
    y += vy;
    
    // se chegou perto do destino, passa pro próximo
    if (dist(x, y, destino.x, destino.y) < 5) { // Aumentei a tolerância para evitar que fiquem presos
      idxDestino++;
    }
 }
 
   int getPosicaoAtualIndex(Grafo grafo) {
      int linha = floor((y - faixaAltura) / ((height - faixaAltura) / (float)n));
      int coluna = floor(x / (width / (float)f));
      linha = constrain(linha, 0, n-1);
      coluna = constrain(coluna, 0, f-1);
      return linha * f + coluna;
  }
  
  @Override
  public void desenha(){
    image(animacao[frameAtual], x - 20, y - 25, 50, 50);

    contadorFrames++;
    if (contadorFrames >= velocidadeAnimacao) {
      contadorFrames = 0;
      frameAtual = (frameAtual + 1) % animacao.length; // Avança para o próximo frame
    }
  }
  
  @Override
  void atualizarCaminho(ArrayList<Integer> novoCaminhoIndices, Grafo grafo) {
    if (novoCaminhoIndices.isEmpty()) {
      caminho.clear();
      return;
    }
    
    ArrayList<PVector> novoCaminho = new ArrayList<PVector>();
    for (int i : novoCaminhoIndices) {
      novoCaminho.add(grafo.posicoes[i].copy());
    }
    caminho = novoCaminho;
    
    // --- IMPORTANTE: Reinicia o alvo para o próximo nó do novo caminho ---
    idxDestino = 1; 
  }
}
