//Coded by R. Heman
public class RatInMaze{
    public static void printPath(int path[][]){
        System.out.println("-------Solution-------");
        for(int i=0; i<path.length; i++){
            for(int j=0; j<path.length; j++){
                System.out.print(path[i][j] + " ");
            }
            System.out.println();
        }
    }
	public static void run(int maze[][], int path[][], int row, int col){
        //base case
        if(row==maze.length-1 && col==maze.length ) printPath(path);
        if(row==maze.length || col==maze.length || row<0 || col<0){return;}
        if(maze[row][col]==0 || path[row][col]==1 ){return;}

        //recursive case
        path[row][col]=1;
        run(maze, path, row, col+1);    //Right
        run(maze, path, row+1, col);    //Down
        run(maze, path, row, col-1);    //Left
        run(maze, path, row-1, col);    //Up
        path[row][col]=0;
	}
	public static void main(String args[]){
		int maze[][]={  { 1, 1, 1, 1 },
				        { 1, 1, 1, 0 },
				        { 1, 1, 0, 1 },
				        { 1, 1, 1, 1 }
		};
		int path[][]= new int [maze.length][maze.length];
		for(int i=0; i<maze.length; i++) for(int j=0; j<maze.length; j++) path[i][j]=0;

		run(maze, path, 0, 0);
	}
}
