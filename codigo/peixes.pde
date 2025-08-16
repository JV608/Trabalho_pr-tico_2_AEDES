class peixe{
 float x , y ;
 float vx, vy;
 float d;
 int cor;
 ArrayList<PVector> caminho; 
 int idxDestino;
 
 
 
public peixe(ArrayList<Integer> caminhoIndices, Grafo grafo) {
  this.x = grafo.posicoes[caminhoIndices.get(0)].x;
  this.y = grafo.posicoes[caminhoIndices.get(0)].y;
  this.vx = 0;
  this.vy = 0;
  this.d = 50;
  this.cor = color((int) random(255), (int) random(255), (int) random(255));
  
  caminho = new ArrayList<PVector>();
  for(int i : caminhoIndices) {
    caminho.add(grafo.posicoes[i].copy()); // copia das posições do grafo
  }
  
  idxDestino = 1; // começa indo pro segundo nó
}




public void move() {
  if (idxDestino >= caminho.size()) return; // terminou o caminho
  
  PVector destino = caminho.get(idxDestino);
 float dx = destino.x - x;
float dy = destino.y - y;

float fatorSuavizacao = 0.1; // 0 < fator < 1
vx = lerp(vx, 0.1 * dx, fatorSuavizacao);
vy = lerp(vy, 0.1 * dy, fatorSuavizacao);




  
  x += vx;
  y += vy;
  
  // se chegou perto do destino, passa pro próximo
  if (dist(x, y, destino.x, destino.y) < 2) {
    idxDestino++;
  }
}

public void desenha(){
  
  image(zumbi,x - 30 ,y - 30,55,55);

}
void atualizarCaminho(ArrayList<Integer> novoCaminhoIndices, Grafo grafo) {
        ArrayList<PVector> novoCaminho = new ArrayList<PVector>();
        for (int i : novoCaminhoIndices) {
            novoCaminho.add(grafo.posicoes[i].copy());
        }
        // aqui você pode tentar manter idxDestino proporcional
        caminho = novoCaminho;
    }
}
