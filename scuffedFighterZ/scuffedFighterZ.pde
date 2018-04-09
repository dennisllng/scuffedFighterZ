//
// scuffedFighterZ.pde
//
// Pooya Berahmandi (Gameplay)
// Jonathan Amey (Gameplay + Art)
// Dennis Ng (User Interface + Gameplay)
// February 21, 2018
// ART 4200
// Project2
// The program is an interactive game 
// that is very similar to many fighting games back in the 90s (Mortal Kombat, Street Fighter)
//
// To prevent keyPressed() freezing on macOS...
// On macOS, enter this on terminal: defaults write -g ApplePressAndHoldEnabled -bool false
// Applications → Utilities → Terminal
//


class fighter
{
  PImage idle;
  PImage punch;
  PImage kick;
  PImage jump;
  PImage crouch;
  PImage dead;
  PVector position;
  float direction;
  PVector velocity;
  float jumpSpeed;
  float walkSpeed;
}

fighter player1, player2;
// --- Player 1 --- //
float left1;
float right1;
float up1;
float down1;

boolean jump1 = false;
boolean crouch1 = false;
boolean punching1 = false;
boolean kicking1 = false;
boolean moving1 = false;
boolean punchReleased1 = false;
boolean kickReleased1 = false;

int punchActive1 = 0;
int kickActive1 = 0;

int actionReseting1 = 0;

// --- Player 2 --- //

float left2;
float right2;
float up2;
float down2;

boolean jump2 = false;
boolean crouch2 = false;
boolean punching2 = false;
boolean kicking2 = false;
boolean moving2 = false;
boolean punchReleased2 = false;
boolean kickReleased2 = false;

int punchActive2 = 0;
int kickActive2 = 0;

int actionReseting2 = 0;


boolean actionReset1 = true;
boolean actionReset2 = true;


// half a pixel per frame gravity.
float gravity = .5;

// Y coordinate of ground for collision
float ground = 425;

int player1Wins = 0;
int player2Wins = 0;

import ddf.minim.*;
Minim minim;

// ------------ UI SFX ---------------//
AudioPlayer menu; // Initialize Main Menu Music
AudioPlayer stageMusic; // Initialize Stage Music
AudioPlayer confirmation; // Initialize confirmation SFX
AudioPlayer navigation; // Initialize navigation SFX
AudioPlayer paused; // Initialize pause SFX


// --- Player 1 SFX --- //
AudioPlayer kickSound1; 
AudioPlayer punchSound1; 

AudioPlayer kickHit1; 
AudioPlayer punchHit1; 

// --- Player 2 SFX --- //
AudioPlayer kickSound2; 
AudioPlayer punchSound2; 

AudioPlayer kickHit2; 
AudioPlayer punchHit2; 

PFont regularFont; // Standard font

PImage logo; // Logo image (Shown during Stage 0)
PImage world; // Globe image for Character select screen (Stage 1)
PImage fighterSelect1; // Dennis Thumbnail
PImage fighterSelect2; // Jonathan Thumbnail
PImage fighterSelect3; // Pooya Thumbnail

PImage fighterDisplay1; // Dennis big profile image during Character Select Screen
PImage fighterDisplay2; // Jonathan big profile image during Character Select Screen
PImage fighterDisplay3; // Pooya big profile image during Character Select Screen

PImage bg;
PImage hud;


// --- Dennis' Images --- //
PImage fighterIdle1;
PImage fighterPunch1;
PImage fighterKick1;
PImage fighterJump1;
PImage fighterCrouch1;
PImage fighterDead1;

// --- Jonathan's Images --- //
PImage fighterIdle2;
PImage fighterPunch2;
PImage fighterKick2;
PImage fighterJump2;
PImage fighterCrouch2;
PImage fighterDead2;

// --- Pooya's Images --- //
PImage fighterIdle3;
PImage fighterPunch3;
PImage fighterKick3;
PImage fighterJump3;
PImage fighterCrouch3;
PImage fighterDead3;


PImage pauseMenu; // Pause Menu

int stage = 0; // Intialize stage to start screen
int previousStage = 0; // Variable carries information of the previous screen

// Coordinates for Player1 icon indicator 
int x1;
int x2;
int x3;

// Coordinates for Player2 icon indicator 
int y1;
int y2;
int y3;

// --- Maximum Length of Healthbar --- //
int player1HealthBar = 65;
int player2HealthBar = 1215;

