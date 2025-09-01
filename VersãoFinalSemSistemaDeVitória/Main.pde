// GRIDS
int[][] grid;
int[][] adj;
int n = 12;
int f = 22;
int vidaCasa = 3;
int destinoCasa;

// Dinheiro
int dinheiro;
float custoParede = 140;
float custoareia = 100;

// Horda
int hordaAtual = 0;
int zumbisPorHorda = 0;
int creepersPorHorda = 0;
int inimigosSpawdadosDaHorda = 0;
boolean hordaEmAndamento = false;
int tempoEntreHordas = 3000;
int tempoProximaHorda = 0;
int tempoEntreSpawns = 300;
int tempoUltimoSpawn = 0;

// Variáveis de Imagem
PImage grama1, grama2, pedra, golen, torre1, torre2, balaImg, casa, areia, areiaalma;
PImage zumbi1, zumbi2, zumbi3;
PImage[] zumbiImgs;
PImage creeper1, creeper2, creeper3, creeper4, creeper5, creeper6;
PImage[] creeperImgs;

Grafo grafo;
ArrayList<Inimigo> inimigos = new ArrayList<Inimigo>();
ArrayList<Torre> torres = new ArrayList<Torre>();
ArrayList<Parede> paredes = new ArrayList<Parede>();
ArrayList<Areia> areias = new ArrayList<Areia>();
float custoTorreInicial = 280;

// Variáveis para a faixa de interface
float faixaAltura = 70;
float jogoYInicial;
float larguraCelula = width / (float)f;
float alturaCelula = (height - faixaAltura) / (float)n;

// =========================================
// =========================================

void setup() {
  areiaalma = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/areia_da_alma.png");
  
  golen = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Iron_Golen.png");
  grama1 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/grama1.png");
  grama2 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/grama2.png");
  pedra = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/pedra.png");
  areia = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Areia.png");
  zumbi1 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/1_Zombie.png");
  zumbi2 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/2_Zombie.png");
  zumbi3 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/3_Zombie.png");
  zumbiImgs = new PImage[]{zumbi1, zumbi2, zumbi3};
  torre1 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Torre1.png");
  torre2 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Torre2.png");
  balaImg = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/bala.png");
  casa = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Casa.png");
  creeper1 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/creeper-1.png");
  creeper2 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/creeper-2.png");
  creeper3 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/creeper-3.png");
  creeper4 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/creeper-4.png");
  creeper5 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/creeper-5.png");
  creeper6 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/creeper-6.png");
  creeperImgs = new PImage[]{creeper1, creeper2, creeper3, creeper4, creeper5, creeper6};

  size(900, 700);
  frameRate(60);

  dinheiro = 675;
  jogoYInicial = faixaAltura;

  grid = new int[][]{
    {1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1},
    {1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1},
    {1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1},
    {1, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1},
    {1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1},
    {1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1},
    {1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1},
    {1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1},
    {1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1},
    {1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1},
    {1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0}
  };
  
  adj = criaAdjacencia();
  
  float faixaAltura = 50;
  grafo = new Grafo(adj, grid, faixaAltura);
  int linhaCasaAleatoria = (int)random(n);
  destinoCasa = index(linhaCasaAleatoria, f - 1);
  
  tempoProximaHorda = millis() + tempoEntreHordas;
}

// =========================================
// =========================================

