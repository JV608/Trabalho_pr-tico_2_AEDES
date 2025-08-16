// Definição da classe Grafo
class Grafo {
  
  int[][] matrizAdj;
  PVector[] posicoes; // Posições das partículas (nós do grafo)
  PVector[] velocidades; // Velocidades das partículas
  float raio = 20; //
 
  int n = 12;
  int f = 22;
  int numVertices = n*f;
  boolean[] ocupado;
  int[] tiposolo;

  
  
  
  // Construtor da classe Grafo
  Grafo(int numVertices) {
    this.numVertices = numVertices;
    matrizAdj = new int[numVertices][numVertices];
    ocupado = new boolean[numVertices];
    posicoes = new PVector[numVertices];
    velocidades = new PVector[numVertices];
    inicializarPosicoes();
    tiposolo = new int[numVertices];
       for (int i = 0; i < numVertices; i++) {
    tiposolo[i] = int(random(2)); // 0 ou 1 aleatório
}
  }
  
  Grafo(int[][] adj) {
    this.numVertices = adj.length;
    matrizAdj = adj;
    ocupado = new boolean[numVertices]; 

    posicoes = new PVector[numVertices];
    velocidades = new PVector[numVertices];
    inicializarPosicoes();
    tiposolo = new int[numVertices];
for (int i = 0; i < numVertices; i++) {
    tiposolo[i] = int(random(2)); // 0 ou 1 aleatório
}
  }

  // Adiciona uma aresta entre dois vértices
  void adicionarAresta(int i, int j) {
    matrizAdj[i][j] = 1;
    matrizAdj[j][i] = 1; // Para grafos não direcionados
    
  }
  


  // Inicializa as posições das partículas em um círculo
 void inicializarPosicoes() {
  float l = width / (float)f;
  float h = height / (float)n;

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < f; j++) {
      int idx = index(i, j);
      posicoes[idx] = new PVector(j * l + l / 2, i * h + h / 2);
      velocidades[idx] = new PVector(0, 0);
    }
  }
}


  

   

  // Desenha o grafo
  void desenhar(ArrayList<Integer> caminho) {
  textAlign(CENTER);

  // Desenha as arestas
  for (int i = 0; i < numVertices; i++) {
    for (int j = i + 1; j < numVertices; j++) {
      if (matrizAdj[i][j] > 0) {
        boolean destaque = false;
        if (caminho != null) {
          for (int k = 0; k < caminho.size() - 1; k++) {
            if ((caminho.get(k) == i && caminho.get(k + 1) == j) ||
                (caminho.get(k) == j && caminho.get(k + 1) == i)) {
              destaque = true;
              break;
            }
          }
        }
        stroke(destaque ? color(#E21EE3) : 0);
        strokeWeight(2);
        line(posicoes[i].x, posicoes[i].y, posicoes[j].x, posicoes[j].y);
      }
    }
  }

  // Desenha os nós
  fill(#1EB0E3);
  stroke(0);
  strokeWeight(1);
  for (int i = 0; i < numVertices; i++) {
    if (!ocupado[i]){
      if(tiposolo[i] == 1){
        image(grama1,posicoes[i].x - 20,posicoes[i].y - 28,42,59);
      }else{
        image(grama2,posicoes[i].x - 20,posicoes[i].y - 28,42,59);
      }
    }
    else{
    image(pedra,posicoes[i].x - 20,posicoes[i].y - 28,42,59);
    }
   
    
  }
}

  
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
    // Encontra o vértice com menor distância não visitado
    int u = -1;
    int minDist = Integer.MAX_VALUE;
    for (int j = 0; j < numVertices; j++) {
      if (!visitado[j] && dist[j] < minDist) {
        u = j;
        minDist = dist[j];
      }
    }

    if (u == -1) break; // Não há mais vértices acessíveis
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

  // Reconstrói o caminho
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
