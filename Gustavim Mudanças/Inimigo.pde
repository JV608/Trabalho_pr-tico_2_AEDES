abstract class Inimigo {

  float x, y;
  int hp;
  boolean estaVivo;
  int recompensa;

  abstract int getPosicaoAtualIndex(Grafo grafo);
  
  Inimigo() {
    this.estaVivo = true;
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