void draw() {
  background(0);
  fill(50);
  noStroke();
  rect(0, 0, width, faixaAltura);
  
  grafo.desenharCenario(destinoCasa);

  // Loop para desenhar e atualizar as paredes
  for (int i = paredes.size() - 1; i >= 0; i--) {
    Parede p = paredes.get(i);
    p.show();
    if (p.foiDestruida()) {
      // Se a parede foi destruída, remova-a da lista e do grafo
      int paredeIdx = index(p.getLinha(), p.getColuna());
      grafo.matrizAdj = criaAdjacencia(); // Recria a matriz de adjacência do zero
      grafo.ocupado[paredeIdx] = false; // Ocupação removida
      paredes.remove(i);
      
      // Recalcule o caminho para todos os inimigos
      for (Inimigo inimigo : inimigos) {
        int origem = inimigo.getPosicaoAtualIndex(grafo);
        ArrayList<Integer> novoCaminho = grafo.dijkstra(origem, destinoCasa);
        inimigo.atualizarCaminho(novoCaminho, grafo);
      }
    }
  }
  for (int i = areias.size() - 1; i >= 0; i--) {
    Areia a = areias.get(i);
    a.show();
  }

  // loop do inimigo
  for (int i = inimigos.size() - 1; i >= 0; i--) {
    Inimigo inimigo = inimigos.get(i);
    if (inimigo.estaVivo) {
      // Verifique se o inimigo está perto de uma parede
      Parede paredeAlvo = null;
      for (Parede p : paredes) {
        if (dist(inimigo.x, inimigo.y, p.x, p.y) < 20) {
          paredeAlvo = p;
          break;
        }
      }
      
      if (paredeAlvo != null) {
        // O inimigo ataca a parede
        if (millis() - inimigo.tempoUltimoAtaque > inimigo.tempoEntreAtaques) {
          paredeAlvo.tomarDano(inimigo.danoPorSegundo);
          inimigo.tempoUltimoAtaque = millis();
        }
      } else {
        // Nenhuma parede próxima, o inimigo se move normalmente
        inimigo.move();
      }
      
      inimigo.desenha();
      if (dist(inimigo.x, inimigo.y, grafo.posicoes[destinoCasa].x, grafo.posicoes[destinoCasa].y) < 10) {
        vidaCasa--;
        inimigos.remove(i);
        println("A VILA SOFREU DANO! Vida restante: " + vidaCasa);
        continue;
      }
    } else {
      dinheiro += inimigo.recompensa;
      inimigos.remove(i);
    }
  }
  
  // loop das torres
  for (Torre t : torres) {
    t.atualizar(1.0 / frameRate, inimigos);
    if (t.nivel < 3) {
      t.show(torre1);
    } else {
      t.show(torre2);
    }
  }

  if (millis() < 4000) { // 4000 milissegundos = 4 segundos
  mostraProtejaAVila();
}

  desenharControles();
  mostraDinheiro();
  gerenciarHordas();
  mostraInfoHorda();
  mostraVidaCasa();

  if (vidaCasa <= 0) {
    fill(255, 0, 0);
    textSize(100);
    textAlign(CENTER, CENTER);
    text("FIM DE JOGO", width/2, height/2);
    noLoop();
  }
}

void desenharControles() {
  // Posição inicial para começar a desenhar, um pouco à direita do título
  float xInicial = 230; 
  float yCentro = (faixaAltura / 2) - 7;

  // Configurações de texto
  textSize(16);
  fill(255);
  textAlign(LEFT, CENTER);

  // Desenhar Torre e Texto (Botão Esquerdo)
  // Usa a imagem torre1 como representante
  image(torre1, xInicial, yCentro - 18, 25, 35); 
  text(": Esquerdo", xInicial + 28, yCentro);

  // Posição para o próximo item
  float xParede = xInicial + 125;

  // Desenhar Parede e Texto (Botão Direito)
  // Usa a imagem golen como representante da parede
  image(golen, xParede, yCentro - 15, 30, 30);
  text(": Direito", xParede + 32, yCentro);
  
  // Posição para o próximo item
  float xMelhoria = xParede + 115;
  
  // Desenhar Texto da Melhoria (Tecla U)
  fill(255, 215, 0); // Dourado para destacar
  text("Melhoria: U", xMelhoria, yCentro);
  
  float xAreia = xMelhoria + 125;

  // Desenhar Areia e Texto (Tecla A)
  // Usa a imagem golen como representante da parede
  image(areia, xAreia, yCentro - 15, 30, 30);
  text(": Scroll", xAreia + 32, yCentro);
}

void mostraProtejaAVila() {
  textSize(100);
  fill(0, 255, 0); 
  textAlign(CENTER, CENTER);
  text("PROTEJA A VILA!", width/2, height/2);
}

void mostraVidaCasa() {
  textSize(24);
  fill(173, 216, 230);
  textAlign(CENTER, CENTER);
  text("Vida da Vila: " + vidaCasa, width/2, (faixaAltura / 1.5 + 15) + 3);
}

