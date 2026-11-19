class Player{
  color colour;
  int ammo = 8;
  PImage image;
  int direction = 1;
  Player(color colour, PImage image){
    this.colour = colour;
    this.image = image;
  }
  void display(){
    image(image, width/2, height/2);
  }
  
  
}
