final color RED = color(255, 0, 0);  //constant: a variable with fixed value
final color BLUE = color(0, 0, 255);


final int PLAY = 0;
final int PAUSE = 1;
final int RESET = 2;
final int END = 3;

int gameMode = PLAY;


PImage background;
PImage bomb;
PImage enemy;
PImage rightTank;
PImage leftTank;
PImage forwardTank;
PImage backwardTank;

int Ximage;
int Yimage;
int movementSpeed = 6;
int random1, random2;
int level =1;
int numOfMines = 5;
int score = 0;
int numOfTanks = 1;
int highScore;
int points = 0;

boolean destruction = false;
boolean enemyCollision = false;
boolean enemyShot = false;


Player player;
Projectile[] playerBullets;
String[] stringHighScore;


ArrayList<Landmine> mines = new ArrayList<Landmine>(); // array list of landmines/bombs
ArrayList<Enemy> tanks = new ArrayList<Enemy>(); // array list of enemy tanks
ArrayList<Object> obstacles = new ArrayList<Object>();






void setup() {
  size(1000, 1000); // size of screen
  Ximage = width/2;// central X position of image 
  Yimage = height/2; // central Y position of image
  background = loadImage("download.jpg");
  forwardTank = loadImage("forwardTank.png");
  bomb = loadImage("mine.png");
  enemy = loadImage("bad_tank.png");
  rightTank = loadImage("rightTank.png");
  leftTank = loadImage("leftTank.png");
  backwardTank = loadImage("backwardTank.png");
  background.resize(2000, 2000);
  leftTank.resize(50, 50);
  backwardTank.resize(50, 50);
  forwardTank.resize(50, 50);
  enemy.resize(50, 50);
  rightTank.resize(50, 50);
  bomb.resize(20, 20);
  imageMode(CENTER);
  
  stringHighScore = loadStrings("numbers.txt");
  highScore = Integer.valueOf(stringHighScore[0]);
    

  player = new Player(BLUE, forwardTank); // initialise player
  playerBullets = new Projectile[8]; // array of player bulelts is givent 8 bullets
 
  for(int i = 0; i < numOfTanks; i++){
     tanks.add(new Enemy(enemy, RED));
     tanks.get(i).active = true;
     obstacles.add(tanks.get(i));
   
  }
  for (int i = 0; i<numOfMines; i++) { // 5 mines initialised
    mines.add(new Landmine(bomb));
    obstacles.add(mines.get(i));
  }
  for (int i = 0; i < playerBullets.length; i++) { // all player bullets have a starting position of the center of the screen and are initialised
    playerBullets[i] = new Projectile(player.colour, width/2, height/2, player.direction);
  }
}
void draw(){
  if(gameMode == PLAY) {
    score++;
    image(background, Ximage, Yimage); // starting image
    text(player.ammo + "/8", 100, 900); // display information on screen
    textSize(15);
    text("LEVEL: "+ level, width/6, height/6);
    text("POINTS: "+points, (width/6)*5, height/6);
    for (int i = 0; i<mines.size(); i++) { // move mines
      Landmine mine = mines.get(i);
      mine.update();
    }
    player.display(); // show player on screen
    for (int i = 0; i<playerBullets.length; i++) { // if bullet is active, show bullet moving on screen
      if (playerBullets[i].active == true) {
        playerBullets[i].update();
      }
    }
    
    for(int i = 0; i < tanks.size(); i++) { // if tank is active, show tank moving on screen
      Enemy tank = tanks.get(i);
      if (tank.active == true) {
        tank.update();
      }
        for(int j = 0; j < tank.bullets.length; j++){
          if(tank.bullets[j].active == true){
            tank.bullets[j].update();
            if(dist(tank.bullets[j].projectileX, tank.bullets[j].projectileY, width/2, height/2) < 20 && tank.bullets[j].active == true){
              gameMode = END;
            }
          }
          else{
            if(tank.active == true){
              enemyShot = tank.shoot();
              if(enemyShot == true){
                tank.bullets[j].active = true;
                tank.bullets[j].direction = tank.direction;
                tank.bullets[j].projectileX = tank.x;
                tank.bullets[j].projectileY = tank.y;
              }
            }
          }
        
      }
    }
    for(int i = 0; i < playerBullets.length; i++){
      for(int j = 0; j < tanks.size(); j++){
        Enemy tank = tanks.get(j);
       if(playerBullets[i].active &&
         playerBullets[i].tankCollision(tank)){
          
          points++;
          tank.active = false;
          playerBullets[i].active = false;
          playerBullets[i].projectileX = width/2;
          playerBullets[i].projectileY = height/2;
      }
      }
    }
    for (int i = 0; i < mines.size(); i++) {
      Landmine mine = mines.get(i);
      destruction = mine.collision();   // if a mine has collided with the player
      if (destruction == true){
        gameMode = END; // game is over
      }
    }
    if (score > (1000 * level)){// if score > 1000 add 1 tank and 1 mine
      level++;
      mines.add(new Landmine(bomb));
      tanks.add(new Enemy(enemy, RED));
      obstacles.add(mines.get(mines.size() - 1));
      obstacles.add(tanks.get(tanks.size() - 1));
      for(int i = 0; i < tanks.size(); i++){
        Enemy tank = tanks.get(i);
        tank.active = true;
        tank.y = 0;
        tank.x = (int)random(tank.xStart, tank.xEnd);
      }
    }
  
  }
  if(gameMode == END) {
    background(128);
    for(int i = 0; i < playerBullets.length; i++){
      playerBullets[i].projectileX = width/2;
      playerBullets[i].projectileY = height/2;     
    }
    if(points > highScore){
      highScore = points;
    }
   
    
    stringHighScore[0] = Integer.toString(highScore); 
    saveStrings("numbers.txt", stringHighScore);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("GAME OVER!, press 2 to play again", width/2, height/2);
    
    textSize(20);
    text("High Score: " + highScore, width/2, 595);
    
    
    
  } 
  if(gameMode == PAUSE) {
    image(background, Ximage, Yimage); // show still image
    text(player.ammo + "/8", 100, 950);
    for (int i = 0; i<mines.size(); i++) {
      Landmine mine = mines.get(i);
      mine.display(); // show mines
    }
    for (int i = 0; i<tanks.size(); i++) {
      Enemy tank = tanks.get(i);
      tank.display(); // show tanks
      for(int j = 0; j < tank.bullets.length; j++){
        if(tank.bullets[j].active == true){
          tank.bullets[j].show();
        }
      }
    }
    player.display();
    //player.lines();
    for (int i = 0; i<playerBullets.length; i++) {
      if (playerBullets[i].active == true) {
        playerBullets[i].show(); // show player bullets
      }
    }
    textAlign(CENTER, CENTER);
    text("GAME PAUSED, press 0 to unpause ", width/2, height/2);
  }
  if (gameMode == RESET) {
    score = 0; // reset the score and level.
    level = 1;
    points = 0;
    player.ammo = 8;
    for (int i = mines.size()-1; i >= numOfMines; i--) {
      mines.remove(i); // remove extra mines
    }
    for (int i = tanks.size()-1; i >= numOfTanks; i--) {
      tanks.remove(i); // remove extra tanks
    }
    for(int i = obstacles.size() - 1; i >= numOfTanks + numOfMines; i--){
    obstacles.remove(i);
    }
    for (int i = 0; i<playerBullets.length; i++) {
      playerBullets[i].active = false; // make all player bullets inctive
    }
    for (int i = 0; i<mines.size(); i++) {
      Landmine mine = mines.get(i);
      mine.y = (int)random(mine.yStart, mine.yEnd); // reset mine Y coordinate to top of screen
      mine.x = (int)random(mine.xStart, mine.xEnd); // randomise mine x value
    }
    for (int i = 0; i<tanks.size(); i++) {
      Enemy tank = tanks.get(i);
      tank.y = 0; // reset tanks to top of screen
      tank.x = (int)random(tank.xStart, tank.xEnd); // randomise tank starting position
      tank.active = true;
      for(int j = 0; j < tank.bullets.length; j++){
        tank.bullets[j].projectileX = tank.x;
        tank.bullets[j].projectileY = tank.y;
        tank.bullets[j].active = false;
        
      }
    }
    
    Ximage = 500;
    Yimage = 500;
    gameMode = PLAY;
  }
}
void keyPressed(){
  if (gameMode == PLAY){
    if (key == CODED) {
      if(keyCode == LEFT){
        player.image = leftTank;// change player image to left facing
        player.direction = 2;
        for(int i = 0; i < playerBullets.length; i++){
          if(playerBullets[i].active == false){
            playerBullets[i].direction = 2;
          } 
        }
        Ximage = Ximage + movementSpeed; // move screen to the right
        if (Ximage > 970) {
          Ximage = 970; // maximum x value of screen
        } 
        else {
          for (int i = 0; i < obstacles.size(); i++) {
            Object obstacle = obstacles.get(i); // move all mine x positions to the right
            obstacle.moveLeft();
         
          }
          for (int i = 0; i < tanks.size(); i++) {
            Enemy tank = tanks.get(i); // move all active tank bullets to the right
            for(int j = 0; j < tank.bullets.length; j++){
                tank.bullets[j].projectileX = tank.bullets[j].projectileX + movementSpeed;  
            }
          }
  
          for (int i = 0; i< playerBullets.length; i++) {
            if (playerBullets[i].active == true) {
              playerBullets[i].projectileX = playerBullets[i].projectileX + movementSpeed; // move all active bullets to the right
            }
          }
      }
      
     }
    } 
    if (key == CODED) {
      if(keyCode == RIGHT){
        player.direction = 3;
        for(int i = 0; i < playerBullets.length; i++){
          if(playerBullets[i].active == false){
            playerBullets[i].direction = 3;
          } 
        }
        player.image = rightTank; // change player image to right facing
        Ximage = Ximage - movementSpeed; // move screen to the left
        if (Ximage < 30) {
          Ximage = 30; // min screen x position
        } 
        else {
          for (int i = 0; i < obstacles.size(); i++) {
            Object obstacle = obstacles.get(i); // move all mine x positions to the right
            obstacle.moveRight();
         
          }
          for (int i = 0; i < tanks.size(); i++) {
            Enemy tank = tanks.get(i); // move all tank x positions to the right
            for(int j = 0; j < tank.bullets.length; j++){
                tank.bullets[j].projectileX = tank.bullets[j].projectileX - movementSpeed;  
            }
          }
        }
        for (int i = 0; i< playerBullets.length; i++) {
          if (playerBullets[i].active == true) {  // move player bullets to the left
            playerBullets[i].projectileX = playerBullets[i].projectileX - movementSpeed;
          }
        }
      }
      
    }if (key == CODED) {
      if(keyCode == DOWN){
          player.direction = 0;
        for(int i = 0; i < playerBullets.length; i++){
          if(playerBullets[i].active == false){
            playerBullets[i].direction = 0;
          } 
        }
  
        player.image = backwardTank;
        Yimage = Yimage - movementSpeed;
        if (Yimage < 30) {
          Yimage = 30;
        } 
        else {
          for (int i = 0; i< playerBullets.length; i++) {
            if (playerBullets[i].active == true) { // move player bullets up
              playerBullets[i].projectileY = playerBullets[i].projectileY - movementSpeed;
            }
          }
          for (int i = 0; i < obstacles.size(); i++) {
            Object obstacle = obstacles.get(i); // move all mine x positions to the right
            obstacle.moveDown();
         
          }
          for (int i = 0; i < tanks.size(); i++) {
            Enemy tank = tanks.get(i); // move all tank x positions to the right
            for(int j = 0; j < tank.bullets.length; j++){
                tank.bullets[j].projectileY = tank.bullets[j].projectileY - movementSpeed;  
            }
          }
        }
      }
      
    } 
    if (key == CODED) {
      if(keyCode == UP){
        player.direction = 1;
        for(int i = 0; i < playerBullets.length; i++){
          if(playerBullets[i].active == false){
            playerBullets[i].direction = 1;
          } 
        }
        player.image = forwardTank; // forward facing image
        Yimage = Yimage + movementSpeed; // move image down
        if (Yimage > 990) {
          Yimage = 990; 
        } 
        else {
          for (int i = 0; i< playerBullets.length; i++) {
            if (playerBullets[i].active == true) {  // move bulelts down
              playerBullets[i].projectileY = playerBullets[i].projectileY + movementSpeed;
            }
          }
          for (int i = 0; i < obstacles.size(); i++) {
            Object obstacle = obstacles.get(i); // move all mine x positions to the right
            obstacle.moveUp();
         
          }
          for (int i = 0; i < tanks.size(); i++) {
            Enemy tank = tanks.get(i); // move all tank x positions to the right
            for(int j = 0; j < tank.bullets.length; j++){
                tank.bullets[j].projectileY = tank.bullets[j].projectileY + movementSpeed;  
            }
          }
        }
      }
     }
      
  }
  if (key == 'r') {
    player.ammo = 8;
  }
  
  if (keyCode == '0') {
    gameMode = PLAY;
  } else if (keyCode == '1') {
    gameMode = PAUSE;
  } else if (keyCode == '2') {
    gameMode = RESET;
  }
}
void mousePressed() {
  if (gameMode == PLAY) {
    if (mousePressed == true) {
       for (int i = 0; i < playerBullets.length; i++) {
         if (playerBullets[i].active == false) {
           if (player.ammo < 1) {
             println("out of ammo, 'r' to reload");
             break;
           } else {
             playerBullets[i].active = true;
             player.ammo--;
             break;
           }
         }
       }
    }
  }
}
