//GRIDS
int[][] grid;
int[][] adj;
int n = 12;
int f = 22;

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
PImage grama1, grama2, pedra, torre1, torre2, balaImg, casa;
PImage zumbi1, zumbi2, zumbi3;

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
  float faixaAltura = 50; // Adicione isso se ainda não tiver
  grafo = new Grafo(adj, faixaAltura);

  tempoProximaHorda = millis() + tempoEntreHordas;

}

// =========================================
// =========================================

void draw() {
  // Desenha o fundo da faixa de interface
  fill(50);
  noStroke();
  rect(0, 0, width, faixaAltura);
  
  // Desenha o grid abaixo da faixa
  mostraGrid();

  // recalcula o caminho do grafo (para desenho)
  int origem = index(0, 0);
  int destino = index(n - 1, f - 1);
  ArrayList<Integer> caminhoAtual = grafo.dijkstra(origem, destino);

  grafo.desenhar(caminhoAtual);


//  loop do zumbi
  for (int i = inimigos.size() - 1; i >= 0; i--) {
    Inimigo z = inimigos.get(i);
    if (z.estaVivo) {
      z.atualizarCaminho(caminhoAtual, grafo);
      z.move();
      z.desenha();
    } else {
      dinheiro += z.recompensa;
      inimigos.remove(i);
      println("Zumbi derrotado! Dinheiro atual: " + dinheiro);
    }
  }


// loop das torres
  for (Torre t : torres) {
    t.atualizar(1.0 / frameRate, inimigos);
    t.show(torre);
  }

  mostraDinheiro();
  gerenciarHordas();
  mostraInfoHorda();
  mostraonome();
}


// =========================================
// ===== FUNÇÕES DE LÓGICA E UTILIDADE =====
// =========================================

void mostraDinheiro() {
  textSize(24);
  fill(255, 215, 0); // Cor de ouro
  textAlign(RIGHT, CENTER); // Alinha o texto na horizontal (direita) e vertical (centro)
  text("Moedas: " + dinheiro, width - 20, faixaAltura / 2); // Centraliza verticalmente na faixa
}

void mostraInfoHorda() {
  textSize(24);
  fill(255, 100, 100); // Vermelho
  textAlign(LEFT, CENTER); // Alinha o texto na horizontal (esquerda) e vertical (centro)
  text("Horda: " + hordaAtual, 20, faixaAltura / 2); // Centraliza verticalmente na faixa
}
 void mostraonome() {
 textSize(34);
 fill(70, 150, 110);

 textAlign(LEFT, CENTER); // Alinha o texto na horizontal (esquerda) e vertical (centro)
 text("PROTEJA A VILA", 335, faixaAltura / 2); // Centraliza verticalmente na faixa
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
      
      // Se você não está usando imagens, use a versão com cores
      // fill(grid[i][j] == 0 ? 255 : 0);
      // rect(j * l, i * h + faixaAltura, l, h);
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
  int origem = index(0, 0);
  int destino = index(n - 1, f - 1);
  ArrayList<Integer> caminho = grafo.dijkstra(origem, destino);

  if (!caminho.isEmpty()) {
    zombie novoZombie = new zombie(caminho, grafo);
    inimigos.add(novoZombie);
  }
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

        float h = (height - faixaAltura) / (float)n; // Altura ajustada

        // Verifica o clique, ajustando a posição Y do mouse

        if (mouseX >= pos.x - l/2 && mouseX <= pos.x + l/2 &&

            mouseY >= pos.y - h/2 + faixaAltura && mouseY <= pos.y + h/2 + faixaAltura) {

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

        float h = (height - faixaAltura) / (float)n; // Altura ajustada

        // Verifica o clique, ajustando a posição Y do mouse

        if (mouseX >= pos.x - l/2 && mouseX <= pos.x + l/2 &&

            mouseY >= pos.y - h/2 + faixaAltura && mouseY <= pos.y + h/2 + faixaAltura) {



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

      if (dist(mouseX, mouseY - faixaAltura, t.x, t.y) < 20) { // Posição Y do mouse ajustada

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

