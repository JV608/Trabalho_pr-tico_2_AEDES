//GRIDS
int[][] grid;
int[][] adj;
int n = 12;
int f = 22;
int vidaCasa = 3;
int destinoCasa;

//Dinheiro
int dinheiro;
float custoParede = 20;

//Horda
int hordaAtual = 0;
int zumbisPorHorda = 0;
int creepersPorHorda = 0; // Novo
int inimigosSpawdadosDaHorda = 0;
boolean hordaEmAndamento = false;
int tempoEntreHordas = 3000; // 3 segundos de espera entre as hordas
int tempoProximaHorda = 0;
int tempoEntreSpawns = 300;
// 0.3 segundos entre cada inimigo da mesma horda
int tempoUltimoSpawn = 0;

// Variáveis de Imagem
PImage grama1, grama2, pedra, torre1, torre2, balaImg, casa, areia;
PImage zumbi1, zumbi2, zumbi3;
PImage[] zumbiImgs;
PImage creeper1, creeper2, creeper3, creeper4, creeper5, creeper6; // Novo
PImage[] creeperImgs; // Novo

Grafo grafo;
ArrayList<Inimigo> inimigos = new ArrayList<Inimigo>();
ArrayList<Torre> torres = new ArrayList<Torre>();
float custoTorreInicial = 50;

// Variáveis para a faixa de interface
float faixaAltura = 70; // Altura da faixa superior
float jogoYInicial;
// Posição Y onde o jogo começa

// =========================================
// =========================================

void setup() {

  grama1 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/grama1.png");
  grama2 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/grama2.png");
  pedra  = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/pedra.png");
  areia  = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Areia.png");
  zumbi1  = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/1_Zombie.png");
  zumbi2  = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/2_Zombie.png");
  zumbi3  = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/3_Zombie.png");
  zumbiImgs = new PImage[]{zumbi1, zumbi2, zumbi3};
  torre1 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Torre1.png");
  torre2 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Torre2.png");
  balaImg = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/bala.png");
  casa = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Casa.png");

  // Carregar imagens do Creeper 
  creeper1 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/creeper-1.png");
  creeper2 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/creeper-2.png");
  creeper3 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/creeper-3.png");
  creeper4 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/creeper-4.png");
  creeper5 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/creeper-5.png");
  creeper6 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/creeper-6.png");
  creeperImgs = new PImage[]{creeper1, creeper2, creeper3, creeper4, creeper5, creeper6};

  size(900, 700);
  frameRate(60);

  dinheiro = 1000;
  jogoYInicial = faixaAltura; // O jogo começa abaixo da faixa

  grid = criaGrid();
  adj = criaAdjacencia();
  float faixaAltura = 50;
  grafo = new Grafo(adj, faixaAltura);
  int linhaCasaAleatoria = (int)random(n);
  destinoCasa = index(linhaCasaAleatoria, f - 1);
  // Define o destino nesta posição


  tempoProximaHorda = millis() + tempoEntreHordas;
}

// =========================================
// =========================================

void draw() {
  background(0);
  // Desenha o fundo da faixa de interface
  fill(50);
  noStroke();
  rect(0, 0, width, faixaAltura);

  // Desenha o grid abaixo da faixa
  mostraGrid();
  // recalcula o caminho do grafo (para desenho)
  int origem = index(0, 0);
  ArrayList<Integer> caminhoAtual = grafo.dijkstra(origem, destinoCasa);
  grafo.desenhar(caminhoAtual, destinoCasa);


  //  loop do inimigo
  for (int i = inimigos.size() - 1; i >= 0; i--) {
    Inimigo inimigo = inimigos.get(i);
    if (inimigo.estaVivo) {
      inimigo.move();
      inimigo.desenha();
      if (dist(inimigo.x, inimigo.y, grafo.posicoes[destinoCasa].x, grafo.posicoes[destinoCasa].y) < 10) {
        vidaCasa--;
        inimigos.remove(i);
        // Remove o inimigo que atacou
        println("A VILA SOFREU DANO! Vida restante: " + vidaCasa);
        continue; // Pula para o próximo inimigo para evitar erros
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

  mostraDinheiro();
  gerenciarHordas();
  mostraInfoHorda();
  mostraonome();
  mostraVidaCasa();

if (vidaCasa <= 0) {
    fill(255, 0, 0);
    textSize(100);
    textAlign(CENTER, CENTER);
    text("FIM DE JOGO", width/2, height/2);
    noLoop();
  }
}


// =========================================
// ===== FUNÇÕES DE LÓGICA E UTILIDADE =====
// =========================================

void mostraVidaCasa() {
  textSize(24);
  fill(173, 216, 230);
  textAlign(CENTER, CENTER);
  text("Vida da Vila: " + vidaCasa, width/2, faixaAltura / 2 + 15);
}

void mostraDinheiro() {
  textSize(24);
  fill(255, 215, 0); // Cor de ouro
  textAlign(RIGHT, CENTER);
  text("Moedas: " + dinheiro, width - 20, faixaAltura / 2);
}

void mostraInfoHorda() {
  textSize(24);
  fill(255, 100, 100);
  textAlign(LEFT, CENTER);
  text("Horda: " + hordaAtual, 20, faixaAltura / 2);
}
void mostraonome() {
  textSize(34);
  fill(70, 150, 110);

  textAlign(LEFT, CENTER);
  text("PROTEJA A VILA", 335, faixaAltura / 2);
}


int[][] criaGrid() {
  int[][] m = new int[n][f];
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < f; j++) {
      m[i][j] = (0);
    }
  }
  return m;
}

void mostraGrid() {
  // Ajuste a altura do grid para o espaço abaixo da faixa
  float alturaAreaJogo = height - faixaAltura;
  float l = width / (float) f;
  float h = alturaAreaJogo / (float) n;
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < f; j++) {
      stroke(200);
      // Ajuste o preenchimento para as imagens (grama, pedra, etc.)
      if (grid[i][j] == 0) { // Grama
        image(grama1, j * l, i * h + faixaAltura, l, h);
      } else if (grid[i][j] == 1) { // Pedra/Obstáculo
        image(pedra, j * l, i * h + faixaAltura, l, h);
      }
    }
  }
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
      // Cima
      if (i > 0) {
        int vizinho = index(i - 1, j);
        adj[atual][vizinho] = 1;
        adj[vizinho][atual] = 1;
      }

      // Baixo
      if (i < n - 1) {
        int vizinho = index(i + 1, j);
        adj[atual][vizinho] = 1;
        adj[vizinho][atual] = 1;
      }

      // Esquerda
      if (j > 0) {
        int vizinho = index(i, j - 1);
        adj[atual][vizinho] = 1;
        adj[vizinho][atual] = 1;
      }

      // Direita
      if (j < f - 1) {
        int vizinho = index(i, j + 1);
        adj[atual][vizinho] = 1;
        adj[vizinho][atual] = 1;
      }
    }
  }

  return adj;
}

