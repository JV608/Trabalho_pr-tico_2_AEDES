import math;

public class Torre{
   
  final float comprimento = 59, largura = 49;
  float x, y;
  float alcance;
  float cadencia; // em segundos
  float custo;
  float tempoDesdeUltimoTiro;
  int nivel;
  int dano;
  

  Torre(float x, float y, int dano, float alcance, float cadencia, float custo) {
    this.x = x;
    this.y = y;
    this.dano = dano;
    this.alcance = alcance;
    this.cadencia = cadencia;
    this.custo = custo;
    this.tempoDesdeUltimoTiro = tempoDesdeUltimoTiro;
    this.nivel = 1;
  }
  
  
  void atualizar(float deltaTime, ArrayList<Inimigo> listaDeInimigos) {
    tempoDesdeUltimoTiro += deltaTime;

    if (tempoDesdeUltimoTiro >= this.cadencia) {
        Inimigo alvo = encontrarAlvo(listaDeInimigos);
        
        if (alvo != null) {
            this.atirar(alvo);
            this.tempoDesdeUltimoTiro = 0;
        }
    }
  }
  
  
  void atirar(Inimigo inimigo) {

  float dx = inimigo.x - x;
  float dy = inimigo.y - y;
  

  float dist = sqrt(dx*dx + dy*dy);
  

  float fator = VelBala / dist;
  

  float velX = dx * fator;
  float velY = dy * fator;
  
  new Bala(x, y, velX, velY, dano);
  }
  
  
  
  
  public void upgrade() {
     if (nivel < 5) {
        this.nivel++;
        this.dano = this.dano + 1;
        this.alcance = this.alcance + 5;
        this.custo = this.custo + 20;
        this.cadencia = this.cadencia - 0.1;
            
     System.out.println("Torre aprimorada +1 : " + this.nivel);
       
      } else {
            System.out.println("Torre está em nível máximo. Você está apelão.");
        }
    }
 
 
 
  void EstaNoAlcance(ArrayList<Inimigo> listaDeInimigos){
     
    for (Inimigo inimigo : listaDeInimigos) {
    
    float distanciaX = Torre.x - inimigo.x;
    float distanciaY = Torre.y - inimigo.y;
    
    double distanciaReal = Math.sqrt((distanciaX * distanciaX) + (distanciaY * distanciaY));
    
    if (distanciaReal <= Torre.alcance) {
        Torre.atacar(inimigo);
        break; 
    }
    }
 
  }
 
 
 
  void show(PImage foto){
    
  image(foto, bola.x, bola.y, 100, 100);
 
  }

}
