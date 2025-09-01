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
float custoTerrenoLento = 15;/////////

//Horda
int hordaAtual = 0;
int zumbisPorHorda = 0;
int zumbisSpawdadosDaHorda = 0;
boolean hordaEmAndamento = false;
int tempoEntreHordas = 3000;
int tempoProximaHorda = 0;
int tempoEntreSpawns = 300;
int tempoUltimoSpawn = 0;


// Variáveis de Imagem
PImage grama1, grama2, pedra, torre1, torre2, balaImg, casa;
PImage zumbi1, zumbi2, zumbi3;
PImage[] zumbiImgs;

Grafo grafo;
ArrayList<Inimigo> inimigos = new ArrayList<Inimigo>();
ArrayList<Torre> torres = new ArrayList<Torre>();
float custoTorreInicial = 50;

// Variáveis para a faixa de interface
float faixaAltura = 70; // Altura da faixa superior
float jogoYInicial; // Posição Y onde o jogo começa

// =========================================
// =========================================

void setup() {

  grama1 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/grama1.png");
  grama2 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/grama2.png");
  pedra  = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/pedra.png");
  zumbi1  = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/1_Zombie.png");
  zumbi2  = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/2_Zombie.png");
  zumbi3  = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/3_Zombie.png");
  zumbiImgs = new PImage[]{zumbi1, zumbi2, zumbi3};
  torre1 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Torre1.png");
  torre2 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Torre2.png");
  balaImg = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/bala.png");
  casa = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Casa.png");

  size(900, 700);
  frameRate(60);

  dinheiro = 100;
  jogoYInicial = faixaAltura; // O jogo começa abaixo da faixa

  grid = criaGrid();
  adj = criaAdjacencia();
  grafo = new Grafo(adj, faixaAltura);

  int linhaCasaAleatoria = (int)random(n); // Sorteia um número entre 0 e 11
  destinoCasa = index(linhaCasaAleatoria, f - 1); // Define o destino nesta posição

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

  //  loop do zumbi
  for (int i = inimigos.size() - 1; i >= 0; i--) {
    Inimigo z = inimigos.get(i);
    if (z.estaVivo) {
  
      z.move(grafo); ///////
      z.desenha();

      if (dist(z.x, z.y, grafo.posicoes[destinoCasa].x, grafo.posicoes[destinoCasa].y) < 10) {
        vidaCasa--; // Zumbi causa 1 de dano
        inimigos.remove(i);
        println("A VILA SOFREU DANO! Vida restante: " + vidaCasa);
        continue;
      }
    } else {
      dinheiro += z.recompensa;
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
  fill(255, 215, 0);
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
  textAlign(CENTER, CENTER);
  text("PROTEJA A VILA", width/2, faixaAltura / 2 - 10);
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
  float alturaAreaJogo = height - faixaAltura;
  float l = width / (float) f;
  float h = alturaAreaJogo / (float) n;

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < f; j++) {
      stroke(200);
      if (grid[i][j] == 0) {
        image(grama1, j * l, i * h + faixaAltura, l, h);
      } else if (grid[i][j] == 1) {
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
      if (i > 0) {
        int vizinho = index(i - 1, j);
        adj[atual][vizinho] = 1;
        adj[vizinho][atual] = 1;
      }
      if (i < n - 1) {
        int vizinho = index(i + 1, j);
        adj[atual][vizinho] = 1;
        adj[vizinho][atual] = 1;
      }
      if (j > 0) {
        int vizinho = index(i, j - 1);
        adj[atual][vizinho] = 1;
        adj[vizinho][atual] = 1;
      }
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
      zumbisPorHorda = hordaAtual;
      zumbisSpawdadosDaHorda = 0;
      hordaEmAndamento = true;
    }
  }

  if (hordaEmAndamento && zumbisSpawdadosDaHorda < zumbisPorHorda) {
    if (millis() - tempoUltimoSpawn > tempoEntreSpawns) {
      spawnZombie();
      zumbisSpawdadosDaHorda++;
      tempoUltimoSpawn = millis();
    }
  }

  if (zumbisSpawdadosDaHorda == zumbisPorHorda && hordaEmAndamento) {
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

// --- NOVO: Função para atualizar o caminho de todos os zumbis ---
void atualizarCaminhoDeTodosOsZumbis() {
  for (Inimigo z : inimigos) {
    int origemAtual = z.getPosicaoAtualIndex(grafo);
    ArrayList<Integer> novoCaminho = grafo.dijkstra(origemAtual, destinoCasa);
    z.atualizarCaminho(novoCaminho, grafo);
  }
}

// =========================================
// =========================================

void mousePressed() {
  if (mouseButton == LEFT) {
    if (dinheiro >= custoTorreInicial) {
      for (int i = 0; i < grafo.numVertices; i++) {
        if (grafo.terreno[i] != grafo.TERRENO_NORMAL) continue; ///////
        PVector pos = grafo.posicoes[i];
        float l = width / (float)f;
        float h = (height - faixaAltura) / (float)n;
        if (mouseX >= pos.x - l/2 && mouseX <= pos.x + l/2 &&
          mouseY >= pos.y - h/2 && mouseY <= pos.y + h/2 ) {
          dinheiro -= custoTorreInicial;
          torres.add(new Torre(pos.x, pos.y, 1, 150, 1.0, custoTorreInicial));
         
          grafo.terreno[i] = grafo.TERRENO_OCUPADO;/////////
         
          for (int j = 0; j < grafo.numVertices; j++) {
            if (grafo.matrizAdj[i][j] > 0) {
              grafo.matrizAdj[i][j] = 0;
              grafo.matrizAdj[j][i] = 0;
            }
          }
          atualizarCaminhoDeTodosOsZumbis(); // <<< ATUALIZA O CAMINHO
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
       if (grafo.terreno[i] != grafo.TERRENO_NORMAL) continue; /////
        PVector pos = grafo.posicoes[i];
        float l = width / (float)f;
        float h = (height - faixaAltura) / (float)n;
        if (mouseX >= pos.x - l/2 && mouseX <= pos.x + l/2 &&
          mouseY >= pos.y - h/2 && mouseY <= pos.y + h/2) {
          dinheiro -= custoParede;
          grafo.terreno[i] = grafo.TERRENO_OCUPADO; // 
          for (int j = 0; j < grafo.numVertices; j++) {
            if (grafo.matrizAdj[i][j] > 0) {
              grafo.matrizAdj[i][j] = 0;
              grafo.matrizAdj[j][i] = 0;
            }
          }
          atualizarCaminhoDeTodosOsZumbis(); // <<< ATUALIZA O CAMINHO
          println("Parede construída! Dinheiro restante: " + dinheiro);
          break;
        }
      }
    } else {
      println("Dinheiro insuficiente para construir a parede!");
    }
  }


 // <<-- CÓDIGO NOVO OU MODIFICADO (BLOCO INTEIRO)
  if (mouseButton == CENTER) { // <<-- CÓDIGO NOVO OU MODIFICADO
    if (dinheiro >= custoTerrenoLento) { // <<-- CÓDIGO NOVO OU MODIFICADO
       for (int i = 0; i < grafo.numVertices; i++) { // <<-- CÓDIGO NOVO OU MODIFICADO
        if (grafo.terreno[i] != grafo.TERRENO_NORMAL) continue; // <<-- CÓDIGO NOVO OU MODIFICADO
        
        PVector pos = grafo.posicoes[i]; // <<-- CÓDIGO NOVO OU MODIFICADO
        float l = width / (float)f; // <<-- CÓDIGO NOVO OU MODIFICADO
        float h = (height - faixaAltura) / (float)n; // <<-- CÓDIGO NOVO OU MODIFICADO
        if (mouseX >= pos.x - l/2 && mouseX <= pos.x + l/2 && // <<-- CÓDIGO NOVO OU MODIFICADO
            mouseY >= pos.y - h/2 && mouseY <= pos.y + h/2) { // <<-- CÓDIGO NOVO OU MODIFICADO
          dinheiro -= custoTerrenoLento; // <<-- CÓDIGO NOVO OU MODIFICADO
          
          grafo.terreno[i] = grafo.TERRENO_LENTO; // <<-- CÓDIGO NOVO OU MODIFICADO
          
          println("Terreno lento criado! Dinheiro restante: " + dinheiro); // <<-- CÓDIGO NOVO OU MODIFICADO
          break; // <<-- CÓDIGO NOVO OU MODIFICADO
        } // <<-- CÓDIGO NOVO OU MODIFICADO
      } // <<-- CÓDIGO NOVO OU MODIFICADO
    } else { // <<-- CÓDIGO NOVO OU MODIFICADO
       println("Dinheiro insuficiente para criar terreno lento!"); // <<-- CÓDIGO NOVO OU MODIFICADO
    } // <<-- CÓDIGO NOVO OU MODIFICADO
  } // <<-- CÓDIGO NOVO OU MODIFICADO
}

// =========================================
// =========================================

void keyPressed() {
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