// =========================================
// =====         Hordas               =====
// =========================================
void gerenciarHordas() {
  if (!hordaEmAndamento && inimigos.isEmpty()) {
    if (millis() > tempoProximaHorda) {
      hordaAtual++;
      zumbisPorHorda = hordaAtual; // A cada horda, aumenta 1 zumbi

      // Lógica do Creeper
      if (hordaAtual >= 5 && (hordaAtual % 2 != 0)) {
        creepersPorHorda = (hordaAtual / 2) - 1;
      }

      inimigosSpawdadosDaHorda = 0;
      hordaEmAndamento = true;
    }
  }

  if (hordaEmAndamento && inimigosSpawdadosDaHorda < zumbisPorHorda + creepersPorHorda) {
    if (millis() - tempoUltimoSpawn > tempoEntreSpawns) {
      // Decide qual inimigo spawnar
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


// =========================================
// =========================================


void mousePressed() {
  boolean obstaculoConstruido = false;

  if (mouseButton == LEFT) {
    if (dinheiro >= custoTorreInicial) {
      for (int i = 0; i < grafo.numVertices; i++) {
        if (grafo.ocupado[i]) continue;
        PVector pos = grafo.posicoes[i];
        float l = width / (float)f;
        float h = (height - faixaAltura) / (float)n;

        if (mouseX >= pos.x - l / 2 && mouseX <= pos.x + l / 2 &&
          mouseY >= pos.y - h / 2 && mouseY <= pos.y + h / 2 ) {

          dinheiro -= custoTorreInicial;
          torres.add(new Torre(pos.x, pos.y, 2, 170, 0.9, custoTorreInicial));
          grafo.ocupado[i] = true;
          for (int j = 0; j < grafo.numVertices; j++) {
            if (grafo.matrizAdj[i][j] > 0) {
              grafo.matrizAdj[i][j] = 0;
              grafo.matrizAdj[j][i] = 0;
            }
          }
          obstaculoConstruido = true;
          break;
        }
      }
    } else {
      println("Dinheiro insuficiente para construir a torre!");
    }
  }

  if (mouseButton == RIGHT) {
    if (dinheiro >= custoParede) {
      for (int i = 0; i < grafo.numVertices; i++) {
        if (grafo.ocupado[i]) continue;
        PVector pos = grafo.posicoes[i];
        float l = width / (float)f;
        float h = (height - faixaAltura) / (float)n;

        if (mouseX >= pos.x - l / 2 && mouseX <= pos.x + l / 2 &&
          mouseY >= pos.y - h / 2 && mouseY <= pos.y + h / 2) {

          dinheiro -= custoParede;
          grafo.ocupado[i] = true;
          for (int j = 0; j < grafo.numVertices; j++) {
            if (grafo.matrizAdj[i][j] > 0) {
              grafo.matrizAdj[i][j] = 0;
              grafo.matrizAdj[j][i] = 0;
            }
          }
          obstaculoConstruido = true;
          println("Parede construída! Dinheiro restante: " + dinheiro);
          break;
        }
      }
    } else {
      println("Dinheiro insuficiente para construir a parede!");
    }
  }

  if (obstaculoConstruido) {
    for (Inimigo inimigo : inimigos) {
      int origem = inimigo.getPosicaoAtualIndex(grafo);
      ArrayList<Integer> novoCaminho = grafo.dijkstra(origem, destinoCasa);
      inimigo.atualizarCaminho(novoCaminho, grafo);
    }
  }
}

// =========================================
// =========================================

void keyPressed() {
  if (key == 'u' || key == 'U') {
    for (Torre t : torres) {
      if (dist(mouseX, mouseY, t.x, t.y) < 20) { // Posição Y do mouse ajustada
        float custoUpgrade = t.custo + 20;
        // Calcula o custo do próximo upgrade
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

// =========================================
// =========================================

