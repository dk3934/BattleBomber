//class Board
class Board extends Operations{
  int [][] rock_position_notebook;
  int [][] box_position_notebook;
  int [][] empty_position_notebook;
  int [][] bomb_position_notebook;
  int [][] bomb_time_notebook;
  int [][] bomb_range_notebook;
  int [][] star_position_notebook;
  int [][] star_time_notebook;
  
  //write  the rock_position_notebook
  public Board(int x_length, int y_length){
    for(int i=0; i< x_length; i += x_length / 21){
          rock_position_notebook = concate(rock_position_notebook, i, 0);
    }
    for(int i=0; i< x_length; i += x_length / 21){
          rock_position_notebook = concate(rock_position_notebook, i, y_length - x_length / 21);
    }
    for(int i= x_length / 21; i< y_length- (x_length / 21); i+= x_length / 21){
          rock_position_notebook = concate(rock_position_notebook, 0, i);
    }
    for(int i=x_length / 21; i< y_length-x_length / 21; i+=x_length / 21){
          rock_position_notebook = concate(rock_position_notebook, x_length-x_length / 21, i);
    }
    for(int i=x_length / 21 + x_length / 21; i< x_length-(x_length / 21) ; i+=x_length / 21 + x_length / 21){
          for(int j = x_length / 21 + x_length / 21; j< y_length-(x_length / 21) ; j+=x_length / 21 + x_length / 21){
            rock_position_notebook = concate(rock_position_notebook, i, j);
          }
    }
    this.rock_position_notebook = rock_position_notebook;
    
    //write the empty_position_notebook
    for(int i = 0; i < x_length ; i += x_length / 21){
          for(int j = 0; j < y_length ; j += x_length / 21){
            if(inarraychecker(rock_position_notebook, i, j)){
              empty_position_notebook= empty_position_notebook;
            }
            else{
              empty_position_notebook = concate(empty_position_notebook, i, j);
            }
          }
    }
    this.empty_position_notebook = empty_position_notebook; 
    
    
    
    
    //write the box_position_notebook
    //generate random boxes' positions using empty_position_notebook
    int num_box = (int) (Math.random()*10+20);     //random number of boxes
    int counter = 0;
    while (counter < num_box){
      int xcoord_box = ((int) (Math.random()*19+1)) * (x_length / 21);
      int ycoord_box = ((int) (Math.random()*19+1)) * (x_length / 21);
      int [][] initial_position = {{10 * (x_length / 21), x_length / 21}};  //box can not be placed at the spawn point
      //To make sure that box_position_notebook contains positions: 
      //1. in empty_position_notebook, 
      //2. not in initial_position
      //3. no repetition in box_position_notebook (itself)
      if (inarraychecker(empty_position_notebook, xcoord_box,ycoord_box)){
          if(inarraychecker(initial_position, xcoord_box,ycoord_box) || inarraychecker(box_position_notebook, xcoord_box,ycoord_box)){
            counter = counter;
          }
          else{
            counter = counter + 1;
            box_position_notebook = concate(box_position_notebook, xcoord_box, ycoord_box);
          }
      }
      else{ 
        counter = counter; 
      }
    } 
    this.box_position_notebook = box_position_notebook; 
    
    // write the star position notebook
    int num_star = (int) (Math.random()*10+10);     //random number of stars
    int [][] star_position_in_box_position_notebook = new int [num_star][];
    int [][] star_processing_position_notebook = new int [num_star][];
    int [][] star_position_notebook = new int [num_star][];
    for(int k = 0; k < num_star; k++){
      int [] element = {k, 0};
      star_position_in_box_position_notebook[k] =  element;
    }
    for(int l = 0; l < num_star; l++){
      star_processing_position_notebook[l] =  box_position_notebook[star_position_in_box_position_notebook[l][0]]; 
    }
    for(int l = 0; l < num_star; l++){
      star_position_notebook[l] =  star_processing_position_notebook[l]; 
    }
    this.star_position_notebook = star_position_notebook;
  }
}
