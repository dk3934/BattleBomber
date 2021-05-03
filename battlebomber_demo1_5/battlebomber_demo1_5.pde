  //---------------------UPDATE LOG---------------------
  //battlebomber_demo1.1_Apr23_18:44
  //Functions Enabled:
  //1. print green background
  //2. print grey boundaries -- rectangles
  //3. setup player --> initial position - (200,20); shape - yellow rectangle
  //4. one can manipulate the player via keyboard keys --> (Up, Down, Left, Right)
  //5. player can move freely within the boundaries
  
  //battlebomber_demo1.2_Apr24_00:50
  //Updates:
  //1. changed to OOP
  //2. added boxes --> coffee color rectangles
  //3. add three notebooks for future use: 
  //   rock_position_notebook, empty_position_notebook, box_position_notebook.
      /*
      'notebooks':
      Every notebook is a multidimentional array, which contains many'[x,y]' like small 
      arrays.
      Every small array is the coordinate of the topleft point of rock(or box or empty 
      grid)rectangle. (since we basically construct the rectangle by using the topleft 
      coordinates,the length and the width ---> rect(x,y, width, length)).
      */
  //4. 'boolean inarraychecker(int [][] notebook, int x, int y)' to check if a specific 
  //   rectangle is in a notebook.
  //5. 'boolean walkable_checker(int [][] notebook1, int [][] notebook2, int x, int y)'
  //   to check if our road is blocked or not.
  
  
  //battlebomber_demo1.2_Apr24_19:40
  //Updates:
  //1. eabled player to drop bombs -----> black rectangle
  //2. bomb explodes approx every 1.5sec for every bomb
  //3. separeted to 3 programs 
  
  //battlebomber_demo1.3_Apr26_23:42
  //Updates:
  //1. set bomb explosion range == 1
  //2. boxes can now be crashed by bombs
  //3. bad news: require more memory (256 MB)
  //4. updated the image for wood box!
  
  //battlebomber_demo1.4_Apr28_01:42
  //Updates:
  //1. animation for bomb explosion, 
  //2. updated player skin, rock skin, wall skin, background skin
  //3. updated sound for bombs' explosion, and collecting stars
  //4. stars created, buired  under boxes, vanish after getting collected
  //5. determined the 1st winning conditions: collected all the stars
  
  //battlebomber_demo1.4_Apr29_01:12
  //Updates:
  //1. determined the 1st losing conditions: get bombed
  //2. updated 'pre-game UI' (dont know what that is called)
  
  /*
  ---------------------------------------------------------------------------------
  ------REMEMBER TO ADD 'MINIM' (NOT 'SOUND'!) IN YOUR PROCESSING'S LIBRARY FILE------
  ---------------------------------------------------------------------------------
  */
  
  //battlebomber_demo1.5_May2_18:12
  //Updates:
  //1. added background music
  //2. added 'pick-game UI' used for selecting levels
  //3. added 'RESTART' button and 'MENU' button in 'win-game UI' and 'lose-game UI' 
  //4. added 'QUIT' button for player to quit the game
  //5. lowered the volume of each background music
  
  //On Agenda: create monsters
  
  import ddf.minim.*;
  //import ddf.minim.spi.*; // for AudioRecordingStream
  //import ddf.minim.ugens.*;
  import java.util.*;

  //We want to create a 21 * 21 board 
  int multiplyer = 40;                    //multiplyer of every block size
  int size = 21 * multiplyer;
  int xMax = 19 * multiplyer;                         // max x-coord player can get to
  int yMax = 19 * multiplyer;                         // max y-coord player can get to
  int x = 10 * multiplyer;                            // player's initial x-coord
  int y = multiplyer;                                 // player's initial y-coord
  int xi = multiplyer;                                // player's step size on x-axis
  int yi = multiplyer;                                // player's step size on y-axis
  int num_rock = 10;
  int score = 0;                                      // initial score
  
  
  
  //build a new board
  Board newboard;
  
  //images needed
  PImage box_dungeon;
  PImage box2;
  PImage rock_dungeon;
  PImage rock2;
  PImage wall_dungeon;
  PImage wall_sky;
  PImage bomb;
  PImage background;
  PImage player_skin;
  PImage player_star;
  PImage explosion;
  PImage star;
  PImage play_initial_button;
  PImage play_clicked_button;
  PImage level1_initial_button;
  PImage level1_clicked_button;
  PImage level2_initial_button;
  PImage level2_clicked_button;
  PImage quit_initial_button;
  PImage quit_clicked_button;
  PImage restart_initial_button;
  PImage restart_clicked_button;
  PImage menu_initial_button;
  PImage menu_clicked_button;
  Minim minim;

  AudioSample explode;
  AudioSample collect_stars;
  AudioPlayer pre_game;
  AudioPlayer in_game;
  AudioPlayer win_game;
  AudioPlayer lose_game;
  AudioPlayer pick_game;
  
  int gameScreen = 0;
  int start_time;
  int counter = 0;                  //used to set the timer 
  int time_limit = 0;
  int game_picked = 0;              //to indicate which game the player have picked
  
  void setup() {
       size(840, 840);                   // 420*420 canvas //WARNING: the size() function only take numbers!!! variables are not allowed
       //background(0,100,0);            // background color dark green
       newboard = new Board(21 * multiplyer, 21 * multiplyer);    // new board 420*420
       
       //smooth(4);                     // used for 'anti-aliasing'
       

       box2 = loadImage("images/gift_box.png");

       rock2 = loadImage("images/55.png");

       wall_sky = loadImage("images/88.png");
       bomb = loadImage("images/bomb.png");
       background = loadImage("images/00.png");
       player_skin = loadImage("images/player_start.png");
       explosion = loadImage("images/explosion.png");
       star = loadImage("images/star.png");
       player_star = loadImage("images/player_star.png");
       play_initial_button = loadImage("images/play_initial2.png");
       play_clicked_button = loadImage("images/play_clicked2.png");
       level1_initial_button = loadImage("images/level1_initial.png");
       level1_clicked_button = loadImage("images/level1_clicked.png");
       level2_initial_button = loadImage("images/level2_initial.png");
       level2_clicked_button = loadImage("images/level2_clicked.png");
       quit_initial_button = loadImage("images/quit_initial.png");
       quit_clicked_button = loadImage("images/quit_clicked.png");
       restart_initial_button = loadImage("images/restart_initial.png");
       restart_clicked_button = loadImage("images/restart_clicked.png");
       menu_initial_button = loadImage("images/menu_initial.png");
       menu_clicked_button = loadImage("images/menu_clicked.png");
       
       //image (background, 0, 0, 21 * multiplyer, 21 * multiplyer);
       textSize(multiplyer);
       
       minim = new Minim(this);
       
       explode = minim.loadSample("audio/explode.mp3", 1000);
       collect_stars = minim.loadSample("audio/ding.mp3", 512);
       pre_game = minim.loadFile("audio/01 Broforce Theme Song.mp3");
       in_game = minim.loadFile("audio/14 City (Low Intensity).mp3");
       win_game = minim.loadFile("audio/07 This Ends Now (Victory Sting).mp3");
       lose_game = minim.loadFile("audio/12 End of the Line (Victory Sting).mp3");
       pick_game = minim.loadFile("audio/02 Choose Your Destiny.mp3");
   
       
  } 
     

  
  
    void draw(){
      // Display the contents of the current screen
      if (gameScreen == 0) {
        initScreen();
      } else if (gameScreen == 1) {
        gameScreen();
      } else if (gameScreen == 2) {
        gameWinScreen();
      } 
      else if (gameScreen == 3) {
        gameLostScreen();
      } 
      else if (gameScreen == 8){
        picklevelScreen();
      }
    }   

   /********* SCREEN CONTENTS *********/

  void initScreen() {
    //mute bgm at win_game UI & lose_game UI
    win_game.mute();
    lose_game.mute();
    
    //unmute and play bgm at pre-game UI
    pre_game.unmute();
    pre_game.setVolume(0);
    if(! pre_game.isPlaying()){
      pre_game.play();
    }

    
    fill(237,25,65);
    rect(0,0, 21 * multiplyer, 21 * multiplyer);
    textSize(1.5 * multiplyer);
    fill(0, 0, 0);
    textAlign(CENTER);
    text("BATTLEBOMBER", 10.5 * multiplyer, 7 * multiplyer);
    textSize(0.5 * multiplyer);
    fill(0, 0, 0);
    textAlign(CENTER);
    text("Designer: Kaiwen Zhou", 10 * multiplyer, 10 * multiplyer);
    textSize(0.5 * multiplyer);
    fill(0, 0, 0);
    textAlign(CENTER);
    text("CO-Designer: Diana        CO-Designer: Juan", 10 * multiplyer, 18 * multiplyer);
    if(mouseX < 12.5 * multiplyer && mouseX > 7.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
        image (play_clicked_button, 7.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
    }
    else{
        image (play_initial_button, 7.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
    }
    if(mouseX < 12.5 * multiplyer && mouseX > 7.5 * multiplyer && mouseY < 17 * multiplyer && mouseY > 15 * multiplyer){
        image (quit_clicked_button, 7.5 * multiplyer, 15 * multiplyer, 5 * multiplyer, 2 * multiplyer);
    }
    else{
        image (quit_initial_button, 7.5 * multiplyer, 15 * multiplyer, 5 * multiplyer, 2 * multiplyer);
    }
  }
  
  void picklevelScreen() {
    //mute bgm at win_game UI & lose_game UI
    pre_game.mute();
    //unmute and play bgm at pre-game UI
    pick_game.unmute();
    pick_game.play();

    //in_game.loop();
    
    fill(232, 0, 18);
    rect(0,0, 21 * multiplyer, 21 * multiplyer);
    textSize(1.5 * multiplyer);
    fill(0, 0, 0);
    textAlign(CENTER);
    text("LEVELS", 10.5 * multiplyer, 7 * multiplyer);
    
    if(mouseX < 8.5 * multiplyer && mouseX > 3.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
        image (level1_clicked_button, 3.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
    }
    else{
        image (level1_initial_button, 3.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
    }
    
    if(mouseX < 15.5 * multiplyer && mouseX > 10.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
        image (level2_clicked_button, 10.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
    }
    else{
        image (level2_initial_button, 10.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
    }
  }
  
  
  
  void gameScreen() {
      
      if(counter == 0){
        start_time = millis();
      }
       counter ++;
      //mute bgm at pre-game UI
      pre_game.mute();
      win_game.mute();
      lose_game.mute();
      pick_game.mute();

      //turn on bgm when in game
      in_game.play();
      if(! in_game.isPlaying()){
          in_game.play();
      }
      // redraw the background in each iteration of the draw method
      image (background, 0, 0, 21 * multiplyer, 21 * multiplyer);
      
      //Use the rock_position_notebook to draw the rocks and use images
      for (int i = 0; i< 80; i++){
        image (wall_sky, newboard.rock_position_notebook[i][0], newboard.rock_position_notebook[i][1], multiplyer, multiplyer);
      }
      for (int i = 80; i < newboard.rock_position_notebook.length; i++){
        image (rock2, newboard.rock_position_notebook[i][0], newboard.rock_position_notebook[i][1], multiplyer, multiplyer);
      }
      
      //display the timer
      fill(0, 0, 0);
      int time_in_milli = millis() - start_time;
      int time_in_second = time_limit - time_in_milli / 1000;
      textSize(multiplyer);
      text("timer = "+ time_in_second, 15 * multiplyer - (multiplyer / 2), multiplyer );
      
      //go to lose screen if timer goes below zero
      if(time_in_second < 0){
        gameScreen = 3;
      }
      
      //Use the star_position_notebook to draw the stars
      //*REMEMBER TO DRAW THE STARS BEFORE DRAWING BOXES!*
      int num_of_star_left = newboard.star_position_notebook.length;
      if(num_of_star_left == 0){
        image (player_skin, 10 * multiplyer, multiplyer, multiplyer, multiplyer);        //print player at initial position
        gameScreen = 2;
      }
      for (int i = 0; i< newboard.star_position_notebook.length; i++){
        //updated the image for wood box
        image (star, newboard.star_position_notebook[i][0], newboard.star_position_notebook[i][1], multiplyer, multiplyer);
      }
      
      //Use the box_position_notebook to draw the boxes
      for (int i = 0; i< newboard.box_position_notebook.length; i++){
        //updated the image for wood box
        image (box2, newboard.box_position_notebook[i][0], newboard.box_position_notebook[i][1], multiplyer, multiplyer);
      }
      
      //display score
      fill(0, 0, 0);
      textSize(multiplyer);
      text("score = "+ score, 3 * multiplyer + multiplyer / 2, multiplyer );
      

      //the bomb explode in approx 1.5sec
      int length2;
      try{
         length2 = newboard.bomb_position_notebook.length;
      }
      catch (NullPointerException e){
         length2 = 0;
      }
      if (length2 != 0){
        //set the bomb timer
        for(int i = 0; i<length2; i++){
          //set the time to show the explosion symbol
          if ((millis()-newboard.bomb_time_notebook[0][0]) > 1000){
            //setup a temporary processing_bomb_range_notebook2 for checking explosion positions
            int [][] processing_bomb_range_notebook2 = new int [4][];
            processing_bomb_range_notebook2 = Board.concate(processing_bomb_range_notebook2, newboard.bomb_range_notebook[0][0], newboard.bomb_range_notebook[0][1]);
            processing_bomb_range_notebook2 = Board.concate(processing_bomb_range_notebook2, newboard.bomb_range_notebook[1][0], newboard.bomb_range_notebook[1][1]);
            processing_bomb_range_notebook2 = Board.concate(processing_bomb_range_notebook2, newboard.bomb_range_notebook[2][0], newboard.bomb_range_notebook[2][1]);
            processing_bomb_range_notebook2 = Board.concate(processing_bomb_range_notebook2, newboard.bomb_range_notebook[3][0], newboard.bomb_range_notebook[3][1]);
            // delete all the null elements (first four) in processing_bomb_range_notebook2
            processing_bomb_range_notebook2 = Board.deletefirst(processing_bomb_range_notebook2);
            processing_bomb_range_notebook2 = Board.deletefirst(processing_bomb_range_notebook2);
            processing_bomb_range_notebook2 = Board.deletefirst(processing_bomb_range_notebook2);
            processing_bomb_range_notebook2 = Board.deletefirst(processing_bomb_range_notebook2);
            
            int [] current_position_player = {x, y};
            boolean die_or_not = Board.in_notebook_checker(processing_bomb_range_notebook2, current_position_player);
            if(die_or_not == true){
              gameScreen = 3;
            }
            //System.out.println(Arrays.deepToString(processing_bomb_range_notebook2));
            //check if the processing_bomb_range_notebook2 contain any positions of the rock, and delete
            // them if it does
            processing_bomb_range_notebook2 = Board.compare_delete(processing_bomb_range_notebook2, newboard.rock_position_notebook);
            //System.out.println(Arrays.deepToString(processing_bomb_range_notebook2));
            
            //show the explosion image. Bang!
            for(int p = 0; p < processing_bomb_range_notebook2.length; p++){
              image (explosion, processing_bomb_range_notebook2[p][0], processing_bomb_range_notebook2[p][1], multiplyer, multiplyer);
            }
            //play bombs' explode sound
            explode.trigger();
            
            
            if ((millis()-newboard.bomb_time_notebook[0][0]) > 1500){
              //delete boxes that are around the bomb (future target)
              
              //setup a temporary processing_bomb_range_notebook for deleting
              int [][] processing_bomb_range_notebook = new int [4][];
              processing_bomb_range_notebook = Board.concate(processing_bomb_range_notebook, newboard.bomb_range_notebook[0][0], newboard.bomb_range_notebook[0][1]);
              processing_bomb_range_notebook = Board.concate(processing_bomb_range_notebook, newboard.bomb_range_notebook[1][0], newboard.bomb_range_notebook[1][1]);
              processing_bomb_range_notebook = Board.concate(processing_bomb_range_notebook, newboard.bomb_range_notebook[2][0], newboard.bomb_range_notebook[2][1]);
              processing_bomb_range_notebook = Board.concate(processing_bomb_range_notebook, newboard.bomb_range_notebook[3][0], newboard.bomb_range_notebook[3][1]);
              
              processing_bomb_range_notebook = Board.deletefirst(processing_bomb_range_notebook);
              processing_bomb_range_notebook = Board.deletefirst(processing_bomb_range_notebook);
              processing_bomb_range_notebook = Board.deletefirst(processing_bomb_range_notebook);
              processing_bomb_range_notebook = Board.deletefirst(processing_bomb_range_notebook);
              
              
              
              // delete specified box range posiitions in box_position_notebook
              newboard.box_position_notebook = Board.compare_delete(newboard.box_position_notebook, processing_bomb_range_notebook);
              
              // delete specified box range posiitions in box_range_notebook
              newboard.bomb_range_notebook = Board.deletefirst(newboard.bomb_range_notebook);
              newboard.bomb_range_notebook = Board.deletefirst(newboard.bomb_range_notebook);
              newboard.bomb_range_notebook = Board.deletefirst(newboard.bomb_range_notebook);
              newboard.bomb_range_notebook = Board.deletefirst(newboard.bomb_range_notebook);
              
              //delete the bomb position after it explodes.
              newboard.bomb_position_notebook = Board.deletefirst(newboard.bomb_position_notebook);
              //delete the time info of the bomb
              newboard.bomb_time_notebook = Board.deletefirst(newboard.bomb_time_notebook);
              
            }
          }
        }
      }
      
      //Use the bomb_position_notebook to draw the bombs
      int length;
      try{
         length = newboard.bomb_position_notebook.length;
      }
      catch (NullPointerException e){
         length = 0;
      }
      if (length != 0){
        for (int i = 0; i< newboard.bomb_position_notebook.length; i++){
          /*
        stroke(0);                         //black boarder
        fill(0);                           //black color
        rect(newboard.bomb_position_notebook[i][0],newboard.bomb_position_notebook[i][1],20,20);
        */
        image (bomb, newboard.bomb_position_notebook[i][0], newboard.bomb_position_notebook[i][1], multiplyer, multiplyer);
        }
      }
      
      // set the player in player_skin at the initial position
      
      //check if the length of newboard.star_time_notebook is 0 or not
      int length_star_time;
      try{
         length_star_time = newboard.star_time_notebook.length;
      }
      catch (NullPointerException e){
         length_star_time = 0;
      }
      //if the length of newboard.star_time_notebook is 0, then we use the original skin
      //of the player
      image (player_skin, x, y, multiplyer, multiplyer);
      //if the length of newboard.star_time_notebook is not 0, then we use the updated skin
      //(i.e. new skin) of the player
      if(length_star_time != 0){
           image (player_star, x, y, multiplyer, multiplyer);
           if ((millis()-newboard.star_time_notebook[0][0]) > 1000 ){
           //delete the time info of the star
           newboard.star_time_notebook = Board.deletefirst(newboard.star_time_notebook);
           }
      }
      //set loops for audio--win_game & audio--lose_game
      if(gameScreen == 2){
        win_game.loop();
      }
      else if (gameScreen == 3){
        lose_game.loop();
      }
      
  }
  //disply the 'win' screen
  void gameWinScreen() {
        //mute bgm at pre-game UI
        in_game.mute();
  
        //turn on bgm when in game
        win_game.unmute();
        
        
        image (background, 0, 0, 21 * multiplyer, 21 * multiplyer);
        fill(0, 0, 0);
        textSize(multiplyer);
        text("You won! Scored: " + score, 8 * multiplyer, 5 * multiplyer);
        text("Wanna play again ?", 8 * multiplyer, 7 * multiplyer);

        if(mouseX < 8.5 * multiplyer && mouseX > 3.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
            image (restart_clicked_button, 3.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
        }
        else{
            image (restart_initial_button, 3.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
        }
        
        if(mouseX < 15.5 * multiplyer && mouseX > 10.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
            image (menu_clicked_button, 10.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
        }
        else{
            image (menu_initial_button, 10.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
        }
  }
  //display the 'lose' screen
  void gameLostScreen() {
        //mute bgm at pre-game UI
        in_game.mute();
 
        //turn on bgm when in game
        lose_game.unmute();
        
        
        image (background, 0, 0, 21 * multiplyer, 21 * multiplyer);
        fill(0, 0, 0);
        textSize(multiplyer);
        text("You Lost! Scored: " + score, 8 * multiplyer, 5 * multiplyer);
        text("Wanna play again ?", 8 * multiplyer, 7 * multiplyer);

        if(mouseX < 8.5 * multiplyer && mouseX > 3.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
            image (restart_clicked_button, 3.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
        }
        else{
            image (restart_initial_button, 3.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
        }
        
        if(mouseX < 15.5 * multiplyer && mouseX > 10.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
            image (menu_clicked_button, 10.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
        }
        else{
            image (menu_initial_button, 10.5 * multiplyer, 12 * multiplyer, 5 * multiplyer, 2 * multiplyer);
        }
  }
  
  

  //eable mouse interactions
  public void mousePressed() {
    // if we are on the initial screen when clicked, start the game
    if (gameScreen==0) {
      if(mouseX < 12.5 * multiplyer && mouseX > 7.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
        gameScreen = 8;
      }
      else if(mouseX < 12.5 * multiplyer && mouseX > 7.5 * multiplyer && mouseY < 17 * multiplyer && mouseY > 15 * multiplyer){
        exit();
      }
    }
    else if (gameScreen == 8){
      if(mouseX < 8.5 * multiplyer && mouseX > 3.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
        time_limit = 75;
        game_picked = 1;
        startGame();
      } 
      else if (mouseX < 15.5 * multiplyer && mouseX > 10.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
        time_limit = 60;
        startGame();
        game_picked = 2;
      } 
    }
    else if (gameScreen==2) {
      if(mouseX < 8.5 * multiplyer && mouseX > 3.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
            lose_game.close();
            win_game.close();
            pre_game.close();
            pick_game.close();
            in_game.close();
            setup();                  // here you MUST reset-up the board and everything
            score = 0;
            x =  10 * multiplyer;
            y = multiplyer;
            counter = 0;                  //used to set the timer 
            if (game_picked == 1){
              time_limit = 75;
            }
            else if (game_picked == 2){
              time_limit = 60;
            }
            startGame();
      }
      else if(mouseX < 15.5 * multiplyer && mouseX > 10.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
            lose_game.close();
            win_game.close();
            pre_game.close();
            pick_game.close();
            in_game.close();
            setup();                  // here you MUST reset-up the board and everything
            score = 0;
            x =  10 * multiplyer;
            y = multiplyer;
            counter = 0; 
            gameScreen = 0;
      }
      
    }
    else if (gameScreen == 3){
      if(mouseX < 8.5 * multiplyer && mouseX > 3.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
            lose_game.close();
            win_game.close();
            pre_game.close();
            pick_game.close();
            in_game.close();
            setup();                  // here you MUST reset-up the board and everything
            score = 0;
            x =  10 * multiplyer;
            y = multiplyer;
            counter = 0;                  //used to set the timer 
            if (game_picked == 1){
              time_limit = 75;
            }
            else if (game_picked == 2){
              time_limit = 60;
            }
            startGame();
       }
      else if(mouseX < 15.5 * multiplyer && mouseX > 10.5 * multiplyer && mouseY < 14 * multiplyer && mouseY > 12 * multiplyer){
            lose_game.close();
            win_game.close();
            pre_game.close();
            pick_game.close();
            in_game.close();
            setup();                  // here you MUST reset-up the board and everything
            score = 0;
            x =  10 * multiplyer;
            y = multiplyer;
            counter = 0;       
            gameScreen = 0;
      }
      
    }
  }


  /********* OTHER FUNCTIONS *********/

  // This method sets the necessary variables to start the game  
  void startGame() {
    gameScreen = 1;
  } 
  
  
  
  
  
  
  
  
  
  // enable keyboard interactions
  void keyPressed()
  {
     
    // check if arrow keys are pressed and which one to perform a specific action 
     if ( keyPressed && key == CODED ){
      if ( keyCode == LEFT )
        if (Operations.walkable_checker(newboard.rock_position_notebook, newboard.box_position_notebook,newboard.bomb_position_notebook, x-xi, y) ){
          x = x;
        }
        else{
          x = x - xi;
          //we don't need to set int [] next_position = {x - xi, y}; because we've already have
          // x = x - xi; one line before this
          int [] next_position = {x, y};
          if( false == Board.in_notebook_checker(newboard.box_position_notebook, next_position)){
            if(Board.in_notebook_checker(newboard.star_position_notebook, next_position)){
              score += 10;
         //when successfully collected stars, change the skin of the player to player_star
              int s_star = millis();
              newboard.star_time_notebook = Board.concate(newboard.star_time_notebook, s_star, 0);
              collect_stars.trigger();
              newboard.star_position_notebook = Board.delete_position(newboard.star_position_notebook, next_position);
            }
          }
        }
        
      else if (keyCode == RIGHT)
        if (Board.walkable_checker(newboard.rock_position_notebook, newboard.box_position_notebook,newboard.bomb_position_notebook, x+xi, y)){
          x = x;
        }
        else{
          x = x + xi;
          //we don't need to set int [] next_position = {x + xi, y}; because we've already have
          // x = x + xi; one line before this
          int [] next_position = {x, y};
          if(false == Board.in_notebook_checker(newboard.box_position_notebook, next_position)){
            if(Board.in_notebook_checker(newboard.star_position_notebook, next_position)){
              score += 10;
          //when successfully collected stars, change the skin of the player to player_star
              int s_star = millis();
              newboard.star_time_notebook = Board.concate(newboard.star_time_notebook, s_star, 0);
              collect_stars.trigger();
              newboard.star_position_notebook = Board.delete_position(newboard.star_position_notebook, next_position);
            }
          }
        }
      else if (keyCode == UP)
        if (Board.walkable_checker(newboard.rock_position_notebook, newboard.box_position_notebook, newboard.bomb_position_notebook, x, y-yi)){
          y = y; 
        }
        else{
          y = y - yi;
          //we don't need to set int [] next_position = {x, y-yi}; because we've already have
          // y = y - yi; one line before this
          int [] next_position = {x, y};
          if(false == Board.in_notebook_checker(newboard.box_position_notebook, next_position)){
            if(Board.in_notebook_checker(newboard.star_position_notebook, next_position)){
              score += 10;
          //when successfully collected stars, change the skin of the player to player_star
              int s_star = millis();
              newboard.star_time_notebook = Board.concate(newboard.star_time_notebook, s_star, 0);
              collect_stars.trigger();
              newboard.star_position_notebook = Board.delete_position(newboard.star_position_notebook, next_position);
            }
          }
        }
        
        
      else if (keyCode == DOWN )
        if (Board.walkable_checker(newboard.rock_position_notebook, newboard.box_position_notebook,newboard.bomb_position_notebook, x, y+yi)){
          y = y;
        }
        else{
          y = y + yi;
          //we don't need to set int [] next_position = {x, y + yi}; because we've already have
          // y = y + yi; one line before this
          int [] next_position = {x, y};
          if(false == Board.in_notebook_checker(newboard.box_position_notebook, next_position)){
            if(Board.in_notebook_checker(newboard.star_position_notebook, next_position)){
              score += 10;
         //when successfully collected stars, change the skin of the player to player_star
              int s_star = millis();
              newboard.star_time_notebook = Board.concate(newboard.star_time_notebook, s_star, 0);
              collect_stars.trigger();
              newboard.star_position_notebook = Board.delete_position(newboard.star_position_notebook, next_position);
            }
          }
        }
       
      // press ALT to drop a bomb
      else if (keyCode == ALT){
        int s1 = millis();             // take down the time when you drop the bomb
        //add the time to the bomb_time_notebook
        newboard.bomb_time_notebook = Board.concate(newboard.bomb_time_notebook, s1, 0);
        //add the current position to the bomb_position_notebook
        newboard.bomb_position_notebook = Board.concate(newboard.bomb_position_notebook, x, y);
        //add grids' positions in the bomb's explosion range to bomb_range_notebook
        newboard.bomb_range_notebook = Board.concate_bomb_range(newboard.bomb_range_notebook, x, y, xi, yi);
        //set a bomb according to bomb_position_notebook
        for (int i = 0; i< newboard.bomb_position_notebook.length; i++){
          /*
        stroke(0);                         //black boarder
        fill(0);                           //black color
        rect(newboard.bomb_position_notebook[i][0],newboard.bomb_position_notebook[i][1],20,20);
        */
        image (bomb, newboard.bomb_position_notebook[i][0], newboard.bomb_position_notebook[i][1], multiplyer, multiplyer);
        
        }
      }
     }
}
