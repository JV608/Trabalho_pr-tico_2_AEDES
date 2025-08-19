public class Bala {
  float x, y;    
  float vx, vy;
  float VelBala;
  int dano;      
  boolean ativa; 

  public Bala(float x, float y, float vx, float vy, int dano, float VelBala) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.dano = dano;
    this.VelBala = VelBala;
    this.ativa = true;
  }

  public void mover() {
    x += vx;
    y += vy;
    
    if (x < 0 || x > width || y < 0 || y > height) {
      ativa = false;
    }
  }

  public void show() {
    fill(255, 0, 0); 
    noStroke();
    ellipse(x, y, 8, 8); 
  }

  public boolean Colidir(Inimigo inimigo) {
    float distancia = dist(x, y, inimigo.x, inimigo.y);
    return distancia < 10; 
  }
}
