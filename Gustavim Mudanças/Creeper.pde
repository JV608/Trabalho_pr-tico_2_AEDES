class Creeper extends Inimigo {
  float velocidadebase;
  float velocidade;
  float d;
  int cor;
  ArrayList<PVector> caminho;
  int idxDestino;
  PImage[] animacao;
  int frameAtual = 0;
  int contadorFrames = 0;
  int velocidadeAnimacao = 10;
  
  int maxHp;

  public Creeper(ArrayList<Integer> caminhoIndices, Grafo grafo, PImage[] imgs) {
    super();
    this.hp = 4;
    this.maxHp = 4;
    this.recompensa = 35;
    this.x = grafo.posicoes[caminhoIndices.get(0)].x;
    this.y = grafo.posicoes[caminhoIndices.get(0)].y;
    this.velocidade = 4;
    this.velocidadebase = 4;
    this.d = 50;
    this.cor = color((int) random(255), (int) random(255), (int) random(255));
    this.animacao = imgs;

    // NOVAS VARIAVEIS
    this.danoPorSegundo = 25; // Dano do creeper por segundo na parede (maior que o zumbi)
    this.tempoEntreAtaques = 750; // Um ataque a cada 0.75 segundo

    caminho = new ArrayList<PVector>();
    for (int i : caminhoIndices) {
      caminho.add(grafo.posicoes[i].copy());
    }

    idxDestino = 1;
  }

  @Override
public void move() {
  if (idxDestino >= caminho.size()) return;

  // ---- Lógica de verificação da areia ----
  // 1. Obtém a célula atual do inimigo
  int linhaAtual = floor((y - faixaAltura) / (height - faixaAltura) * n);
  int colunaAtual = floor(x / width * f);

  boolean emAreia = false;
  for (Areia a : areias) {
    if (a.getLinha() == linhaAtual && a.getColuna() == colunaAtual) {
      emAreia = true;
      break;
    }
  }

  // 2. Ajusta a velocidade com base na verificação
  if (emAreia) {
    velocidade = velocidadebase / 2.0; // Reduz a velocidade pela metade
  } else {
    velocidade = velocidadebase; // Volta para a velocidade normal
  }
  // ---- Fim da lógica de verificação da areia ----

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
    
    desenhaBarraVida();
  }

  private void desenhaBarraVida() {
    float barraLargura = 30;
    float barraAltura = 5;
    float barraX = x - barraLargura / 2;
    float barraY = y - 35;
    
    float vidaPorcentagem = (float)hp / (float)maxHp;
    
    noStroke();
    fill(50, 50, 50);
    rect(barraX, barraY, barraLargura, barraAltura);
    
    fill(100, 255, 100);
    rect(barraX, barraY, barraLargura * vidaPorcentagem, barraAltura);
    
    stroke(0);
    noFill();
    rect(barraX, barraY, barraLargura, barraAltura);
  }

  @Override
  void atualizarCaminho(ArrayList<Integer> novoCaminhoIndices, Grafo grafo) {
    ArrayList<PVector> novoCaminho = new ArrayList<PVector>();
    for (int i : novoCaminhoIndices) {
      novoCaminho.add(grafo.posicoes[i].copy());
    }
    caminho = novoCaminho;
    idxDestino = 1;
  }
}
