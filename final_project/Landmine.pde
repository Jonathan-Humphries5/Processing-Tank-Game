class Landmine extends Object {
  int movementSpeed;
  
  Landmine(PImage objectImage) {
    super(objectImage);
    random2 = (int)random(0,4);
    movementSpeed = (int)random(4,7);
  }
  
  void update(){
    super.display();
    move();
  }
  void display(){
    super.display();
  }
  void move(){
    if(direction == Down){
       y = y + movementSpeed;
       if (y > height) {
         newDirection();
       }
     }
    else if(direction == Up){
       y = y - movementSpeed;
       if (y < 0) {
        newDirection();
       }
     }
    else if(direction == Right){
       x = x + movementSpeed;
       if (x > width) {
         newDirection();
       }
     }
    else if(direction == Left){
       x = x - movementSpeed;
       if (x < 0) {
          newDirection();
       }
    }
  }
  
  void newDirection(){
    random2 = (int)random(0,4);
    movementSpeed = (int)random(4,7);
      if(random2 == 0){
        direction = Left;
        x = width;
        y = (int)random(yStart, yEnd);
      }
      else if(random2 == 1){
        direction = Right;
        x = 0;
        y = (int)random(yStart, yEnd);
      }
      else if(random2 == 2){
        direction = Up;
        y = height;
        x = (int)random(xStart, xEnd);
      }
      else if(random2 == 3){
        direction = Down;
        y = 0;
        x = (int)random(xStart, xEnd);
      }  
  }
  
}
