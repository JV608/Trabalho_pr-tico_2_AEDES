class Creeper extends Inimigo {

  float velocidade;
  float d;
  int cor;
  ArrayList<PVector> caminho;
  int idxDestino;
  PImage[] animacao;
  int frameAtual = 0;
  int contadorFrames = 0;
  int velocidadeAnimacao = 10;

  public Creeper(ArrayList<Integer> caminhoIndices, Grafo grafo, PImage[] imgs) {
    super();
    this.hp = 4;
    this.recompensa = 35;
    this.x = grafo.posicoes[caminhoIndices.get(0)].x;
    this.y = grafo.posicoes[caminhoIndices.get(0)].y;
    this.velocidade = 4; // Velocidade constante (maior que a do zumbi)
    this.d = 50;
    this.cor = color((int) random(255), (int) random(255), (int) random(255));
    this.animacao = imgs;

    caminho = new ArrayList<PVector>();
    for (int i : caminhoIndices) {
      caminho.add(grafo.posicoes[i].copy());
    }

    idxDestino = 1;
  }

  @Override
  public void move() {
    if (idxDestino >= caminho.size()) return; // Terminou o caminho

    PVector destino = caminho.get(idxDestino);

    float dx = destino.x - x;
    float dy = destino.y - y;
    float distancia = dist(x, y, destino.x, destino.y);


    if (distancia < velocidade) {
      x = destino.x;
      y = destino.y;
      idxDestino++;
      return;
    }

    float dirX = dx / distancia;
    float dirY = dy / distancia;
    
    x += dirX * velocidade;
    y += dirY * velocidade;
  }

  int getPosicaoAtualIndex(Grafo grafo) {
    int linha = constrain(floor( (y - faixaAltura) / ((height - faixaAltura) / (float)n) ), 0, n-1);
    int coluna = constrain(floor(x / (width / (float)f)), 0, f-1);
    return linha * f + coluna;
  }

  @Override
  public void desenha() {
    image(animacao[frameAtual], x - 20, y - 25, 50, 50);
    contadorFrames++;
    if (contadorFrames >= velocidadeAnimacao) {
      contadorFrames = 0;
      frameAtual = (frameAtual + 1) % animacao.length;
    }
  }

  @Override
  void atualizarCaminho(ArrayList<Integer> novoCaminhoIndices, Grafo grafo) {
    ArrayList<PVector> novoCaminho = new ArrayList<PVector>();
    for (int i : novoCaminhoIndices) {
      novoCaminho.add(grafo.posicoes[i].copy());
    }
    caminho = novoCaminho;
    idxDestino = 1; // Reinicia o caminho para o próximo nó
  }
}

