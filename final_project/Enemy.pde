class Enemy extends Object{
  int  ySpeed, randomDirection, randomShot;
  boolean active;
  PImage image;
  color colour;
  Projectile[] bullets;
  Enemy(PImage image, color colour){
    super(image);
    this.colour = colour;
    this.ySpeed = 1;
    bullets = new Projectile[8];
    for (int i = 0; i <bullets.length; i++) { 
      bullets[i] = new Projectile(colour, x, y, randomDirection);
    }
    this.y = 0;
    
  }
  
  void move(){
    y = y + ySpeed;
  }
  void display(){
    super.display();
  }
  void update(){
    super.display();
    move();
  }
  boolean shoot(){
    randomShot = (int)random(0,1250);
    if(randomShot == 500){
      return true;
    }
    else{
      return false;
    }
    
  }
    
}
