//class Board
public static class Operations{

  //method that can concatenate two arrays
  public static int [][] concate(int [][] notebook, int x_coord, int y_coord){
     int [] new_element = {x_coord, y_coord};
     int length;
     try{
       length = notebook.length;
     }
     catch (NullPointerException e){
       length = 0;
     }
     int [][] updated = new int [length + 1][];
     if(length == 0){
              
       updated [0] = new_element;
     }
     else{
       for(int i= 0; i<length; i++){
         updated[i] = notebook[i];
       }
        updated[length] = new_element;
     }
     return updated;
     }
     
  //method that delete the first element in the array
  public static int [][] deletefirst(int [][] notebook){
     int length;
     try{
       length = notebook.length;
     }
     catch (NullPointerException e){
       length = 0;
     }
     int [][] updated = new int [length - 1][];
     if(length == 0){
     }
     else{
       for(int i= 0; i<length-1; i++){
         updated[i] = notebook[i+1];
       }
     }
     return updated;
     }
     
     // check if array [x,y], which corresponds to coordinate (x,y) is in the notebook
     // return true if (x,y) is in the input notebook, false if not
     public static boolean inarraychecker(int [][] notebook, int x, int y){
       int [] coord_array = {x,y};
       boolean result = false;             //returns false if the notebook is empty
       int length;
       try{
         length = notebook.length;
       }
       catch (NullPointerException e){
         length = 0;
         result = false;
       }
       int i = 0;
       while(i < length){
         if (Arrays.equals(coord_array, notebook[i])){
           result = true;
           break;
         }
         else{
           result = false;
           i++;
         }
       }
       return result;
     }
     
     //put x-coord and y-coord together in a single array
     public int[] array_coord(int x, int y){
       int [] result = {x,y};
       return result;
     }
     
     // check if the road is blocked by the rock, the box or the bomb
     public static boolean walkable_checker(int [][] notebook1, int [][] notebook2, int [][]notebook3, int x, int y){
       boolean result1 = inarraychecker(notebook1, x,y);
       boolean result2 = inarraychecker(notebook2, x,y);
       boolean result3 = inarraychecker(notebook3, x,y);
       boolean result = result1 || result2 || result3;
       return result;
     }
     //method that can concatenate two arrays
  public static int [][] concate_bomb_range(int [][] notebook, int x_coord, int y_coord, int stepx, int stepy){
     notebook = concate(notebook, x_coord - stepx, y_coord);
     notebook = concate(notebook, x_coord + stepx, y_coord);
     notebook = concate(notebook, x_coord, y_coord + stepy);
     notebook = concate(notebook, x_coord, y_coord - stepy);
     return notebook;
     }
     
     //check if a position is in the specified notebook
  public static boolean in_notebook_checker(int[][] notebook, int[] position){
       boolean result = false;             //returns false if the notebook is empty
       int length;
       try{
         length = notebook.length;
       }
       catch (NullPointerException e){
         length = 0;
         result = false;
       }
       int i = 0;
       while(i < length){
         if (Arrays.equals(position, notebook[i])){
           result = true;
           break;
         }
         else{
           result = false;
           i++;
         }
       }
       return result;
  }
  //delete a position is in the specified notebook
  public static int[][] delete_position(int[][] notebook, int[] position){
       int length;
       try{
         length = notebook.length; 
       }
       catch (NullPointerException e){
         length = 0;
         return notebook;
       }
       int i = 0;
       int [][] updated = new int [length - 1][];
       while(i < length){
         if (Arrays.equals(position, notebook[i])){
           for(int j = 0; j<i;j++){
             updated[j]=notebook[j];
           }
           for(int j = i; j<length-1;j++){
             updated[j]=notebook[j+1];
           }
           i++;
         }
         else{
           i++;
         }
       }
       return updated;
  }
  //delete a position in one notebook if it is in another notebook
  public static int[][] compare_delete(int[][] deleting_notebook, int[][] checker_notebook){
         // check if length of the deleting_notebook is 0 or not
        int length;
         try{
           length = deleting_notebook.length; 
         }
         catch (NullPointerException e){
           length = 0;
           return deleting_notebook;
         }
         //copy the original (input) deleting_notebook for future use
         int [][] copy = new int [length][];
         if(length != 0){
           for(int l = 0; l<length; l++){
             copy[l] = deleting_notebook[l];
           }
         }
         //find how many elements in the deleting_notebook should be deleted
         int j = 0;
         for (int i = 0; i<length; i++){
           if (in_notebook_checker(checker_notebook, copy[i])){
             j++;
           }
         }
         //setup the return value
         int [][] updated = new int [length - j][];
         //start deleting!
         if (j != 0){
            for (int i = 0; i<length; i++){
               if (in_notebook_checker(checker_notebook, copy[i])){
                 deleting_notebook = delete_position(deleting_notebook, copy[i]);
               }
            }
            for(int k = 0; k<length - j; k++){
              updated[k] = deleting_notebook[k];
            }
         }
         else{
            updated = deleting_notebook;
         }
         return updated;
  }
}
