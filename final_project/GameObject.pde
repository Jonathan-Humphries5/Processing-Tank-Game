abstract class Object{
  final int Left = 0;
  final int Right = 1;
  final int Up = 2;
  final int Down = 3;
  int x, y, xStart, xEnd, yStart, yEnd, direction, random2, movementSpeed;
  boolean active = true;
  PImage objectImage;
  Object(PImage image){
    this.xStart = 0;
    this.xEnd = 500;
    this.yStart = 0;
    this.yEnd = 500;
    this.x = (int)random(xStart, xEnd);
    this.y = (int)random(yStart, yEnd);
    this.active = true;
    this.objectImage = image;
    this.movementSpeed = 6;
    random2 = (int)random(0,4);
    if(random2 == 0){
      direction = Left;
    }
    else if(random2 == 1){
      direction = Right;
    }
    else if(random2 == 2){
      direction = Up;
    }
    else if(random2 == 3){
      direction = Down;
    }
  }
  
  
  
  void display(){
    image(objectImage, x, y);
  }
  abstract void move();
   
  abstract void update();
     
  boolean collision() {
    return dist(x, y, width/2, height/2) < 20;
  }
  void moveLeft(){
    x = x + movementSpeed;
    xStart = xStart + movementSpeed;
    xEnd = xEnd + movementSpeed;
  }
  void moveRight(){
    x = x - movementSpeed;
    xStart = xStart - movementSpeed;
    xEnd = xEnd - movementSpeed;
  }
  void moveDown(){
    y = y - movementSpeed;
    yStart = yStart - movementSpeed;
    yEnd = yEnd - movementSpeed;
  }
  void moveUp(){
    y = y + movementSpeed;
    yStart = yStart + movementSpeed;
    yEnd = yEnd + movementSpeed;
  }
}
