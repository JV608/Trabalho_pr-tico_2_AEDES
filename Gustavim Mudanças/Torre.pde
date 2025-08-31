class Torre {
  float x, y;
  float alcance;
  float cadencia;
  float custo;
  float tempoDesdeUltimoBala;
  int nivel;
  int dano;
  ArrayList<Bala> balas;

  Torre(float x, float y, int dano, float alcance, float cadencia, float custo) {
    this.x = x;
    this.y = y;
    this.dano = dano;
    this.alcance = alcance;
    this.cadencia = cadencia;
    this.custo = custo;
    this.tempoDesdeUltimoBala = 0;
    this.nivel = 1;
    this.balas = new ArrayList<Bala>();
  }

  void atualizar(float deltaTime, ArrayList<Inimigo> listaDeInimigos) {
    tempoDesdeUltimoBala += deltaTime;
    if (tempoDesdeUltimoBala >= this.cadencia) {
      Inimigo alvo = encontrarAlvo(listaDeInimigos);
      if (alvo != null) {
        this.atirar(alvo);
        this.tempoDesdeUltimoBala = 0;
      }
    }

    for (int i = balas.size() - 1; i >= 0; i--) {
      Bala b = balas.get(i);
      b.mover();
      b.show();

      for (Inimigo inimigo : listaDeInimigos) {
        if (b.Colidir(inimigo)) {
          inimigo.receberDano(b.dano);
          b.ativa = false;
          break;
        }
      }

      if (!b.ativa) {
        balas.remove(i);
      }
    }
  }

  // =========================================
  // =========================================

  Inimigo encontrarAlvo(ArrayList<Inimigo> listaDeInimigos) {
    Inimigo alvoMaisProximo = null;
    float menorDistancia = alcance;
    for (Inimigo inimigo : listaDeInimigos) {
      float d = dist(this.x, this.y, inimigo.x, inimigo.y);
      if (d < menorDistancia) {
        menorDistancia = d;
        alvoMaisProximo = inimigo;
      }
    }
    return alvoMaisProximo;
  }

  // =========================================
  // =========================================
  void atirar(Inimigo inimigo) {
    float velBala = 5.0;
    float dx = inimigo.x - this.x;
    float dy = inimigo.y - this.y;
    float dist = sqrt(dx * dx + dy * dy);
    float velX = (dx / dist) * velBala;
    float velY = (dy / dist) * velBala;
    balas.add(new Bala(this.x, this.y, velX, velY, this.dano, balaImg));
  }

  // =========================================
  // =========================================


  public void upgrade() {
    if (nivel < 5) {
      this.nivel++;
      this.dano += 1; 
      this.alcance += 10; 
      this.custo += 25;
      if (this.cadencia > 0.15) {
        this.cadencia -= 0.15; 
      }
      println("Torre aprimorada para o nivel: " + this.nivel);
    } else {
      println("Torre esta em nivel maximo.");
    }
  }

  // =========================================
  // =========================================

  // Desenha a imagem da torre
  void show(PImage foto) {
    image(foto, this.x - 20, this.y - 45, 40, 60);
  }
}