// --- Player's total amount of damage dealt during the round --- //
int totalDamageDealt1 = 0;
int totalDamageDealt2 = 0;


// --- Status of whatever or not the player is currently alive --- //
boolean alive1 = true;
boolean alive2 = true;

// --- Default fighter position begin of round --- //
int player1Position = 400;
int player2Position = 880;

// --- Initialize first round --- //
int round = 120;

String [] fighterSelection = new String[3]; // Total of THREE fighters to choose from
int player1Highlight; // The fighter that Player1 highlighted and selected during the Character Select Screen
int player2Highlight; // The fighter that Player2 highlighted and selected during the Character Select Screen

Star[] stars = new Star[800]; // Number of Stars on the screen (Stage 0 & Stage 1)

boolean textAppear = true; // Flickering "PRESS ANY KEY TO CONTINUE" text
int blinkSpeed = 30; // Text flickering speed

boolean player1Selected; // Status of whatever or not player 2 selected character
boolean player2Selected; // Status of whatever or not player 2 selected character
int starSpeed = 10; // Speed of stars

boolean pauseStatus = false; // Pause Status
boolean reset = false;
boolean intermission = false;
boolean roundStart = true;


int begin = 0; // Intermission countdown
int roundCountdown = 5940; // roundCountdown/60 equals the current round timer

void setup()
{
  size(1280, 720); 
  frameRate(60);

  minim = new Minim(this);
  menu = minim.loadFile("mainMenu.mp3"); // Import Main Menu song file  
  stageMusic = minim.loadFile("stage1Song.mp3"); // Import stage song file
  confirmation = minim.loadFile("confirmation.mp3"); // Import confirmation SFX file
  navigation = minim.loadFile("navigation.mp3"); // Import navigation SFX file
  paused = minim.loadFile("pause.mp3"); // Import pause SFX file

  punchSound1 = minim.loadFile("punchSound1.wav"); 
  kickSound1 = minim.loadFile("kickSound1.wav"); 

  punchSound2 = minim.loadFile("punchSound2.wav"); 
  kickSound2 = minim.loadFile("kickSound2.wav"); 

  punchHit1 = minim.loadFile("punchHit1.wav"); 
  kickHit1 = minim.loadFile("kickHit1.wav"); 

  punchHit2 = minim.loadFile("punchHit2.wav"); 
  kickHit2 = minim.loadFile("kickHit2.wav"); 

  logo = loadImage("logo.png"); // Import splash art
  world = loadImage("world_map.png"); // Import world map

  pauseMenu = loadImage("pauseMenu.png"); // Import pause menu

  fighterSelect1 = loadImage("fighterSelect1.png"); // Import fighter select icon 1
  fighterSelect2 = loadImage("fighterSelect2.png"); // Import fighter select icon 2
  fighterSelect3 = loadImage("fighterSelect3.png"); // Import fighter select icon 3

  fighterDisplay1 = loadImage("fighterDisplay1.png"); // Import fighter display 1 (Dennis big profile image)
  fighterDisplay2 = loadImage("fighterDisplay2.png"); // Import fighter display 2 (Jonathan big profile image)
  fighterDisplay3 = loadImage("fighterDisplay3.png"); // Import fighter display 3 (Pooya big profile image)

  fighterSelection[0] = "Dennis";
  fighterSelection[1] = "Jonathan";
  fighterSelection[2] = "Pooya";

  bg = loadImage("bg.png"); //fix later
  hud = loadImage("hud.png"); // Loads Hud Png


  // ----- FIGHTERS ----- //
  fighterIdle1 = loadImage("dennisIdle.png"); 
  fighterPunch1 = loadImage("dennisPunch.png");
  fighterKick1 = loadImage("dennisKick.png"); 
  fighterJump1 = loadImage("dennisJump.png");
  fighterCrouch1 = loadImage("dennisCrouch.png");
  fighterDead1 = loadImage("dennisDead.png");

  fighterIdle2 = loadImage("jonathanIdle.png"); 
  fighterPunch2 = loadImage("jonathanPunch.png");
  fighterKick2 = loadImage("jonathanKick.png");
  fighterJump2 = loadImage("jonathanJump.png");
  fighterCrouch2 = loadImage("jonathanCrouch.png");
  fighterDead2 = loadImage("jonathanDead.png");

  fighterIdle3 = loadImage("pooyaIdle.png"); 
  fighterPunch3 = loadImage("pooyaPunch.png");
  fighterKick3 = loadImage("pooyaKick.png");
  fighterJump3 = loadImage("pooyaJump.png");
  fighterCrouch3 = loadImage("pooyaCrouch.png");
  fighterDead3 = loadImage("pooyaDead.png");

  // --- Player 1 Setup Initialization  --- //
  player1 = new fighter();
  player1.position = new PVector(player1Position, ground);
  player1.direction = 1;
  player1.velocity = new PVector(0, 0);
  player1.jumpSpeed = 17;
  player1.walkSpeed = 4;

  // --- Player 2 Setup Initialization  --- //
  player2 = new fighter();
  player2.position = new PVector(player2Position, ground);
  player2.direction = 1;
  player2.velocity = new PVector(0, 0);
  player2.jumpSpeed = 17;
  player2.walkSpeed = 4;

  regularFont = createFont("regularFont.otf", 32);
  background(0);

  // Initiallize starfield background for Character Selection Screen (Stage 1)
  for (int i = 0; i < stars.length; i++)
  {
    stars[i] = new Star();
  }
}

