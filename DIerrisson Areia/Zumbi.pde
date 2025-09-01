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
  public void move(Grafo grafo) { // <<-- CÓDIGO NOVO OU MODIFICADO
    if (idxDestino >= caminho.size()) return;
    
    // <<-- CÓDIGO NOVO OU MODIFICADO (BLOCO INTEIRO)
    float fatorVelocidade = 1.0; // <<-- CÓDIGO NOVO OU MODIFICADO
    int indiceAtual = getPosicaoAtualIndex(grafo); // <<-- CÓDIGO NOVO OU MODIFICADO
    if (grafo.terreno[indiceAtual] == grafo.TERRENO_LENTO) { // <<-- CÓDIGO NOVO OU MODIFICADO
        fatorVelocidade = 0.5; // <<-- CÓDIGO NOVO OU MODIFICADO
    } // <<-- CÓDIGO NOVO OU MODIFICADO
    
    PVector destino = caminho.get(idxDestino);
    float dx = destino.x - x;
    float dy = destino.y - y;
  
    float fatorSuavizacao = 0.1; 
    
    vx = lerp(vx, (0.12 * fatorVelocidade) * dx, fatorSuavizacao); // <<-- CÓDIGO NOVO OU MODIFICADO
    vy = lerp(vy, (0.12 * fatorVelocidade) * dy, fatorSuavizacao); // <<-- CÓDIGO NOVO OU MODIFICADO

    x += vx;
    y += vy;
    
    if (dist(x, y, destino.x, destino.y) < 5) {
      idxDestino++;
    }
  }
  
    @Override // 
     void move() {} // 
  
 
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
