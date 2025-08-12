int[][] grid;
int n = 12;
int f = 22;
void setup(){
  size(900,600);
  frameRate(60);
  grid = criaGrid();
 
}

int[][] criaGrid(){
  int[][] m = new int[n][f];
  
  for(int i = 0; i < n; i++){
    for(int j = 0; j < f; j++){
      m[i][j] = (0);
    }
  }
  return m;
}

void mostraGrid(){
  float l = width/(float)n;
  float h = height/(float)n;
  
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      stroke(200);
      fill(grid[i][j] == 0 ? 255 : 0);
      rect(j*l, i*h, l, h);
    }
  }
  
}





void draw(){
  mostraGrid();
 
  
  if(mousePressed) grid = criaGrid();
}