void keyPressed()
{
  // ------------ Paused ---------------//
  final int pause = keyCode;

  if (((pause == TAB) || (pause == ENTER)) && stage != 0) // Pause the game (Except during "PRESS ANY KEY TO CONTINUE")
  {
    if (looping)
    {
      paused.pause();
      paused.rewind();
      paused.play();
      if (stage == 1)
      {
        imageMode(CENTER);
        scale(-1.0, 1.0);
        image(pauseMenu, 0, 0, width, height);
      }
      if (stage == 2)
      {
        imageMode(CORNER);
        scale(1.0, 1.0);
        image(pauseMenu, 0, 0, width, height);
      }
      noLoop();
    } else // Unpause the game
    {
      pauseStatus = false;
      paused.pause();
      paused.rewind();
      paused.play();
      loop();
    }
  }
  // ------------ Unpaused Game STATUS ---------------//
  if (looping) 
  {
    // ------------ "PRESS ANY KEY TO CONTINUE" Screen (Stage 0) ---------------//
    if (stage == 0)
    {
      if (key == ' ')
      {
        previousStage = stage;
        confirmation.pause();
        confirmation.rewind();
        confirmation.play();
        stage = 1;
      }
    }

    // ------------ Character Select Screen (Stage 1) ---------------//
    if (stage == 1)
    {
      if ((key == 'a' || key == 'A') && (player1Selected == false) && (player1Highlight != 0)) // Player 1 selector icon to the left
      {
        x1 -= 100;
        x2 -= 100;
        x3 -= 100;
        player1Highlight--;
        navigation.pause();
        navigation.rewind();
        navigation.play();
      }
      if ((key == 'd' || key == 'D') && (player1Selected == false) && (player1Highlight != 2)) // Player 1 selector icon to the right
      {
        x1 += 100;
        x2 += 100;
        x3 += 100;
        player1Highlight++;
        navigation.pause();
        navigation.rewind();
        navigation.play();
      }
      if ((key == '4') && (player2Selected == false) && (player2Highlight != 0)) // Player 2 selector icon to the left
      {
        y1 -= 100;
        y2 -= 100;
        y3 -= 100;
        player2Highlight--;
        navigation.pause();
        navigation.rewind();
        navigation.play();
      }
      if ((key == '6') && (player2Selected == false) && (player2Highlight != 2)) // Player 2 selector icon to the right
      {
        y1 += 100;
        y2 += 100;
        y3 += 100;
        player2Highlight++;
        navigation.pause();
        navigation.rewind();
        navigation.play();
      }
      if (player1Selected == false)
      {
        if (key == 'q' || key == 'e' || key == 'Q' || key == 'E') // Player 1 choosed their character
        {
          player1Selected = true;
          confirmation.pause();
          confirmation.rewind();
          confirmation.play();

          if (player1Highlight == 0)
          {
            player1.idle = fighterIdle1; 
            player1.punch = fighterPunch1;
            player1.kick = fighterKick1; 
            player1.jump = fighterJump1; 
            player1.crouch = fighterCrouch1;
            player1.dead = fighterDead1;
          }
          if (player1Highlight == 1)
          {
            player1.idle = fighterIdle2; 
            player1.punch = fighterPunch2;
            player1.kick = fighterKick2;
            player1.jump = fighterJump2; 
            player1.crouch = fighterCrouch2;
            player1.dead = fighterDead2;
          }
          if (player1Highlight == 2)
          {
            player1.idle = fighterIdle3; 
            player1.punch = fighterPunch3;
            player1.kick = fighterKick3; 
            player1.jump = fighterJump3; 
            player1.crouch = fighterCrouch3;
            player1.dead = fighterDead3;
          }
        }
      }
      if (player2Selected == false)
      {
        if (key == '7' || key == '9') // Player 2 choosed their character
        {
          player2Selected = true;
          confirmation.pause();
          confirmation.rewind();
          confirmation.play();

          if (player2Highlight == 0)
          {
            player2.idle = fighterIdle1; 
            player2.punch = fighterPunch1;
            player2.kick = fighterKick1;
            player2.jump = fighterJump1; 
            player2.crouch = fighterCrouch1;
            player2.dead = fighterDead1;
          }
          if (player2Highlight == 1)
          {
            player2.idle = fighterIdle2; 
            player2.punch = fighterPunch2;
            player2.kick = fighterKick2;
            player2.jump = fighterJump2; 
            player2.crouch = fighterCrouch2;
            player2.dead = fighterDead2;
          }
          if (player2Highlight == 2)
          {
            player2.idle = fighterIdle3; 
            player2.punch = fighterPunch3;
            player2.kick = fighterKick3;
            player2.jump = fighterJump3; 
            player2.crouch = fighterCrouch3;
            player2.dead = fighterDead3;
          }
        }
      }
    }

    if (stage == 2)
    {
      if (intermission == false)
      { 
        if (alive1 == true && alive2 == true)
        {
          // ---- Player 1 -----//
          if (key == 'd' || key == 'd')
          {
            right1 = 1;
            player1.direction = -1;
            moving1 = true;
          }
          if (key == 'a' || key == 'A')
          {

            left1 = -1;
            player1.direction = 1;
            moving1 = true;
          }

          if (key == 'q' || key == 'Q')
          {
            if (crouch1 == false && jump1 == false && moving1 == false && punching1 == false && kicking1 == false)
            {
              if (actionReset1 == true)
              {
                if (kickReleased1 == true && punchReleased1 == true)
                {
                  kickSound1.pause();
                  kickSound1.rewind();
                  kickSound1.play();
                  kicking1 = true;
                  kickReleased1 = false;
                  damage1();
                }
              }
            }
          }
          if (key == 'e' || key == 'E')
          {
            if (crouch1 == false && jump1 == false && moving1 == false && punching1 == false && kicking1 == false)
            {
              if (actionReset1 == true)
              {
                if (kickReleased1 == true && punchReleased1 == true)
                {
                  punchSound1.pause();
                  punchSound1.rewind();
                  punchSound1.play();
                  punching1 = true;
                  punchReleased1 = false;
                  damage1();
                }
              }
            }
          }

          if (key == 'w' || key == 'W')
          {
            up1 = -1;
            jump1 = true;
          }
          if (key == 's' || key == 'S')
          {

            if (jump1 == false)
            {
              crouch1 = true;
              down1 = 1;
            }
          }
          // ---- Player 2 -----//
          if (key == '6')
          {
            right2 = 1;
            player2.direction = -1;
            moving2 = true;
          }
          if (key == '4')
          {

            left2 = -1;
            player2.direction = 1;
            moving2 = true;
          }

          if (key == '7')
          {
            if (crouch2 == false && jump2 == false && moving2 == false && punching2 == false && kicking2 == false)
            {
              if (actionReset2 == true)
              {
                if (kickReleased2 == true && punchReleased2 == true)
                {
                  kickSound2.pause();
                  kickSound2.rewind();
                  kickSound2.play();
                  kicking2 = true;
                  kickReleased2 = false;
                  damage2();
                }
              }
            }
          }
          if (key == '9')
          {
            if (crouch2 == false && jump2 == false && moving2 == false && punching2 == false && kicking2 == false)
            {
              if (actionReset2 == true)
              {
                if (kickReleased2 == true && punchReleased2 == true)
                {
                  punchSound2.pause();
                  punchSound2.rewind();
                  punchSound2.play();
                  punching2 = true;
                  punchReleased2 = false;
                  damage2();
                }
              }
            }
          }

          if (key == '8')
          {
            up2 = -1;
            jump2 = true;
          }
          if (key == '5')
          {

            if (jump2 == false)
            {
              crouch2 = true;
              down2 = 1;
            }
          }
        }
      }
    }
  }
}




