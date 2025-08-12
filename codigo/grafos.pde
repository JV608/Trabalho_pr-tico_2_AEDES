// Definição da classe Grafo
class Grafo {
  
  int numVertices;
  int[][] matrizAdj;
  PVector[] posicoes; // Posições das partículas (nós do grafo)
  PVector[] velocidades; // Velocidades das partículas
  //float raio = 10; // Raio dos nós
  float k = 0.001; // Constante da mola para a atração
  float c = 3000; // Constante de repulsão
  int n = 12;
  int f = 22;
  
  // Construtor da classe Grafo
  Grafo(int numVertices) {
    this.numVertices = numVertices;
    matrizAdj = new int[numVertices][numVertices];
    posicoes = new PVector[numVertices];
    velocidades = new PVector[numVertices];
    inicializarPosicoes();
  }
  
  Grafo(int[][] adj) {
    this.numVertices = adj.length;
    matrizAdj = adj;
    posicoes = new PVector[numVertices];
    velocidades = new PVector[numVertices];
    inicializarPosicoes();
  }

  // Adiciona uma aresta entre dois vértices
  void adicionarAresta(int i, int j) {
    matrizAdj[i][j] = 1;
    matrizAdj[j][i] = 1; // Para grafos não direcionados
  }
  
  // Adiciona uma aresta entre dois vértices
  void adicionarAresta(int i, int j, int peso) {
    matrizAdj[i][j] = peso;
    matrizAdj[j][i] = peso; // Para grafos não direcionados
  }

  // Inicializa as posições das partículas em um círculo
  void inicializarPosicoes() {
  
   int cont = 0;
     for(int i = 0; i < n; i++){
      for(int j = 0; j < f; j++){
        cont = cont + 1;
        float x = i;
        float y = j;
         posicoes[cont] = new PVector(x, y);
         velocidades[cont] = new PVector(0, 0);
    }
  }
    // Posição fixa do vértice 0
    posicoes[0] = new PVector(width / 2, height / 2);
    velocidades[0] = new PVector(0, 0);
  }

  // Atualiza as posições das partículas
  void atualizar() {
    for (int i = 1; i < numVertices; i++) {
      PVector forca = new PVector(0, 0);
      
      // Força de repulsão
      for (int j = 0; j < numVertices; j++) {
        if (i != j) {
          PVector direcao = PVector.sub(posicoes[i], posicoes[j]);
          float distancia = direcao.mag();
          if (distancia > 0) {
            direcao.normalize();
            float forcaRepulsao = c / (distancia * distancia);
            direcao.mult(forcaRepulsao);
            forca.add(direcao);
          }
        }
      }

      // Força de atração
      for (int j = 0; j < numVertices; j++) {
        if (matrizAdj[i][j] > 0) {
          PVector direcao = PVector.sub(posicoes[j], posicoes[i]);
          float distancia = direcao.mag();
          direcao.normalize();
          float forcaAtracao = k * (distancia - raio);
          direcao.mult(forcaAtracao);
          forca.add(direcao);
        }
      }

      velocidades[i].add(forca);
      posicoes[i].add(velocidades[i]);

      // Reduz a velocidade para estabilizar a simulação
      velocidades[i].mult(0.5);

      // Mantém as partículas dentro da tela
      if (posicoes[i].x < 0 || posicoes[i].x > width) velocidades[i].x *= -1; 
      if (posicoes[i].y < 0 || posicoes[i].y > height)velocidades[i].y *= -1;
     
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
        stroke(destaque ? color(255, 0, 0) : 0);
        strokeWeight(matrizAdj[i][j]);
        line(posicoes[i].x, posicoes[i].y, posicoes[j].x, posicoes[j].y);
      }
    }
  }

  // Desenha os nós
  fill(255);
  stroke(0);
  strokeWeight(1);
  for (int i = 0; i < numVertices; i++) {
    fill(255);
    ellipse(posicoes[i].x, posicoes[i].y, raio * 2, raio * 2);
    fill(0);
    text(str(i), posicoes[i].x, posicoes[i].y + 4);
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
    return new ArrayList<Integer>(); // sem caminho possível
  }

  return caminho;
}

    
}
