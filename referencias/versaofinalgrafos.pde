Grafo grafo;

int selecionadoA = -1;
int selecionadoB = -1;

void setup() {
  size(800, 600);
  frameRate(60);
  
  int n = 10;
  int[][] adj = new int[n][n];
  
  for(int i = 0; i < n; i++)
    for(int j = 0; j < n; j++){
      if(i == j){
        adj[i][j] = 0;
      }
      else{
        adj[i][j] = random(1) > 0.5 ? int(random(1, 5)) : 0;
        adj[j][i] = adj[i][j];
      }
    }
  
  grafo = new Grafo(adj);
  
}

void draw() {
  background(255);
  grafo.atualizar();

  ArrayList<Integer> caminho = null;
  if (selecionadoA != -1 && selecionadoB != -1) {
    caminho = grafo.dijkstra(selecionadoA, selecionadoB);
  }

  grafo.desenhar(caminho);
    // Mostrar o caminho na parte inferior
  fill(0);
  textAlign(LEFT);
  textSize(16);

  if (caminho != null && caminho.size() > 0) {
    String texto = "pressione r para reiniciar! - Caminho: ";
    for (int i = 0; i < caminho.size(); i++) {
      texto += caminho.get(i);
      if (i < caminho.size() - 1) texto += " → ";
    }
    text(texto, 10, height - 20);
  } else if (selecionadoA != -1 && selecionadoB != -1) {
    text("Sem caminho entre " + selecionadoA + " e " + selecionadoB, 10, height - 20);
  }

}

void mousePressed() {
  for (int i = 0; i < grafo.numVertices; i++) {
    PVector pos = grafo.posicoes[i];
    if (dist(mouseX, mouseY, pos.x, pos.y) < grafo.raio) {
      if (selecionadoA == -1) {
        selecionadoA = i;
      } else {
        selecionadoB = i;
      }
      break;
    }
  }
}
void keyPressed() {
  if (key == 'r' || key == 'R') {
    selecionadoA = -1;
    selecionadoB = -1;
  }
}