void mostraDinheiro() {
  textSize(24);
  fill(255, 215, 0);
  textAlign(RIGHT, CENTER);
  text("Moedas: " + dinheiro, width - 13, (faixaAltura / 2) - 7);
}

void mostraInfoHorda() {
  textSize(24);
  fill(255, 100, 100);
  textAlign(LEFT, CENTER);
  text("Horda: " + hordaAtual, 20, (faixaAltura / 2) - 7);
}

int index(int i, int j) {
  return i * f + j;
}

int linha(int index) {
  return index / f;
}

int coluna(int index) {
  return index % f;
}

int[][] criaAdjacencia() {
  int total = n * f;
  int[][] adj = new int[total][total];
  
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < f; j++) {
      int atual = index(i, j);

      if (grid[i][j] == 0) {
        continue;
      }

      if (i > 0) {
        int vizinho = index(i - 1, j);
        if (grid[i - 1][j] == 1) {
          adj[atual][vizinho] = 1;
          adj[vizinho][atual] = 1;
        }
      }

      if (i < n - 1) {
        int vizinho = index(i + 1, j);
        if (grid[i + 1][j] == 1) {
          adj[atual][vizinho] = 1;
          adj[vizinho][atual] = 1;
        }
      }

      if (j > 0) {
        int vizinho = index(i, j - 1);
        if (grid[i][j - 1] == 1) {
          adj[atual][vizinho] = 1;
          adj[vizinho][atual] = 1;
        }
      }

      if (j < f - 1) {
        int vizinho = index(i, j + 1);
        if (grid[i][j + 1] == 1) {
          adj[atual][vizinho] = 1;
          adj[vizinho][atual] = 1;
        }
      }
    }
  }
  return adj;
}

void gerenciarHordas() {
  if (!hordaEmAndamento && inimigos.isEmpty()) {
    if (millis() > tempoProximaHorda) {
      hordaAtual++;
      zumbisPorHorda = hordaAtual;

      if (hordaAtual >= 5 && (hordaAtual % 2 != 0)) {
        creepersPorHorda = (hordaAtual / 2) - 1;
      }

      inimigosSpawdadosDaHorda = 0;
      hordaEmAndamento = true;
    }
  }

  if (hordaEmAndamento && inimigosSpawdadosDaHorda < zumbisPorHorda + creepersPorHorda) {
    if (millis() - tempoUltimoSpawn > tempoEntreSpawns) {
      if (inimigosSpawdadosDaHorda < zumbisPorHorda) {
        spawnZombie();
      } else {
        spawnCreeper();
      }
      inimigosSpawdadosDaHorda++;
      tempoUltimoSpawn = millis();
    }
  }

  if (inimigosSpawdadosDaHorda == zumbisPorHorda + creepersPorHorda && hordaEmAndamento) {
    if (inimigos.isEmpty()) {
      println("Horda " + hordaAtual + " derrotada!");
      hordaEmAndamento = false;
      tempoProximaHorda = millis() + tempoEntreHordas;
    }
  }
}

void spawnZombie() {
  int linhaAleatoria = (int)random(n);
  int origem = index(linhaAleatoria, 0);
  ArrayList<Integer> caminho = grafo.dijkstra(origem, destinoCasa);
  if (!caminho.isEmpty()) {
    zombie novoZombie = new zombie(caminho, grafo, zumbiImgs);
    inimigos.add(novoZombie);
  }
}