void keyReleased()
{
  if (stage == 2)
  {
    if (key == 'd' || key == 'd')
    {
      right1 = 0;
      moving1 = false;
    }
    if (key == 'a' || key == 'A')
    {
      moving1 = false;
      left1 = 0;
    }
    if (key == 'w' || key == 'W')
    {
      up1 = 0;
      crouch1 = false;
    }
    if (key == 's' || key == 'S')
    {
      crouch1 = false;
      down1 = 0;
    }
    if (key == 'q' || key == 'Q')
    {
      kickReleased1 = true;
    }
    if (key == 'e' || key == 'E')
    {
      punchReleased1 = true;
    }
    if (key == '6')
    {
      right2 = 0;
      moving2 = false;
    }
    if (key == '4')
    {
      moving2 = false;
      left2 = 0;
    }
    if (key == '8')
    {
      up2 = 0;
      crouch2 = false;
    }
    if (key == '5')
    {
      crouch2 = false;
      down2 = 0;
    }
    if (key == '7')
    {
      kickReleased2 = true;
    }
    if (key == '9')
    {
      punchReleased2 = true;
    }
  }
}

void draw()
{
  println(round);
  //abs(player2.position.x - player1.position.x)
  switch(stage)
  {
  case 0:
    // ------------ "PRESS ANY KEY TO CONTINUE" Screen (Stage 0) ---------------//
    background(#011a1d);
    stageMusic.pause();
    stageMusic.rewind();
    /* textAlign(CENTER, CENTER);
     textFont(fighterFont);
     textSize(46);
     text("SCUFFED FIGHTER Z", 640, 400);*/
    //menu.pause();
    //menu.rewind();
    menu.play();
    imageMode(CENTER);
    image(logo, 640, 250);
    logo.resize(0, 400);

    flickerText();
    stageStars();

    x1 = 550;
    x2 = 565;
    x3 = 580;

    y1 = 700;
    y2 = 715;
    y3 = 730;

    player1Selected = false;
    player2Selected = false;

    player1Highlight = 0;
    player2Highlight = 2;

    break;

  case 1:
    // ------------ Character Select Screen (Stage 1) ---------------//
    background(#011a1d);

    fill(#1a9bad);
    triangle(x1, 630, x2, 615, x3, 630);
    fill(#ad241a);
    triangle(y1, 430, y2, 445, y3, 430);

    stroke(0);
    fill(255);
    textFont(regularFont);
    textAlign(CENTER, CENTER);
    textSize(80);
    text("CHARACTER SELECT", 640, 350); 
    fill(#1a9bad);
    textSize(24);
    textAlign(CENTER, TOP);
    text("P1", x2, 630);
    fill(#c32a1f);
    textAlign(CENTER, BOTTOM);
    text("P2", y2, 410);

    stroke(0);
    fill(255);
    textFont(regularFont);
    textAlign(CENTER, CENTER);
    textSize(80);
    text(fighterSelection[player1Highlight], 200, 576); // Display Player 1 highlighted character name
    text(fighterSelection[player2Highlight], 1080, 576); // Display Player 2 highlighted character name

    stageStars(); // Re nder Starfield background

    imageMode(CENTER);
    image(world, 0, -170, 640, 250);
    // ---- Display Character Thumbnails ----//
    image(fighterSelect1, -105, 170, 150, 150);
    image(fighterSelect2, 0, 170, 150, 150);
    image(fighterSelect3, 105, 170, 150, 150);

    player1Display(); // Display Player1 highlighted character
    player2Display(); // Display Player 2 highlighted character

    if ((player1Selected == true) && (player2Selected == true))
    {
      stage = 2;
      menu.pause();
      menu.rewind();
    }

    break;

  case 2:
    // ------------ Fighting Stage (Stage 2) ---------------//
    stageMusic.play();
    scale(1.0, 1.0);
    background(bg);
    imageMode(CORNER);


    if (roundStart == true)  
    {
      roundReset();
      begin++;
      if (begin > 180)
      {
        roundStart = false;
        intermission = false;
        begin = 0;
      }
    }

    hud();
    if (alive1 == true && alive2 == true && roundCountdown > 0)
    {
      roundCountdown--; // roundCountDown countdown as long as both players are alive
    }
    imageMode(CENTER);
    updatePlayer1();
    updatePlayer2();
    // --- Player 1's action reset (Prevent Button Spam) --- //
    if (punching1 == true && punchActive1 < 18)
    {
      punching1 = true;
      punchActive1++;
    }
    if (punchActive1 >= 18)
    {
      punchActive1 = 0;
      punching1 = false;
      actionReset1 = false;
    }

    if (kicking1 == true && kickActive1 < 15)
    {
      kicking1 = true;
      kickActive1++;
    }
    if (kickActive1 >= 15)
    {
      kickActive1 = 0;
      kicking1 = false;
      actionReset1 = false;
    }
    if (actionReset1 == false && actionReseting1 < 20)
    {
      actionReseting1++;
    }
    if (actionReseting1 >= 20)
    {
      actionReseting1 = 0;
      actionReset1 = true;
    }
    
    // --- Player 2's action reset (Prevent Button Spam) --- //
    if (punching2 == true && punchActive2 < 18)
    {
      punching2 = true;
      punchActive2++;
    }
    if (punchActive2 >= 18)
    {
      punchActive2 = 0;
      punching2 = false;
      actionReset2 = false;
    }

    if (kicking2 == true && kickActive2 < 15)
    {
      kicking2 = true;
      kickActive2++;
    }
    if (kickActive2 >= 15)
    {
      kickActive2 = 0;
      kicking2 = false;
      actionReset2 = false;
    }
    if (actionReset2 == false && actionReseting2 < 20)
    {
      actionReseting2++;
    }
    if (actionReseting2 >= 20)
    {
      actionReseting2 = 0;
      actionReset2 = true;
    }
    
    // --- Win Conditions --- //
    if (player2HealthBar <= 695)
    {
      alive2 = false;
      player2HealthBar = 695;
      player1Wins = player1Wins + 1;
      round = round + 1;
    }
    if (player1HealthBar >= 585)
    {
      alive1 = false;
      player1HealthBar = 585;
      player2Wins = player2Wins + 1;
      round = round + 1;
    }
    
    
    if(roundCountdown == 0)
    {
      if(totalDamageDealt1 > totalDamageDealt2)
      {
        player1Wins = player1Wins + 1;
        round = round + 1;
      }
      if(totalDamageDealt1 < totalDamageDealt2)
      {
        player2Wins = player2Wins + 1;
        round = round + 1;
      }
    }
    // --- Round Victory Status --- //
    if (alive1 == false || alive2 == false || roundCountdown == 0)  
    {
      intermission = true;
      if (begin < 120)
      {
        fill(255);
        stroke(0);
        textSize(150);
        text("KO", 630, 360);
      }
      begin++;
      if (begin > 120)
      {
        if(player1Wins > 600 || player2Wins > 600)
        {
          fill(255);
          stroke(0);
          textSize(150);
          if(player1Wins > 600)
          {
            text("PLAYER 1 WINS", 630, 360); 
            textSize(40);
            text("PRESS ESCAPE TO RESTART THE GAME", 640, 500);
            noLoop();
          }
          if(player2Wins > 600)
          {
            text("PLAYER 2 WINS", 630, 360); 
            textSize(40);
            text("PRESS ESCAPE TO RESTART THE GAME", 640, 500);
            noLoop();
          }
          
        }
        else
        {
          intermission = false;
          begin = 0;
          roundStart = true;
        }
      }
    }
    
    break;
  }
}


void flickerText() // Flickering text during "PRESS ANY KEY TO CONTINUE" Screen (Stage 0)
{
  if (frameCount % blinkSpeed == 0)
  {
    textAppear = !textAppear;
  }
  if (textAppear)
  {
    stroke(0);
    textFont(regularFont);
    textAlign(CENTER, CENTER);
    text("PRESS SPACEBAR TO CONTINUE", 640, 500);
  }
}

void stageStars() // Star animation background during "PRESS ANY KEY TO CONTINUE" Screen & Character Select Screen (Stage 0 & 1)
{  
  translate(width / 2, height / 2);
  for (int i = 0; i < stars.length; i++)
  {
    stars[i].update();
    stars[i].show();
  }
}

void player1Display()
{
  if (player1Highlight == 0) // Dennis big profile image during Character Select Screen
  {
    imageMode(CENTER);
    image(fighterDisplay1, -500, 0);
  }
  if (player1Highlight == 1) // Dennis big profile image during Character Select Screen
  {
    imageMode(CENTER);
    image(fighterDisplay2, -500, 0);
  }
  if (player1Highlight == 2) // Dennis big profile image during Character Select Screen
  {
    imageMode(CENTER);
    image(fighterDisplay3, -500, 0);
  }
}

void player2Display()
{
  if (player2Highlight == 0)
  {
    imageMode(CENTER);
    scale(-1.0, 1.0);
    image(fighterDisplay1, -500, 0);
  }
  if (player2Highlight == 1)
  {
    imageMode(CENTER);
    scale(-1.0, 1.0);
    image(fighterDisplay2, -500, 0);
  }
  if (player2Highlight == 2)
  {
    imageMode(CENTER);
    scale(-1.0, 1.0);
    image(fighterDisplay3, -500, 0);
  }
}

void roundReset()
{
  intermission = true;
  player1.position.x = 400;
  player2.position.x = 880;
  player1HealthBar = 65;
  player2HealthBar = 1215;
  roundCountdown = 5940;
  totalDamageDealt1 = 0;
  totalDamageDealt2 = 0;
  alive1 = true;
  alive2 = true;
  if (begin < 100)
  {
    textAlign(CENTER, CENTER);
    fill(255);
    stroke(0);
    textSize(72);
    
    text("ROUND " +round / 120, 630, 360);
    
  }
  if (begin > 100)
  {
    textAlign(CENTER, CENTER);
    fill(255);
    stroke(0);
    textSize(144);
    text("FIGHT", 630, 360);
  }
}

void hud()
{
  rectMode(CORNERS);
  fill(#faa633);
  rect(585, 55, player1HealthBar, 85);
  rect(695, 55, player2HealthBar, 85);
  image(hud, 0, 0, 1280, 720);
  textAlign(CENTER, CENTER);
  fill(255);
  stroke(0);
  textSize(18);
  text("PLAYER 1", 100, 65);
  textSize(36);
  text(fighterSelection[player1Highlight], 125, 100);
  textSize(18);
  text("PLAYER 2", 1180, 65);
  textSize(36);
  text(fighterSelection[player2Highlight], 1150, 100);
  
  
  
  
  textSize(36);
  text("Wins " +player1Wins / 120, 550, 100);
  textSize(36);
  text("Wins " +player2Wins / 120, 730, 100);
  textAlign(CENTER, CENTER);
  textSize(60);
  text(roundCountdown / 60, 640, 55);
}

void updatePlayer1()
{

  if (player1.position.y < ground)
  {
    player1.velocity.y += gravity;
  } else
  {
    player1.velocity.y = 0;
  }

  if (player1.position.y >= ground && up1 != 0)
  {
    player1.velocity.y = -player1.jumpSpeed;
  }
  if (crouch1 == true)
  {
    player1.walkSpeed = 2;
  } else
  {
    player1.walkSpeed = 4;
  }
  player1.velocity.x = player1.walkSpeed * (left1 + right1);

  PVector nextPosition1 = new PVector(player1.position.x, player1.position.y);
  nextPosition1.add(player1.velocity);

  float offset1 = 0;
  if (nextPosition1.x > -28 && nextPosition1.x < (width - 125))
  {
    player1.position.x = nextPosition1.x;
  } 
  if (nextPosition1.y > offset1 && nextPosition1.y < (height - offset1))
  {
    player1.position.y = nextPosition1.y;
  } 

  pushMatrix();

  translate(player1.position.x, player1.position.y);


  imageMode(CENTER);
  if(alive1 == true)
  {
    if (player1.position.x + 30 < player2.position.x- 30 )
    {
      scale(1.0, 1.0);
    }
    if (player1.position.x +  30   > player2.position.x - 30 )
    {
      scale(-1.0, 1.0);
    }
    if ((jump1 == false) && (crouch1 == false) && (punching1 == true) && (kicking1 == false))
    {
      image(player1.punch, 0, 0);
    }
    if ((jump1 == false) && (crouch1 == false) && (punching1 == false) && (kicking1 == true))
    {
      image(player1.kick, 0, 0);
    }
    if ((jump1 == false) && (crouch1 == false) && (punching1 == false) && (kicking1 == false))
    {
      image(player1.idle, 0, 0);
    }
    if (player1.position.y != ground)
    {
      jump1 = true;
    }
    if (player1.position.y == ground)
    {
      jump1 = false;
    }
    if (crouch1 == true)
    {
      image(player1.crouch, 0, 0);
    }
    if (jump1 == true && crouch1 == false)
    {
      image(player1.jump, 0, 0);
    }
  }
  if(alive1 == false)
  {
    image(player1.dead, 0, 125);
  }

  popMatrix();
}


void updatePlayer2()
{

  if (player2.position.y < ground)
  {
    player2.velocity.y += gravity;
  } else
  {
    player2.velocity.y = 0;
  }

  if (player2.position.y >= ground && up2 != 0)
  {
    player2.velocity.y = -player2.jumpSpeed;
  }
  if (crouch2 == true)
  {
    player2.walkSpeed = 2;
  } else
  {
    player2.walkSpeed = 4;
  }
  player2.velocity.x = player2.walkSpeed * (left2 + right2);

  PVector nextPosition2 = new PVector(player2.position.x, player2.position.y);
  nextPosition2.add(player2.velocity);

  float offset2 = 0;
  if (nextPosition2.x > -28 && nextPosition2.x < (width - 125))
  {
    player2.position.x = nextPosition2.x;
  } 
  if (nextPosition2.y > offset2 && nextPosition2.y < (height - offset2))
  {
    player2.position.y = nextPosition2.y;
  } 

  pushMatrix();

  translate(player2.position.x, player2.position.y);


  imageMode(CENTER);
  if(alive2 == true)
  {
    if (player1.position.x +  30  > player2.position.x - 30 )
    {
      scale(1.0, 1.0);
    }
    if (player1.position.x + 30  < player2.position.x - 30 )
    {
      scale(-1.0, 1.0);
    }
    if ((jump2 == false) && (crouch2 == false) && (punching2 == true) && (kicking2 == false))
    {
      image(player2.punch, 0, 0);
    }
    if ((jump2 == false) && (crouch2 == false) && (punching2 == false) && (kicking2 == true))
    {
      image(player2.kick, 0, 0);
    }
    if ((jump2 == false) && (crouch2 == false) && (punching2 == false) && (kicking2 == false))
    {
      image(player2.idle, 0, 0);
    }
    if (player2.position.y != ground)
    {
      jump2 = true;
    }
    if (player2.position.y == ground)
    {
      jump2 = false;
    }
    if (crouch2 == true)
    {
      image(player2.crouch, 0, 0);
    }
    if (jump2 == true && crouch2 == false)
    {
      image(player2.jump, 0, 0);
    }
  }
  if(alive2 == false)
  {
    image(player2.dead, 0, 125);
  }
  

  popMatrix();
}
void damage1()
{
  if (punching1 == true && (abs(player2.position.x - player1.position.x) < 128) && player2.position.y > 190)
  {
    if (crouch2 == true)
    {
      player2HealthBar = player2HealthBar - 5;
      punchHit1.pause();
      punchHit1.rewind();
      punchHit1.play();
      totalDamageDealt1 += 5;
    } else
    {
      player2HealthBar = player2HealthBar - 25;
      punchHit1.pause();
      punchHit1.rewind();
      punchHit1.play();
      totalDamageDealt1 += 25;
    }
  }
  if (kicking1 == true && (abs(player2.position.x - player1.position.x) < 128) && player2.position.y > 190)
  {
    if (crouch2 == true)
    {
      player2HealthBar = player2HealthBar - 10;
      kickHit1.pause();
      kickHit1.rewind();
      kickHit1.play();
      totalDamageDealt1 += 10;
    } else
    {
      player2HealthBar = player2HealthBar - 15;
      kickHit1.pause();
      kickHit1.rewind();
      kickHit1.play();
      totalDamageDealt1 += 15;
    }
  }
}

void damage2()
{
  if (punching2 == true && (abs(player2.position.x - player1.position.x) < 128) && player1.position.y > 190)
  {
    if (crouch1 == true)
    {
      player1HealthBar = player1HealthBar + 5;
      punchHit2.pause();
      punchHit2.rewind();
      punchHit2.play();
      totalDamageDealt2 += 5;
    } else
    {
      player1HealthBar = player1HealthBar + 25;
      punchHit2.pause();
      punchHit2.rewind();
      punchHit2.play();
      totalDamageDealt2 += 25;
    }
  }
  if (kicking2 == true && (abs(player2.position.x - player1.position.x) < 128) && player1.position.y > 190)
  {
    if (crouch1 == true)
    {
      player1HealthBar = player1HealthBar + 10;
      kickHit2.pause();
      kickHit2.rewind();
      kickHit2.play();
      totalDamageDealt2 += 10;
    } else
    {
      player1HealthBar = player1HealthBar + 15;
      kickHit2.pause();
      kickHit2.rewind();
      kickHit2.play();
      totalDamageDealt2 += 15;
    }
  }
}