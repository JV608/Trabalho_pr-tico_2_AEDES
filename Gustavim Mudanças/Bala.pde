public class Bala {
  float x, y;    
  float vx, vy;
  int dano;      
  boolean ativa; 
  PImage imagemDaBala; 

  public Bala(float x, float y, float vx, float vy, int dano, PImage img) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.dano = dano;
    this.ativa = true;
    this.imagemDaBala = img;
  }

  public void mover() {
    x += vx;
    y += vy;
    
    if (x < 0 || x > width || y < 0 || y > height) {
      ativa = false;
    }
  }

  public void show() {
    image(imagemDaBala, x - 8, y - 8, 24, 24); 
  }

  public boolean Colidir(Inimigo inimigo) {
    float distancia = dist(x, y, inimigo.x, inimigo.y);
    return distancia < 35; 
  }
}
