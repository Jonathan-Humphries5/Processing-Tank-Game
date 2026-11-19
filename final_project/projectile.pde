
class Projectile{
  int projectileSpeed = 3;
  int projectileX, direction = 0;
  int projectileY;
  float constantY;
  int constantX;
  color colour;
  boolean active = false;
  Projectile(color colour, int projectileX, int projectileY, int direction){
    this.colour = colour;
    this.projectileX = projectileX;
    this.projectileY = projectileY;
    this.direction = direction;
  }
  void show(){
    stroke(colour);
    ellipse(projectileX, projectileY, 5, 5);
  }
  void move(Player other){
    if(active == true){
      if(colour == BLUE){
        if(direction == 1){
          projectileY = projectileY - projectileSpeed;
          
        }
        else if(direction == 0){
          projectileY = projectileY + projectileSpeed;
         
        }
        else if(direction == 2){
          projectileX = projectileX - projectileSpeed;
          
        }
         else if(direction == 3){
          projectileX = projectileX + projectileSpeed;
          
        }
        if(projectileY < 0 || projectileY > height || projectileX < 0 || projectileX > width){
            active = false;
            projectileY = height/2;
            projectileX = width/2;
            direction = other.direction;
        }
      }
      else if(colour == RED){
        projectileY = projectileY + projectileSpeed;
        if(projectileY > height){
          active = false;
          projectileX = 0;
          projectileY = 0;
        }
      }
    }
  }
    
  void update(){
    show();
    move(player);
  }
  boolean tankCollision(Enemy other){
    if(dist(projectileX, projectileY, other.x, other.y) < 20 && colour != other.colour && other.active == true){
      return true;
    }
    else{
      return false;
    }
    
  }
}
