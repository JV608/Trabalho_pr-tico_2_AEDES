//GRIDS
int[][] grid;
int[][] adj;
int n = 12;
int f = 22;
int destinoFinal;

//Dinheiro
int dinheiro;
float custoParede = 20;

//Horda
int hordaAtual = 0;
int zumbisPorHorda = 0;
int zumbisSpawdadosDaHorda = 0;
boolean hordaEmAndamento = false;
int tempoEntreHordas = 5000; // 5 segundos de espera entre as hordas
int tempoProximaHorda = 0;
int tempoEntreSpawns = 500; // 0.5 segundos entre cada zumbi da mesma horda
int tempoUltimoSpawn = 0;


// Variáveis de Imagem
PImage grama1;
PImage grama2;
PImage pedra;
PImage zumbi;
PImage torre;
PImage balaImg;
PImage casa;

Grafo grafo;
ArrayList<Inimigo> inimigos = new ArrayList<Inimigo>();
ArrayList<Torre> torres = new ArrayList<Torre>();
float custoTorreInicial = 50;

// =========================================
// =========================================

void setup() {
  
  grama1 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/grama1.png");
  grama2 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/grama2.png");
  pedra  = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/pedra.png");
  zumbi  = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/1_Zombie.png");
  torre = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Torre.png"); 
  balaImg = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/bala.png");
  casa = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/Casa.png");

  size(900, 700);
  frameRate(60);

  dinheiro = 1000;

  grid = criaGrid();
  adj = criaAdjacencia();
  grafo = new Grafo(adj);
  
  int linhaDestinoAleatoria = (int)random(n); // Sorteia uma linha (de 0 a 11)
  destinoFinal = index(linhaDestinoAleatoria, f - 1); // Define o destino na última coluna
  
  tempoProximaHorda = millis() + tempoEntreHordas;
  
}

// =========================================
// =========================================

// Substitua toda a sua função draw() por esta
void draw() {
  // Desenha o grafo (chão, casa, etc.)
  grafo.desenhar(null, destinoFinal);

  // Loop dos zumbis 
  for (int i = inimigos.size() - 1; i >= 0; i--) {
    Inimigo z = inimigos.get(i);
    if (z.estaVivo) {
      ArrayList<Integer> novoCaminho = grafo.dijkstra(z.getPosicaoAtualIndex(grafo), destinoFinal);
      z.atualizarCaminho(novoCaminho, grafo);
      
      z.move();
      z.desenha();
    } else {
      dinheiro += z.recompensa;
      inimigos.remove(i);
    }
  }
  
  //Loop das torres
  for (Torre t : torres) {
    t.atualizar(1.0 / frameRate, inimigos);
    t.show(torre); 
  }

  //Lógica do jogo e interface
  gerenciarHordas();
  mostraDinheiro();
  mostraInfoHorda();
}


// =========================================
// ===== FUNÇÕES DE LÓGICA E UTILIDADE =====
// =========================================

void mostraDinheiro() {
  textSize(24);
  fill(255, 215, 0); // Cor de ouro
  textAlign(RIGHT, TOP);
  text("Moedas: " + dinheiro, width - 20, 20);
}

int[][] criaGrid(){
  int[][] m = new int[n][f];
  for(int i = 0; i < n; i++){
    for(int j = 0; j < f; j++){
      m[i][j] = (0);
    }
  }
  return m;
}

void mostraGrid(){
  float l = width/(float)f;
  float h = height/(float)n;
  for(int i = 0; i < n; i++){
    for(int j = 0; j < f; j++){
      stroke(200);
      fill(grid[i][j] == 0 ? 255 : 0);
      rect(j*l, i*h, l, h);
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
// =====          Hordas               =====
// =========================================
void gerenciarHordas() {
  if (!hordaEmAndamento && inimigos.isEmpty()) {
    if (millis() > tempoProximaHorda) {
      hordaAtual++;
      zumbisPorHorda = hordaAtual; // A cada horda, aumenta 1 zumbi
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
 int linhaAleatoria = (int)random(n); // Sorteia um número de 0 a 11 (nossas linhas)
  int origem = index(linhaAleatoria, 0); // Ponto de origem é na linha sorteada, coluna 0
  
  int destino = index(n - 1, f - 1);
  
  // 3. Calcula o caminho a partir do novo ponto de origem
  ArrayList<Integer> caminho = grafo.dijkstra(origem, destino);

  if (!caminho.isEmpty()) {
    zombie novoZombie = new zombie(caminho, grafo);
    inimigos.add(novoZombie);
  }
}

void mostraInfoHorda() {
  textSize(24);
  fill(255, 100, 100); // Vermelho
  textAlign(RIGHT, TOP);
  text("Horda: " + hordaAtual, width - 20, 50); //posição
}

// =========================================
// =========================================


void mousePressed() {
  // Construir torre com o Botão Esquerdo
  if (mouseButton == LEFT) {
    if (dinheiro >= custoTorreInicial) {
      for (int i = 0; i < grafo.numVertices; i++) {
        if (grafo.ocupado[i]) continue;
        PVector pos = grafo.posicoes[i];
        float l = width / (float)f;
        float h = height / (float)n;
        if (mouseX >= pos.x - l/2 && mouseX <= pos.x + l/2 &&
            mouseY >= pos.y - h/2 && mouseY <= pos.y + h/2) {
          dinheiro -= custoTorreInicial;
          torres.add(new Torre(pos.x, pos.y, 1, 150, 1.0, custoTorreInicial));
          grafo.ocupado[i] = true;
          for (int j = 0; j < grafo.numVertices; j++) {
            if (grafo.matrizAdj[i][j] > 0) {
              grafo.matrizAdj[i][j] = 0;
              grafo.matrizAdj[j][i] = 0;
            }
          }
          break;
        }
      }
    } else {
       println("Dinheiro insuficiente para construir a torre!");
    }
  }


  // Construir pedra com o Botão Direito
  if (mouseButton == RIGHT) {
    if (dinheiro >= custoParede) { // Verifica se tem dinheiro para a pedra
      for (int i = 0; i < grafo.numVertices; i++) {
        if (grafo.ocupado[i]) continue;
        PVector pos = grafo.posicoes[i];
        float l = width / (float)f;
        float h = height / (float)n;
        if (mouseX >= pos.x - l/2 && mouseX <= pos.x + l/2 &&
            mouseY >= pos.y - h/2 && mouseY <= pos.y + h/2) {
              
          dinheiro -= custoParede; 
          grafo.ocupado[i] = true; 
          
          // Bloqueia o caminho no grafo
          for (int j = 0; j < grafo.numVertices; j++) {
            if (grafo.matrizAdj[i][j] > 0) {
              grafo.matrizAdj[i][j] = 0;
              grafo.matrizAdj[j][i] = 0;
            }
          }
          println("Parede construída! Dinheiro restante: " + dinheiro);
          break;
        }
      }
    } else {
      println("Dinheiro insuficiente para construir a parede!");
    }
  }
}

// =========================================
// =========================================

void keyPressed() {
  if (key == 'u' || key == 'U') {
    for (Torre t : torres) {
      if (dist(mouseX, mouseY, t.x, t.y) < 20) {
        float custoUpgrade = t.custo + 20; // Calcula o custo do próximo upgrade
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
