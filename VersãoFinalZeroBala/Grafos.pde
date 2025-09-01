// Definição da classe Grafo
class Grafo {

  int[][] matrizAdj;
  PVector[] posicoes; // Posições das partículas (nós do grafo)
  PVector[] velocidades; // Velocidades das partículas
  float raio = 20;

  int n = 12;
  int f = 22;
  int numVertices = n * f;
  boolean[] ocupado;
  
  int[][] grid;
  
  float faixaAltura;

  Grafo(int[][] adj, int[][] grid, float faixaAltura) {
    this.numVertices = adj.length;
    this.faixaAltura = faixaAltura;
    this.matrizAdj = adj;
    this.grid = grid;
    this.ocupado = new boolean[numVertices];
    this.posicoes = new PVector[numVertices];

    inicializarPosicoes();
  }

  void adicionarAresta(int i, int j) {
    matrizAdj[i][j] = 1;
    matrizAdj[j][i] = 1;
  }

  void inicializarPosicoes() {
    float l = width / (float) f;
    float alturaAreaJogo = height - faixaAltura;
    float h = alturaAreaJogo / (float) n;

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < f; j++) {
        int idx = i * f + j;
        posicoes[idx] = new PVector(j * l + l / 2, i * h + h / 2 + faixaAltura);
      }
    }
  }
  
  void desenharCenario(int destinoIdx) {
    float l = width / (float) f;
    float alturaAreaJogo = height - faixaAltura;
    float h = alturaAreaJogo / (float) n;

    // Desenha as celulas (grama e pedras) a partir da matriz 'grid'
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < f; j++) {
        PVector pos = posicoes[index(i, j)];
        if (grid[i][j] == 1) {
          image(grama1, pos.x - l / 2, pos.y - h / 2, l, h);
        } else if (grid[i][j] == 0) {
          image(pedra, pos.x - l / 2, pos.y - h / 2, l, h);
        }
      }
    }
    
    // Desenha a casa no final do caminho
    image(casa, posicoes[destinoIdx].x - 70, posicoes[destinoIdx].y - 50, 150, 150);
  }
  
  // =========================================
  // ===             dijkstra              ===
  // =========================================

  ArrayList<Integer> dijkstra(int origem, int destino) {
    int[] dist = new int[numVertices];
    int[] anterior = new int[numVertices];
    boolean[] visitado = new boolean[numVertices];

    for (int i = 0; i < numVertices; i++) {
      dist[i] = Integer.MAX_VALUE;
      anterior[i] = -1;
      visitado[i] = false;
    }

    dist[origem] = 0;

    for (int i = 0; i < numVertices; i++) {
      int u = -1;
      int minDist = Integer.MAX_VALUE;
      for (int j = 0; j < numVertices; j++) {
        if (!visitado[j] && dist[j] < minDist) {
          u = j;
          minDist = dist[j];
        }
      }

      if (u == -1) break;
      visitado[u] = true;

      for (int v = 0; v < numVertices; v++) {
        if (matrizAdj[u][v] > 0 && !visitado[v]) {
          int alt = dist[u] + matrizAdj[u][v];
          if (alt < dist[v]) {
            dist[v] = alt;
            anterior[v] = u;
          }
        }
      }
    }

    ArrayList<Integer> caminho = new ArrayList<Integer>();
    for (int v = destino; v != -1; v = anterior[v]) {
      caminho.add(0, v);
    }

    if (caminho.size() == 1 && caminho.get(0) != origem) {
      return new ArrayList<Integer>();
    }

    return caminho;
  }
}
