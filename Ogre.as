package {
	
	import flash.display.DisplayObject;
	
	public class Ogre extends BasicEnemy {
		
		public function Ogre(obstaclesArray:Array = null, docClass:Main = null) {
			
			super(obstaclesArray, "ogre", docClass);
		}
	}
}