void spawnCreeper() {
  int linhaAleatoria = (int)random(n);
  int origem = index(linhaAleatoria, 0);
  ArrayList<Integer> caminho = grafo.dijkstra(origem, destinoCasa);
  if (!caminho.isEmpty()) {
    Creeper novoCreeper = new Creeper(caminho, grafo, creeperImgs);
    inimigos.add(novoCreeper);
  }
}
void mousePressed() {
  boolean obstaculoConstruido = false;
  
  // Calcula as coordenadas do grid a partir da posição do mouse
  int linha = (int) ((mouseY - faixaAltura) / ((height - faixaAltura) / (float)n));
  int coluna = (int) (mouseX / (width / (float)f));

  // Verifica se o clique está dentro do grid do jogo
  if (linha >= 0 && linha < n && coluna >= 0 && coluna < f) {
    int idx = index(linha, coluna);

    // Botão esquerdo do mouse para construir a torre
    if (mouseButton == LEFT) {
      if (dinheiro >= custoTorreInicial) {
        if (grid[linha][coluna] == 0 && !grafo.ocupado[idx]) {
          dinheiro -= custoTorreInicial;
          torres.add(new Torre(grafo.posicoes[idx].x, grafo.posicoes[idx].y, 2, 170, 0.9, custoTorreInicial));
          grafo.ocupado[idx] = true;
          for (int j = 0; j < grafo.numVertices; j++) {
            grafo.matrizAdj[idx][j] = 0;
            grafo.matrizAdj[j][idx] = 0;
          }
          obstaculoConstruido = true;
          println("Torre construída! Dinheiro restante: " + dinheiro);
        } else {
          println("Não é possível construir uma torre aqui!");
        }
      } else {
        println("Dinheiro insuficiente para construir a torre!");
      }
    }

    // Botão direito do mouse para construir a parede
    if (mouseButton == RIGHT) {
      if (dinheiro >= custoParede) {
        if (grid[linha][coluna] == 1 && !grafo.ocupado[idx] && idx != destinoCasa) {
          dinheiro -= custoParede;
          
          paredes.add(new Parede(grafo.posicoes[idx].x, grafo.posicoes[idx].y, custoParede, golen));
  
          grafo.ocupado[idx] = true;
          
          int custoDaParedeNoGrafo = 40;
          for (int j = 0; j < grafo.numVertices; j++) {
            if (grafo.matrizAdj[idx][j] > 0) {
              grafo.matrizAdj[idx][j] = custoDaParedeNoGrafo;
              grafo.matrizAdj[j][idx] = custoDaParedeNoGrafo;
            }
          }
          obstaculoConstruido = true;
          println("Parede construída! Dinheiro restante: " + dinheiro);
        } else {
          println("Não é possível construir uma parede aqui!");
        }
      } else {
        println("Dinheiro insuficiente para construir a parede!");
      }
    }

    // Botão central do mouse para construir a areia
    if (mouseButton == CENTER) {
      if (dinheiro >= custoareia) {
        if (grid[linha][coluna] == 1 && !grafo.ocupado[idx] && idx != destinoCasa) {
          dinheiro -= custoareia;
          
          areias.add(new Areia(grafo.posicoes[idx].x, grafo.posicoes[idx].y, custoareia, areia));
  
          grafo.ocupado[idx] = true;
          
          int custoDaAreiaNoGrafo = 3;
          for (int j = 0; j < grafo.numVertices; j++) {
            if (grafo.matrizAdj[idx][j] > 0) {
              grafo.matrizAdj[idx][j] = custoDaAreiaNoGrafo;
              grafo.matrizAdj[j][idx] = custoDaAreiaNoGrafo;
            }
          }
          obstaculoConstruido = true;
          println("Areia construída! Dinheiro restante: " + dinheiro);
        } else {
          println("Não é possível construir uma Areia aqui!");
        }
      } else {
        println("Dinheiro insuficiente para construir a Areia!");
      }
    }
  }

  // Se qualquer obstáculo foi construído, recalcula o caminho
  if (obstaculoConstruido) {
    for (Inimigo inimigo : inimigos) {
      int origem = inimigo.getPosicaoAtualIndex(grafo);
      ArrayList<Integer> novoCaminho = grafo.dijkstra(origem, destinoCasa);
      inimigo.atualizarCaminho(novoCaminho, grafo);
    }
  }
}

void keyPressed() {
  // 'u' para fazer o upgrade da torre
  if (key == 'u' || key == 'U') {
    for (Torre t : torres) {
      if (dist(mouseX, mouseY, t.x, t.y) < 20) {
        float custoUpgrade = t.custo + 20;
        if (dinheiro >= custoUpgrade) {
          dinheiro -= custoUpgrade;
          t.upgrade();
          println("Torre melhorada! Nível: " + t.nivel + ". Dinheiro restante: " + dinheiro);
        } else {
          println("Dinheiro insuficiente para melhorar a torre! Custo: " + custoUpgrade);
        }
        break;
      }
    }
  }
}
