abstract class Inimigo {
  float x, y;
  int hp;
  boolean estaVivo;
  int recompensa;
  
  // NOVOS CAMPOS PARA O SISTEMA DE ATAQUE
  float danoPorSegundo;
  float tempoEntreAtaques;
  float tempoUltimoAtaque;

  abstract int getPosicaoAtualIndex(Grafo grafo);
  
  Inimigo() {
    this.estaVivo = true;
    this.tempoUltimoAtaque = 0; // Inicializa o tempo de ataque
  }

  abstract void move();
  abstract void desenha();
  abstract void atualizarCaminho(ArrayList<Integer> novoCaminhoIndices, Grafo grafo);

  void receberDano(int dano) {
    this.hp -= dano;
    if (this.hp <= 0) {
      this.estaVivo = false;
    }
  }
}
