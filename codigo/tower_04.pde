int[][] grid;
int[][] adj;
int n = 12;
int f = 22;
int dinheiro;


PImage grama1;
PImage grama2;
PImage pedra;
PImage zumbi;

int selecionadoA = -1;


Grafo grafo;
zombie a;

void setup() {
  grama1 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/grama1.png");
  grama2 = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/grama2.png");
  pedra  = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/pedra.png");
  zumbi  = loadImage("https://raw.githubusercontent.com/JV608/Trabalho_pr-tico_2_AEDES/main/data/1_Zombie.png");

  size(900, 700);
  frameRate(60);

  dinheiro = 100;

  grid = criaGrid();
  adj = criaAdjacencia();
  grafo = new Grafo(adj);
  int origem = index(0, 0);
  int destino = index(n - 1, f - 1);
  ArrayList<Integer> caminhoInicial = grafo.dijkstra(origem, destino);

  // cria peixe com o caminho inicial
  a = new zombie(caminhoInicial, grafo);
 
  
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






void mostraDinheiro() {
  textSize(24);
  fill(255, 215, 0); // Cor de ouro
  textAlign(RIGHT, TOP);
  text("Moedas: " + dinheiro, width - 20, 20);       
}






void draw() {
  mostraGrid();

  // recalcula o caminho do grafo (para desenho)
  int origem = index(0, 0);
  int destino = index(n - 1, f - 1);
  ArrayList<Integer> caminhoAtual = grafo.dijkstra(origem, destino);

  grafo.desenhar(caminhoAtual);

  // atualiza o caminho interno do peixe sem resetar posição
  a.atualizarCaminho(caminhoAtual, grafo);

  // move e desenha o peixe
  a.move();
  a.desenha();
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

void mousePressed() {
  for (int i = 0; i < grafo.numVertices; i++) {
    PVector pos = grafo.posicoes[i];
float l = width / (float)f;  // largura célula
float h = height / (float)n; // altura célula


if (mouseX >= pos.x - l/2 && mouseX <= pos.x + l/2 &&
    mouseY >= pos.y - h/2 && mouseY <= pos.y + h/2) {
  

   

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
}

