package {
	
	import BasicEnemy;
	import flash.display.DisplayObject;
	
	public class Rat extends BasicEnemy {
		
		public function Rat(obstaclesArray:Array = null, docClass:Main = null) {
			
			super(obstaclesArray, "rat", docClass);
			
		}
	}
}